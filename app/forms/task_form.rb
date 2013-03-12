# -*- encoding : utf-8 -*-
module TaskForm
  include Dima::Html

  COMPLETE = BooleanField.new(name: 'complete', label: 'შესრ?')
  CREATED = DateField.new(name: 'created_at', label: 'თარიღი', required: true)
  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_customer_tasks_path(custkey: v.customer.custkey)})
  REGION = TextField.new(name: 'region.name', label: 'ბიზნ.ცენტრი', required: true)
  TITLE = TextField.new(name: 'title', label: 'სათაური', required: true)
  BODY = TextField.new(name: 'body', label: 'დეტალები', required: true)

  def self.new_task_form(cust)
    form = Form.new(title: 'ახალი დავალება', icon: '/assets/fff/clock_add.png', submit: 'ახალი დავალება')
    form.col1 << TITLE << BODY
    form.edit = true
    form
  end

  def self.task_table(tasks, cust = nil)
    tbl = Table.new(title: 'დავალებები', icon: '/assets/fff/clock.png')
    tbl.cols << ACCNUMB << CREATED << TITLE << COMPLETE << REGION
    tbl.actions << Action.new(label: 'ახალი დავალება', tooltip: 'აბონენტზე ახალი დავალების შექმნა', icon: '/assets/fff/clock_add.png', url: Rails.application.routes.url_helpers.call_new_customer_task_path(custkey: cust.custkey)) if cust
    tbl.vals = tasks
    tbl
  end

end
