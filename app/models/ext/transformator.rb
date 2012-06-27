# -*- encoding : utf-8 -*-
class Ext::Transformator
  include Mongoid::Document
  include Mongoid::Timestamps

  # gis part
  field :objectid
  field :account
  field :tp_name
  field :tr_name

  # bs part
  field :custkey
  field :accnumb
  field :custname
  field :acckey
  field :accid

  # indices
  index [[:tp_name, Mongo::ASCENDING], [:tr_name, Mongo::ASCENDING]]
  index :objectid
  index :acckey

  def self.sync
    Gis::Transformator.order('tp_name ASC, tr_name ASC').each do |gis_tr|
      tr = Ext::Transformator.where(objectid: gis_tr.objectid).first || Ext::Transformator.new(objectid: gis_tr.objectid)
      tr.tp_name = gis_tr.tp_name
      tr.account = gis_tr.account
      tr.tr_name = gis_tr.tr_name
      customer = Bs::Customer.where(accnumb: gis_tr.tp_name).first
      if customer
        tr.custkey = customer.custkey
        tr.accnumb = customer.accnumb
        tr.custname = customer.custname.to_ka
        accid = "#{customer.accnumb}-#{gis_tr.tr_name[1]}"
        account = Bs::Account.where(custkey: customer.custkey, accid: accid).first
        if account
          tr.acckey = account.acckey
          tr.accid  = account.accid
        end
      end
      tr.save
    end
  end

end
