# -*- encoding : utf-8 -*-
module CallHelper
  def call_tasks_table(tasks, opts = {})
    title = opts[:title] || 'დავალებები'
    table_for tasks, title: title, icon: '/assets/fff/clock.png', collapsible: true do |t|
      t.text_field 'customer.accnumb', icon: ->(x){ x.status.icon rescue nil }, tag: 'code', label: 'აბ.#'
      t.complex_field label: 'შინაარსი', url: ->(x){ call_show_customer_task_url(id: x.id) } do |c|
        c.text_field 'category', tag: 'strong'
        c.text_field 'title', class: 'muted', empty: false
      end
      t.complex_field label: 'ბ/ც და მისამართი' do |c|
        c.text_field 'customer.address.region', tag: 'strong'
        c.text_field 'customer.address.to_s2', class: 'muted'
      end
      t.date_field 'created_at', formatter: '%d/%m/%Y %H:%M', label: 'შექმნა'
      t.paginate records: 'დავალება'
      yield t if block_given?
    end
  end

  def call_outage_form(outage, opts={})
    forma_for outage, title: opts[:title], icon: opts[:icon], collapsible: true do |f|
      f.text_field 'accnumb', label: 'ფიდერის #', autofocus: true, required: true
      f.complex_field label: 'დასაწყისი', required: true do |f|
        f.date_field 'start_date'
        f.text_field 'start_time', width: '50'
      end
      f.complex_field label: 'დასასრული' do |f|
        f.date_field 'end_date'
        f.text_field 'end_time', width: '50'
      end

      f.submit 'შენახვა'
      f.bottom_action call_outages_url, label: 'გაუქმება'
    end
  end
end
