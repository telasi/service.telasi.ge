# -*- encoding : utf-8 -*-
class Ext::Gis::Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Telasi::Queryable

  field :on,   type: Boolean
  field :off_status, type: Integer
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

  def sms_text(locale = nil)
    locale = locale || I18n.locale
    if self.on
      text = %Q{#{I18n.t('gis.log_on', locale: locale)}: }
    else
      text = %Q{#{I18n.t('gis.log_off', locale: locale)} [#{Ext::Gis::Log.off_status_text(self.off_status, locale)}]: }
    end
    if self.section_count > 0
      if self.section_count == 1
        text += "#{I18n.t(:gis_station_section, locale: locale)} *#{self.section_logs.first.object.to_s.to_lat}*; "
      else
        text += "#{I18n.t(:gis_station_sections, locale: locale)} - #{self.section_count}; "
      end
    end
    if self.fider_count > 0
      if self.fider_count == 1
        text += "#{I18n.t(:gis_fider, locale: locale)} *#{self.fider_logs.first.object.to_s.to_lat}*; "
      else
        text += "#{I18n.t(:gis_fiders, locale: locale)} - #{self.fider_count}; "
      end
    end
    if self.transformator_count > 0
      if [1, 2, 3].include?(self.regionkeys.size)
        text += "#{I18n.t(:gis_region, locale: locale)} #{self.regions.map{|r| "*#{r.regionname.to_lat}*"}.join(', ')}; "
      else
        text += "#{I18n.t(:gis_regions, locale: locale)} - #{self.regionkeys.size}; "
      end
      text += %Q{#{I18n.t(:gis_transformers, locale: locale)} - #{self.transformator_count}; #{I18n.t(:gis_streets, locale: locale)} - #{self.street_count}; #{I18n.t(:gis_customers, locale: locale)} - #{self.account_count};}
    end
    text.strip[0..-2] + '.' # remove last `;` and put `.` instead
  end

  def email_text(locale = nil)
    locale = locale || I18n.locale
    %Q{<!DOCTYPE html>
      <html>
        <head><meta http-equiv="content-type" content="text/html; charset=utf-8" /></head>
        <body>
          <p>#{ self.sms_text(locale) }</p>
          #{%Q{
            <p>#{I18n.t('gis.message.additional_info', locale: locale, url: "http://service.telasi.ge/sys/gis/message/#{self.id.to_s}")}</p>
          }}
        </body>
      </html>}
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
