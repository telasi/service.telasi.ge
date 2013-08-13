# -*- encoding : utf-8 -*-
class Ext::Gis::Transformator
  include Mongoid::Document
  include Mongoid::Timestamps

  # gis part
  field :objectid, type: Integer
  field :account,  type: Integer
  field :tp_name,  type: String
  field :tr_name,  type: String

  # bs part
  field :custkey,  type: Integer
  field :accnumb,  type: String
  field :custname, type: String
  field :acckey,   type: Integer
  field :accid,    type: String
  field :address,  type: String

  # account data
  field :regionkey,  type: Integer
  field :regionname, type: String
  field :street_count,  type: Integer
  field :account_count, type: Integer

  # indecies
  index({ tp_name: 1, tr_name: 1 })
  index({ objectid: 1 })
  index({ acckey: 1 })

  def self.sync
    Gis::Transformator.order('tp_name ASC, tr_name ASC').each do |gis_tr|
      tr = Ext::Gis::Transformator.where(objectid: gis_tr.objectid).first || Ext::Gis::Transformator.new(objectid: gis_tr.objectid)
      tr.tp_name = gis_tr.tp_name
      tr.account = gis_tr.account
      tr.tr_name = gis_tr.tr_name
      customer = Bs::Customer.where(accnumb: gis_tr.tp_name).first
      if customer
        tr.custkey = customer.custkey
        tr.accnumb = customer.accnumb
        tr.custname = customer.custname.to_ka
        accid = "#{customer.accnumb}-#{gis_tr.tr_name[1]}"
        account = Bs::Account.where(custkey: tr.custkey, accid: accid).first
        if account
          tr.acckey = account.acckey
          tr.accid  = account.accid
          tr.sync
        end
      end
      unless tr.acckey
        tr.account_count = 0
        tr.street_count = 0
      end
      tr.save
    end
  end

  def sync
    if self.acckey
      account = Bs::Account.find(self.acckey)
      self.account_count = Bs::Accrel.where(base_acckey: self.acckey).count
      self.address = account.address.to_s
      if account.address
        self.regionkey = account.address.region.regionkey
        self.regionname = account.address.region.regionname.to_ka
      end
      if self.account_count == 0
        self.street_count = 0
      else
        self.street_count = Bs::Accrel.connection.execute(%Q{
          SELECT count(*) FROM (SELECT adrs.streetkey FROM
            bs.accrel ar
            INNER JOIN bs.account acc ON ar.acckey = acc.acckey
            INNER JOIN bs.address adrs ON acc.premisekey = adrs.premisekey
          WHERE base_acckey=#{account.acckey}
          GROUP BY adrs.streetkey)
        }).fetch[0].to_i
      end
    end
  end

  def to_s
    "#{self.tp_name} &rarr; #{self.tr_name}".html_safe
  end

end
