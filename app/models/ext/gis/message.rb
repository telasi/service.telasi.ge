# -*- encoding : utf-8 -*-
class Ext::Gis::Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Telasi::Queryable

  field :on,   type: Boolean
  field :sent, type: Boolean, default: false

  field :section_count, type: Integer, default: 0
  field :fider_count,   type: Integer, default: 0
  field :transformator_count, type: Integer, default: 0
  field :street_count,  type: Integer, default: 0
  field :account_count, type: Integer, default: 0
  field :regionkeys,    type: Array, default: []

  field :search_text, type: String

  has_many :logs, class_name: 'Ext::Gis::Log', inverse_of: :message
  index :search_text

  def self.by_q(q)
    self.search_by_q(q, :search_text)
  end

  def sync
    self.logs.each do |log|
      if log.section?
        self.section_count += 1
      elsif log.fider?
        self.fider_count += 1
      elsif log.transformator?
        self.transformator_count += 1
        transformator = log.object
        self.street_count  += transformator.street_count
        self.account_count += transformator.account_count
        self.regionkeys << transformator.regionkey unless self.regionkeys.include?(transformator.regionkey)
      end
    end
    self.search_text = logs.map{|l| l.object.to_s}.join('; ')
    self.save
  end

  def sms_text(ru = false)
    text = self.on ? (ru ? 'Включение: ' : 'CarTva: ') : (ru ? 'Выключение: ' : 'gaTiSva: ')
    if self.section_count > 0
      if self.section_count == 1
        text += ru ? %Q{Секция *#{self.section_logs.first.object.to_s.to_lat}*; } : %Q{qvesadguris seqcia *#{self.section_logs.first.object.to_s.to_lat}*; }
      else
        text += %Q{#{self.section_count} секций; }
      end
    end
    if self.fider_count > 0
      if self.fider_count == 1
        text += ru ? %Q{Фидер *#{self.fider_logs.first.object.to_s.to_lat}*; } : %Q{fideri *#{self.fider_logs.first.object.to_s.to_lat}*; }
      else
        text += ru ? %Q{#{self.fider_count} фидеров; } : %Q{#{self.fider_count} fideri; }
      end
    end
    if self.transformator_count > 0
      if [1, 2, 3].include?(self.regionkeys.size)
        text += ru ? %Q{Бизнесс-центр #{self.regions.map{|r| "*#{r.regionname.to_lat}*"}.join(', ')}; } : %Q{biznes centri #{self.regions.map{|r| "*#{r.regionname.to_lat}*"}.join(', ')}; }
      else
        text += ru ? "#{self.regionkeys.size} бизнесс-центра; " : "#{self.regionkeys.size} biznes centri; "
      end
      text += ru ?  "#{self.transformator_count} трансформаторов; #{self.street_count} улицы; #{self.account_count} абонентов; " : "#{self.transformator_count} transformatori; #{self.street_count} quCa; #{self.account_count} abonenti; "
    end
    text.strip[0..-2] + '.' # remove last `;` and put `.` instead
  end

  def regions
    Bs::Region.where("regionkey IN (?)", self.regionkeys)
  end

  def section_logs
    @__sectlogs = self.logs.find_all{|log| log.section?} || [] unless @__sectlogs
    @__sectlogs
  end

  def fider_logs
    @__fidlogs = self.logs.find_all{|log| log.fider?} || [] unless @__fidlogs
    @__fidlogs
  end

  def transformator_logs
    @__trlogs = self.logs.find_all{|log| log.transformator?} || [] unless @__trlogs
    @__trlogs
  end

end
