# -*- encoding : utf-8 -*-
class Ext::Transformator
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

  # totals
  field :street_count, type: Integer
  field :account_count, type: Integer

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
          tr.account_count = Bs::Accrel.where(base_acckey: account.acckey).count
          if tr.account_count == 0
            tr.street_count = 0
          else
            tr.street_count = Bs::Accrel.connection.execute(%Q{
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
      unless tr.acckey
        tr.account_count = 0
        tr.street_count = 0
      end
      tr.save
    end
  end

  def to_s
    "#{self.tp_name} &rarr; #{self.tr_name}"
  end

end
