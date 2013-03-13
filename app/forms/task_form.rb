# -*- encoding : utf-8 -*-
module TaskForm
  include Dima::Html

  COMPLETE = BooleanField.new(name: 'complete', label: 'დასრ?')
  COMPLETE2 = BooleanField.new(name: 'complete', label: 'დასრულებულია?', required: true)
  CREATED = DateField.new(name: 'created_at', label: 'შეიქმნა', formatter: '%d-%b-%Y %H:%M:%S')
  UPDATED = DateField.new(name: 'updated_at', label: 'შეიცვალა', formatter: '%d-%b-%Y %H:%M:%S')
  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true)
  REGION = TextField.new(name: 'region.name', label: 'ბიზნ.ცენტრი', required: true)
  TITLE = TextField.new(name: 'title', label: 'სათაური', required: true, width: 500, url: lambda{|v| Rails.application.routes.url_helpers.call_show_customer_task_path(id: v.id)})
  BODY = TextField.new(name: 'body', label: 'დეტალები', required: true, textarea: true, width: 500, height: 100)
  BODY_HTML = TextField.new(name: 'body_html', label: 'დეტალები', required: true)
  USER = TextField.new(name: 'user.full_name', label: 'ოპერატორი', required: true)

  def self.edit_task_form(task, cust, auth_token)
    title = task.nil? ? 'ახალი დავალება' : 'დავალების შეცვლა'
    submit = task.nil? ? 'ახალი დავალება' : 'დავალების შენახვა'
    icon = task.nil? ? '/assets/fff/clock_add.png' : '/assets/fff/clock_edit.png'
    form = Form.new(title: title, icon: icon, submit: submit, auth_token: auth_token)
    form.col1 << TITLE.clone << BODY.clone << COMPLETE2.clone
    form.edit = true
    form
  end

  def self.task_form(task)
    form = Form.new(title: 'დავალება', icon: '/assets/fff/clock.png')
    form.col1 << ACCNUMB << REGION << COMPLETE2 << TITLE << BODY_HTML
    form.col2 << USER << CREATED << UPDATED
    form.actions << Action.new(label: 'შეცვლა', icon: '/assets/fff/pencil.png', url: lambda{|v| Rails.application.routes.url_helpers.call_edit_customer_task_path(id: v.id)})
    form << task
    form
  end

  def self.task_table(tasks, cust = nil)
    tbl = Table.new(title: 'დავალებები', icon: '/assets/fff/clock.png')
    tbl.cols << ACCNUMB.clone << TITLE.clone << COMPLETE.clone << REGION.clone << CREATED.clone
    tbl.actions << Action.new(label: 'ახალი დავალება', tooltip: 'აბონენტზე ახალი დავალების შექმნა', icon: '/assets/fff/clock_add.png', url: Rails.application.routes.url_helpers.call_new_customer_task_path(custkey: cust.custkey)) if cust
    tbl.item_actions << Action.new(label: 'შეცვლა', icon: '/assets/fff/pencil.png', url: lambda{|v| Rails.application.routes.url_helpers.call_edit_customer_task_path(id: v.id)})
    tbl.item_actions << Action.new(label: '', tooltip: 'დავალების წაშლა', icon: '/assets/fff/delete.png', method: 'delete', confirm: 'დარწმუნებული ხართ?', url: lambda {|v| Rails.application.routes.url_helpers.call_delete_customer_task_path(id: v.id)})
    tbl.vals = tasks
    tbl
  end

  CMNT_USER = TextField.new(name: 'user.full_name', label: 'ოპერატორი')
  CMNT_CREATED = DateField.new(name: 'created_at', label: 'შეიქმნა', formatter: '%d-%b-%Y %H:%M:%S')
  CMNT_TEXT = TextField.new(name: 'text', label: 'ტექსტი')

  def self.comments_table(task)
    tbl = Table.new(title: 'კომენტარები', icon: '/assets/fff/comment.png')
    tbl.cols << CMNT_USER << CMNT_TEXT << CMNT_CREATED
    tbl.vals = task.comments
    tbl.actions << Action.new(label: 'კომენტარის დამატება', tooltip: 'დავალებაზე კომენტარის დამატება', icon: '/assets/fff/comment_add.png')
    tbl
  end

end
