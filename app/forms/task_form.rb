# -*- encoding : utf-8 -*-
module TaskForm
  include Dima::Html

  COMPLETE = BooleanField.new(name: 'complete', label: 'შესრ?')
  CREATED = DateField.new(name: 'created_at', label: 'შეიქმნა', formatter: '%d-%b-%Y %H:%M:%S')
  UPDATED = DateField.new(name: 'updated_at', label: 'შეიცვალა', formatter: '%d-%b-%Y %H:%M:%S')
  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true)
  REGION = TextField.new(name: 'region.name', label: 'ბიზნ.ცენტრი', required: true)
  TITLE = TextField.new(name: 'title', label: 'სათაური', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_show_customer_task_path(id: v.id)})
  BODY = TextField.new(name: 'body', label: 'დეტალები', required: true, textarea: true, width: 500, height: 100)

  def self.new_task_form(cust, auth_token)
    form = Form.new(title: 'ახალი დავალება', icon: '/assets/fff/clock_add.png', submit: 'ახალი დავალება', auth_token: auth_token)
    form.col1 << TITLE.clone
    form.col1 << BODY.clone
    form.edit = true
    form
  end

  def self.task_form(task)
    form = Form.new(title: 'დავალება', icon: '/assets/fff/clock.png')
    form.col1 << ACCNUMB << REGION << TITLE << BODY
    form.col2 << COMPLETE << CREATED << UPDATED
    form << task
    form
  end

  def self.task_table(tasks, cust = nil)
    tbl = Table.new(title: 'დავალებები', icon: '/assets/fff/clock.png')
    tbl.cols << ACCNUMB.clone << CREATED.clone << TITLE.clone << COMPLETE.clone << REGION.clone
    tbl.actions << Action.new(label: 'ახალი დავალება', tooltip: 'აბონენტზე ახალი დავალების შექმნა', icon: '/assets/fff/clock_add.png', url: Rails.application.routes.url_helpers.call_new_customer_task_path(custkey: cust.custkey)) if cust
    tbl.item_actions << Action.new(label: '', tooltip: 'დავალების წაშლა', icon: '/assets/fff/delete.png', method: 'delete', confirm: 'დარწმუნებული ხართ?', url: lambda {|v| Rails.application.routes.url_helpers.call_delete_customer_task_path(id: v.id)})
    tbl.vals = tasks
    tbl
  end

end
