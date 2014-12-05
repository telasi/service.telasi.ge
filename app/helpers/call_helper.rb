# -*- encoding : utf-8 -*-
module CallHelper
  def hours
    [
      '00:00', '00:15', '00:30', '00:45',
      '01:00', '01:15', '01:30', '01:45',
      '02:00', '02:15', '02:30', '02:45',
      '03:00', '03:15', '03:30', '03:45',
      '04:00', '04:15', '04:30', '04:45',
      '05:00', '05:15', '05:30', '05:45',
      '06:00', '06:15', '06:30', '06:45',
      '07:00', '07:15', '07:30', '07:45',
      '08:00', '08:15', '08:30', '08:45',
      '09:00', '09:15', '09:30', '09:45',
      '10:00', '10:15', '10:30', '10:45',
      '11:00', '11:15', '11:30', '11:45',
      '12:00', '12:15', '12:30', '12:45',
      '13:00', '13:15', '13:30', '13:45',
      '14:00', '14:15', '14:30', '14:45',
      '15:00', '15:15', '15:30', '15:45',
      '16:00', '16:15', '16:30', '16:45',
      '17:00', '17:15', '17:30', '17:45',
      '18:00', '18:15', '18:30', '18:45',
      '19:00', '19:15', '19:30', '19:45',
      '20:00', '20:15', '20:30', '20:45',
      '21:00', '21:15', '21:30', '21:45',
      '22:00', '22:15', '22:30', '22:45',
      '23:00', '23:15', '23:30', '23:45',
    ]
  end

  def hours_hash
    hash = {}
    hours.each { |h| hash[h] = h }
    hash
  end

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
    cancel_url = outage.new_record? ? call_outages_url : call_outage_url(id: outage.id)
    forma_for outage, title: opts[:title], icon: opts[:icon], collapsible: true do |f|
      f.text_field 'accnumb', label: 'ფიდერის #', autofocus: true, required: true
      f.complex_field label: 'მიზეზი', required: true do |f|
        f.combo_field 'category', collection: Call::Outage::CATEGORIES, empty: false
        f.text_field 'description'
      end
      f.complex_field label: 'დასაწყისი', required: true do |f|
        f.date_field 'start_date'
        f.text_field 'start_time', width: '50'
      end
      f.complex_field label: 'დასასრული' do |f|
        f.date_field 'end_date'
        f.text_field 'end_time', width: '50'
      end
      f.submit 'შენახვა'
      f.bottom_action cancel_url, label: 'გაუქმება'
    end
  end
end
