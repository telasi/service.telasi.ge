# -*- encoding : utf-8 -*-
module MobilesForm
  include Dima::Html

  REGION  = TextField.new(name: 'region.name', label: 'რეგიონი', readonly: true, required: true)
  MOBILE1 = TextField.new(name: 'mobile1', label: 'მობილური 1')
  MOBILE2 = TextField.new(name: 'mobile2', label: 'მობილური 2')

  ACT_SYNC = Action.new(label: 'რეგიონების სინქრონიზაცია', tooltip: 'რეგიონების სინქრონიზაცია', icon: '/assets/fff/arrow_refresh.png', method: 'post', confirm: 'ნამდვილად გინდათ სინქრონიზაცია?', url: Rails.application.routes.url_helpers.call_sync_mobiles_path)
  ACT_EDITMOB = Action.new(label: '', tooltip: 'მობილურების შეცვლა', icon: '/assets/fff/pencil.png', url: lambda{|v| Rails.application.routes.url_helpers.call_edit_mobiles_path(v.id) })
  ACT_DELMOB = Action.new(label: '', tooltip: 'მობილურების წაშლა', icon: '/assets/fff/delete.png', url: lambda{|v| Rails.application.routes.url_helpers.call_delete_mobiles_path(v.id)}, method: 'delete', confirm: 'ნამდვილად გინდათ წაშლა?')

  def self.mobiles_table(mobiles)
    tbl = Table.new(title:  'მობილურები', icon: '/assets/fff/phone.png')
    tbl.cols << REGION.clone << MOBILE1.clone << MOBILE2.clone
    tbl.actions << ACT_SYNC
    tbl.item_actions << ACT_EDITMOB << ACT_DELMOB
    tbl.vals = mobiles
    tbl
  end

  def self.mobiles_form(stat, auth_token)
    form = Form.new(title: 'სტატუსი', icon: '/assets/fff/application_view_icons.png', submit: 'შენახვა', auth_token: auth_token)
    form.col1 << REGION.clone << MOBILE1.clone << MOBILE2.clone
    form << stat
    form
  end

end
