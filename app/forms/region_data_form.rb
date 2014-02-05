# -*- encoding : utf-8 -*-
module RegionDataForm
  include Dima::Html

  ACT_SYNC = Action.new(label: 'რეგიონების სინქრონიზაცია', tooltip: 'რეგიონების სინქრონიზაცია', icon: '/assets/fff/arrow_refresh.png', method: 'post', confirm: 'ნამდვილად გინდათ სინქრონიზაცია?', url: lambda{|v| Rails.application.routes.url_helpers.call_sync_regions_path})
  ACT_EDITMOB = Action.new(label: '', tooltip: 'მობილურების შეცვლა', icon: '/assets/fff/pencil.png', url: lambda{|v| Rails.application.routes.url_helpers.call_edit_region_path(v.id) })
  ACT_DELMOB = Action.new(label: '', tooltip: 'მობილურების წაშლა', icon: '/assets/fff/delete.png', url: lambda{|v| Rails.application.routes.url_helpers.call_delete_region_path(v.id)}, method: 'delete', confirm: 'ნამდვილად გინდათ წაშლა?')

  def self.region_data_table(data)
    tbl = Table.new(title:  'რეგიონები', icon: '/assets/fff/bricks.png')
    tbl.cols << TextField.new(name: 'region.name', label: 'რეგიონი', readonly: true, required: true)
    tbl.cols << TextField.new(name: 'mobile1', label: 'მობილური 1')
    tbl.cols << TextField.new(name: 'mobile2', label: 'მობილური 2')
    tbl.cols << BooleanField.new(name: 'region_status', label: 'სტატუსი')
    tbl.actions << ACT_SYNC
    tbl.item_actions << ACT_EDITMOB << ACT_DELMOB
    tbl.vals = data
    tbl
  end

  def self.region_data_form(data, auth_token)
    form = Form.new(title: 'რეგიონი', icon: '/assets/fff/bricks.png', submit: 'შენახვა', auth_token: auth_token)
    form.col1 << TextField.new(name: 'region.name', label: 'რეგიონი', readonly: true, required: true)
    form.col1 << TextField.new(name: 'mobile1', label: 'მობილური 1')
    form.col1 << TextField.new(name: 'mobile2', label: 'მობილური 2')
    form << data
    form
  end

end
