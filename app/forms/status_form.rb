# -*- encoding : utf-8 -*-
module StatusForm
  include Dima::Html

  # fields

  NAME     = TextField.new(name: 'name', label: 'დასახელება', required: true, width: 500)
  ICON     = TextField.new(name: 'icon', label: 'გამოსახულება', required: true, width: 500)
  DEFAULT  = BooleanField.new(name: 'default', label: 'საწყისი?')
  START    = BooleanField.new(name: 'open', label: 'ღია?')
  ORDER_BY = NumberField.new(name: 'order_by', label: 'დალაგება', precision: 0, required: true, width: 50)

  ACT_NEWSTAT = Action.new(label: 'ახალი სტატუსი', tooltip: 'ახალი სტატუსის დამატება', icon: '/assets/fff/add.png', url: Rails.application.routes.url_helpers.call_new_status_path)
  ACT_EDITSTAT = Action.new(label: '', tooltip: 'სტატუსის შეცვლა', icon: '/assets/fff/pencil.png', url: lambda{|v| Rails.application.routes.url_helpers.call_edit_status_path(v.id) })
  ACT_DELSTAT = Action.new(label: '', tooltip: 'სტატუსის წაშლა', icon: '/assets/fff/delete.png', url: lambda{|v| Rails.application.routes.url_helpers.call_delete_status_path(v.id)}, method: 'delete', confirm: 'ნამდვილად გინდათ წაშლა?')

  def self.stat_table(stats)
    tbl = Table.new(title:  'სტატუსები', icon: '/assets/fff/application_view_icons.png')
    tbl.cols << NAME.clone << ICON.clone << DEFAULT.clone << START.clone << ORDER_BY.clone
    tbl.actions << ACT_NEWSTAT
    tbl.item_actions << ACT_EDITSTAT << ACT_DELSTAT
    tbl.vals = stats
    tbl
  end

  def self.status_form(stat, auth_token)
    form = Form.new(title: 'სტატუსი', icon: '/assets/fff/application_view_icons.png', submit: 'შენახვა', auth_token: auth_token)
    form.col1 << NAME.clone << ICON.clone << DEFAULT.clone << START.clone << ORDER_BY.clone
    form << stat
    form
  end

end
