# -*- encoding : utf-8 -*-
module CallHelper
  def call_tasks_table(tasks, opts = {})
    title = opts[:title] || 'დავალებები'
    table_for tasks, title: title, icon: '/assets/fff/clock.png', collapsible: true do |t|
      t.text_field 'customer.accnumb', icon: ->(x){x.status.icon}, tag: 'code', label: 'აბ.#'
      t.complex_field label: 'შინაარსი', url: ->(x){ call_show_customer_task_url(id: x.id) } do |c|
        c.text_field 'category', tag: 'strong'
        c.text_field 'title', class: 'muted', empty: false
      end
      t.complex_field label: 'ბ/ც და მისამართი' do |c|
        c.text_field 'customer.address.region', tag: 'strong'
        c.text_field 'customer.address.to_s2', class: 'muted'
      end
      t.date_field 'created_at', formatter: '%d-%b-%Y %H:%M:%S', label: 'შექმნა'
      t.paginate records: 'დავალება'
      yield t if block_given?
    end
  end
end
