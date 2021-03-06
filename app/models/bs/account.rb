# -*- encoding : utf-8 -*-
class Bs::Account < ActiveRecord::Base
  TYPE_SUBSTATION = 1
  TYPE_FEEDER = 2
  TYPE_TRANSF = 3
  TYPE_METER  = 4

  ACTIVE = 0   # აქტიური
  CLOSED = 1   # დროებით დახურული
  CANCELED = 2 # გაუქმებული

  self.table_name  = 'bs.account'
  self.primary_key = :acckey
  belongs_to :customer,      class_name: 'Bs::Customer',      foreign_key: :custkey
  belongs_to :address,       class_name: 'Bs::Address',       foreign_key: :premisekey
  belongs_to :meter_type,    class_name: 'Bs::MeterType',     foreign_key: :mttpkey
  has_one    :note,          class_name: 'Bs::Note',          foreign_key: :notekey
  has_many   :tariffs,       class_name: 'Bs::AccountTariff', foreign_key: :acckey, order: :acctarkey
  has_one    :route_account, class_name: 'Bs::RouteAccount',  foreign_key: :acckey

  def status
    self.statuskey == 0 ? 'აქტიური' : 'გაუქმებული'
  end


  # Returns all meter accounts under this account.
  def deep_children
    join_query = "INNER JOIN (SELECT DISTINCT rel.acckey FROM bs.accrel rel START WITH acckey = #{self.acckey} CONNECT BY PRIOR acckey = base_acckey) r ON account.acckey = r.acckey"
    Bs::Account.joins(join_query).where('account.acctype = ?', TYPE_METER)
  end

  def deep_active_children
    deep_children.where('account.statuskey IN (?)', [ACTIVE, CLOSED])
  end


  # GIS log on transformator
  def last_gis_log
    if self.acctype == TYPE_TRANSF
      transf = Ext::Gis::Transformator.where(acckey: self.acckey).first
      Ext::Gis::Log.where(objectid: transf.objectid).last if transf
    end
  end

  def account_type
    case self.acctype
    when TYPE_SUBSTATION then 'სადგური'
    when TYPE_FEEDER then 'ფიდერი'
    when TYPE_TRANSF then 'ტრანსფორმატორი'
    when TYPE_METER then 'მრიცხველი'
    else '?'
    end
  end

  def account_type_icon
    case self.acctype
    when TYPE_SUBSTATION then '/assets/fff/lightning.png'
    when TYPE_FEEDER then '/assets/fff/wrench.png'
    when TYPE_TRANSF then '/assets/fff/cog.png'
    when TYPE_METER then '/assets/fff/lightbulb.png'
    else '?'
    end
  end

  def parent
    rel = Bs::AccountRelation.where(acckey: self.acckey).first
    rel.parent if rel
  end

  def parents
    pars = []
    curr = self
    while not curr.nil?
      pars << curr
      curr = curr.parent
    end
    pars
  end

  def tp; self.parents.select{ |x| x.acctype == TYPE_TRANSF }.first end
  def to_s; self.accid end
end
