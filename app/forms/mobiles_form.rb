# -*- encoding : utf-8 -*-
module MobilesForm
  include Dima::Html

  REGION  = TextField.new(name: 'region.name', label: 'რეგიონი')
  MOBILE1 = TextField.new(name: 'mobile1', label: 'მობილური 1')
  MOBILE2 = TextField.new(name: 'mobile2', label: 'მობილური 2')

  ACT_SYNC = Action.new(label: 'რეგიონების სინქრონიზაცია', tooltip: 'რეგიონების სინქრონიზაცია', icon: '/assets/fff/arrow_refresh.png', method: 'post', confirm: 'ნამდვილად გინდათ სინქრონიზაცია?', url: Rails.application.routes.url_helpers.call_sync_mobiles_path)

  def self.mobile_table(mobiles)
    tbl = Table.new(title:  'მობილურები', icon: '/assets/fff/phone.png')
    tbl.cols << REGION.clone << MOBILE1.clone << MOBILE2.clone
    tbl.actions << ACT_SYNC
    #tbl.item_actions << ACT_EDITSTAT << ACT_DELSTAT
    tbl.vals = mobiles
    tbl
  end

end
