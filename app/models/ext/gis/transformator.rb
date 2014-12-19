# -*- encoding : utf-8 -*-
class Ext::Gis::Transformator
  include Mongoid::Document
  include Mongoid::Timestamps

  # gis part
  field :objectid, type: Integer
  field :account,  type: Integer
  field :tp_name,  type: String
  field :tr_name,  type: String

  # bs part
  field :custkey,  type: Integer
  field :accnumb,  type: String
  field :custname, type: String
  field :acckey,   type: Integer
  field :accid,    type: String
  field :address,  type: String

  # account data
  field :regionkey,  type: Integer
  field :regionname, type: String
  field :street_count,  type: Integer
  field :account_count, type: Integer

  # status of the transformator
  field :on, type: Boolean
  field :off_status, type: Integer
  field :off_date, type: DateTime

  # indecies
  index({ tp_name: 1, tr_name: 1 })
  index({ objectid: 1 })
  index({ acckey: 1 })

  def self.sync
    Gis::Transformator.order('tp_name ASC, tr_name ASC').each do |gis_tr|
      tr = Ext::Gis::Transformator.where(objectid: gis_tr.objectid).first || Ext::Gis::Transformator.new(objectid: gis_tr.objectid)
      tr.tp_name = gis_tr.tp_name
      tr.account = gis_tr.account
      tr.tr_name = gis_tr.tr_name
      customer = Bs::Customer.where(accnumb: gis_tr.tp_name).first
      if customer
        tr.custkey = customer.custkey
        tr.accnumb = customer.accnumb
        tr.custname = customer.custname.to_ka
        accid = "#{customer.accnumb}-#{gis_tr.tr_name[1]}"
        account = Bs::Account.where(custkey: tr.custkey, accid: accid).first
        if account
          tr.acckey = account.acckey
          tr.accid  = account.accid
          tr.sync
        end
      end
      unless tr.acckey
        tr.account_count = 0
        tr.street_count = 0
      end
      tr.save
    end
  end

  def sync
    if self.acckey
      account = Bs::Account.find(self.acckey)
      self.account_count = Bs::Accrel.where(base_acckey: self.acckey).count
      self.address = account.address.to_s
      if account.address
        self.regionkey = account.address.region.regionkey
        self.regionname = account.address.region.regionname.to_ka
      end
      if self.account_count == 0
        self.street_count = 0
      else
        self.street_count = Bs::Accrel.connection.execute(%Q{
          SELECT count(*) FROM (SELECT adrs.streetkey FROM
            bs.accrel ar
            INNER JOIN bs.account acc ON ar.acckey = acc.acckey
            INNER JOIN bs.address adrs ON acc.premisekey = adrs.premisekey
          WHERE base_acckey=#{account.acckey}
          GROUP BY adrs.streetkey)
        }).fetch[0].to_i
      end
    end
  end

  def region; Bs::Region.find(self.regionkey) rescue nil end

  # ტრანსფორმატორის მდგომარეობის სინქრონიზაცია.
  def sync_current_status
    tr = Gis::Transformator.where(objectid: self.objectid).first
    if tr.blank? or tr.enabled == 1
      self.on = true
      self.off_status = nil
      self.off_date = nil
    else
      # log = Ext::Gis::Log.where(objectid: self.objectid, table_name: 'mv_tr_pnt', sms_status: Ext::Gis::Log::STATUS_SENT, :gis_status.ne => 1).desc(:_id).first
      log = Ext::Gis::Log.where(objectid: self.objectid, table_name: 'mv_tr_pnt', sms_status: Ext::Gis::Log::STATUS_SENT).desc(:_id).first
      if log.blank? or log.gis_status == 1
        self.on = true
        self.off_status = nil
        self.off_date = nil
      else
        self.on = false
        self.off_status = log.present? ? (log.gis_off_status || 0) : 0
        self.off_date = log.present? ? log.log_date : nil
      end
    end
    self.save
  end

  def self.sync_current_status; Ext::Gis::Transformator.each { |x| x. sync_current_status } end

  REGION_MAPPINGS = {
    'გლდანი-ნაძალადევი' => [1,23,34,35],
    'დიდუბე-ჩუღურეთი' => [2,15,16],
    'ვაკე-საბურთალო' => [3,9,10,14],
    'მთაწმინდა-კრწანისი' => [7],
    'ისანი-სამგორი' => [8,28,31],
  }

  ALL_REGKEYS = REGION_MAPPINGS.values.flatten

  REGIONS_RU = {
    'გლდანი-ნაძალადევი' => 'Глдани-Надзаладеви',
    'დიდუბე-ჩუღურეთი' => 'Дидубе-Чугурети',
    'ვაკე-საბურთალო' => 'Ваке-Сабуртало',
    'მთაწმინდა-კრწანისი' => 'Мтацминда-Крцаниси',
    'ისანი-სამგორი' => 'Исани-Самгори',
  }

  PHONES = {
    1 => Telasi::PHONES_1,
    2 => Telasi::PHONES_2,
    3 => Telasi::PHONES_3,
    4 => Telasi::PHONES_4,
    # 5 => Telasi::PHONES_5,
  }

  def self.transformators_for_semeki
    Ext::Gis::Transformator.where(on: false, :account_count.gt => 0).not_in(off_status: [2, 5, 7, 9]).in(regionkey: ALL_REGKEYS).select {|x| x.tp_name[0] != 'A'}
  end

  def self.sync_current_status_and_prepare_report
    Ext::Gis::Transformator.sync_current_status
    Ext::Gis::TransformatorReport.destroy_all
    transformators = Ext::Gis::Transformator.transformators_for_semeki
    REGION_MAPPINGS.each do |name,regions|
      reg_transformators = transformators.select {|x| regions.include?(x.regionkey)}
      count1 = (reg_transformators.select {|x| [1,6,8].include?(x.off_status)}).inject(0) { |sum,x| sum+=x.account_count }
      count2 = (reg_transformators.select {|x| [3,4].include?(x.off_status)}).inject(0) { |sum,x| sum+=x.account_count }
      Ext::Gis::TransformatorReport.create(name: name, count1: count1, count2: count2)
    end
  end

  def self.status_report_text
    text = ['გათიშვები', Time.now.strftime('%d-%b-%Y %H:%M')]
    text_ru = ['Отключения', Time.now.strftime('%d-%b-%Y %H:%M')]
    total1 = total2 = 0; customer_count = Bs::Customer.count
    accident = []; accident_ru = []; planned = []; planned_ru = [];
    Ext::Gis::TransformatorReport.each do |rep|
      accident << "#{rep.name}: #{rep.count1}"; accident_ru << "#{REGIONS_RU[rep.name]}: #{rep.count1}"
      planned  << "#{rep.name}: #{rep.count2}"; planned_ru  << "#{REGIONS_RU[rep.name]}: #{rep.count2}"
      total1 += rep.count1; total2 += rep.count2
    end
    total = total1 + total2
    percent = total * 100.0 / customer_count; percent = (percent * 10_000).round/10_000.0
    percent1 = total1 * 100.0 / customer_count; percent2 = total2 * 100.0 / customer_count
    percent1 = (percent1 * 10_000).round/10_000.0; percent2 = (percent2 * 10_000).round/10_000.0;
    text << ['-------', "სულ თბილისის მაშტაბით გათიშულია #{total} აბონენტი - #{percent}%."]
    text << ['-------', "აქედან ავარიულად გათიშულია #{total1} აბონენტი - #{percent1}%.", 'მონაცემები რაიონების მიხედვით:', accident]
    text << ['-------', "აქედან გეგმიურად გათიშულია #{total2} აბონენტი - #{percent2}%.", 'მონაცემები რაიონების მიხედვით:', planned]
    text_ru << ['-------', "Всего в Тбилиси отключено #{total} абонентов - #{percent}%."]
    text_ru << ['-------', "Доля аварийного отключия: #{total1} абонентов - #{percent1}%.", 'Данные по регионам:', accident_ru]
    text_ru << ['-------', "Доля планового отключия: #{total2} абонентов - #{percent2}%.", 'Данные по регионам:', planned_ru]
    text = text.flatten.join("\n")
    text_ru = text_ru.flatten.join("\n")
    [text, text_ru]
  end

  def self.sync_current_status_and_notify(phones_key = 1)
    Ext::Gis::Transformator.sync_current_status_and_prepare_report
    Ext::Gis::Transformator.send_current_status(phones_key)
  end

  def self.send_current_status(phones_key = 1, lock = true)
    text, text_ru = Ext::Gis::Transformator.status_report_text
    if Magti::SEND
      PHONES[phones_key].each do |number, locale|
        Magti.send_sms(number, locale == 'ru' ? text_ru : text)
      end
    end
    Ext::Gis::TransformatorReport.update_all(sent: true) if !lock
  end

  def to_s; "#{self.tp_name} &rarr; #{self.tr_name}".html_safe end
end
