# -*- encoding : utf-8 -*-
module TaskForm
  include Dima::Html

  STATUS  = SelectField.new(name: 'status', label: 'სტატუსი', collection: Call::Status.asc(:order_by))
  STATUS_ICON = IconField.new(name: 'status.icon', label: '')
  CREATED = DateField.new(name: 'created_at', label: 'შეიქმნა', formatter: '%d-%b-%Y %H:%M:%S')
  UPDATED = DateField.new(name: 'updated_at', label: 'შეიცვალა', formatter: '%d-%b-%Y %H:%M:%S')
  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true)
  REGION = TextField.new(name: 'region.name', label: 'ბიზნ.ცენტრი', required: true)
  TITLE = TextField.new(name: 'title', label: 'სათაური', required: true, width: 500, url: lambda{|v| Rails.application.routes.url_helpers.call_show_customer_task_path(id: v.id)})
  SIZE = NumberField.new(name: 'comments.size', label: 'კომენტ.', precision: 0)
  BODY = TextField.new(name: 'body', label: 'დეტალები', required: true, textarea: true, width: 500, height: 100)
  BODY_HTML = TextField.new(name: 'body_html', label: 'დეტალები', required: true)
  USER = TextField.new(name: 'user.full_name', label: 'ოპერატორი', required: true)

  def self.edit_task_form(task, cust, auth_token)
    title = task.nil? ? 'ახალი დავალება' : 'დავალების შეცვლა'
    submit = task.nil? ? 'ახალი დავალება' : 'დავალების შენახვა'
    icon = task.nil? ? '/assets/fff/clock_add.png' : '/assets/fff/clock_edit.png'
    form = Form.new(title: title, icon: icon, submit: submit, auth_token: auth_token)
    form.col1 << TITLE.clone << BODY.clone << STATUS.clone
    form.edit = true
    form
  end

  def self.task_form(task)
    form = Form.new(title: 'დავალება', icon: '/assets/fff/clock.png')
    form.col1 << ACCNUMB.clone << REGION.clone << STATUS.clone << TITLE.clone << BODY_HTML.clone
    form.col2 << USER.clone << CREATED.clone << UPDATED.clone
    form.actions << Action.new(label: 'შეცვლა', icon: '/assets/fff/pencil.png', url: lambda{|v| Rails.application.routes.url_helpers.call_edit_customer_task_path(id: v.id)})
    form << task
    form
  end

  def self.task_table(tasks, cust = nil)
    tbl = Table.new(title: 'დავალებები', icon: '/assets/fff/clock.png')
    title_size = ComplexField.new(label: 'დავალების შინაარსი', fields: [SIZE.clone, TITLE.clone], url: TITLE.url)
    status = ComplexField.new(label: 'სტატუსი', fields: [STATUS_ICON.clone, STATUS.clone])
    tbl.cols << ACCNUMB.clone << title_size << status << REGION.clone << CREATED.clone
    tbl.actions << Action.new(label: 'ახალი დავალება', tooltip: 'აბონენტზე ახალი დავალების შექმნა', icon: '/assets/fff/clock_add.png', url: Rails.application.routes.url_helpers.call_new_customer_task_path(custkey: cust.custkey)) if cust
    tbl.item_actions << Action.new(label: 'შეცვლა', icon: '/assets/fff/pencil.png', url: lambda{|v| Rails.application.routes.url_helpers.call_edit_customer_task_path(id: v.id)})
    tbl.item_actions << Action.new(label: '', tooltip: 'დავალების წაშლა', icon: '/assets/fff/delete.png', method: 'delete', confirm: 'დარწმუნებული ხართ?', url: lambda {|v| Rails.application.routes.url_helpers.call_delete_customer_task_path(id: v.id)})
    tbl.vals = tasks
    tbl
  end

  CMNT_USER = TextField.new(name: 'user.full_name', label: 'ოპერატორი')
  CMNT_CREATED = DateField.new(name: 'created_at', label: 'შეიქმნა', formatter: '%d-%b-%Y %H:%M:%S')
  CMNT_TEXT_HTML = TextField.new(name: 'text_html', label: 'ტექსტი', required: true, textarea: true, width: 500, height: 100)

  def self.comments_table(task)
    tbl = Table.new(title: 'კომენტარები', icon: '/assets/fff/comment.png')
    tbl.cols << CMNT_USER.clone << CMNT_TEXT_HTML.clone << CMNT_CREATED.clone
    tbl.vals = task.comments
    url1 = Rails.application.routes.url_helpers.call_new_task_comment_path(id: task.id)
    url2 = lambda{ |v| Rails.application.routes.url_helpers.call_edit_task_comment_path(id: v.id) }
    url3 = lambda {|v| Rails.application.routes.url_helpers.call_delete_task_comment_path(id: v.id) }
    tbl.actions << Action.new(label: 'კომენტარის დამატება', tooltip: 'დავალებაზე კომენტარის დამატება', icon: '/assets/fff/comment_add.png', url: url1)
    tbl.item_actions << Action.new(label: 'შეცვლა', tooltip: 'კომენტარის შეცვლა', icon: '/assets/fff/pencil.png', url: url2)
    tbl.item_actions << Action.new(label: '', tooltip: 'კომენტარის წაშლა', icon: '/assets/fff/delete.png', method: 'delete', confirm: 'დარწმუნებული ხართ?', url: url3)
    tbl
  end

  def self.edit_comment_form(comment, task, auth_token)
    title = comment.nil? ? 'ახალი კომენტარი' : 'კომენტარის შეცვლა'
    submit = comment.nil? ? 'ახალი კომენტარი' : 'კომენტარის შენახვა'
    icon = comment.nil? ? '/assets/fff/comment_add.png' : '/assets/fff/comment_edit.png'
    form = Form.new(title: title, icon: icon, submit: submit, auth_token: auth_token)
    form.col1 << TextField.new(name: 'text', label: 'ტექსტი', required: true, textarea: true, width: 500, height: 100)
    form.edit = true
    form
  end

end
