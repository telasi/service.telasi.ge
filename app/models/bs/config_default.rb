# -*- encoding : utf-8 -*-
class Bs::ConfigDefault < ActiveRecord::Base
  self.table_name  = 'bs.personal_config_defaults'

  def self.value(type, regionkey, custcatkey)
    self.where(limittype: type, regionkey: regionkey, custcatkey: custcatkey).first[:limitvalue].to_int
  end

end
