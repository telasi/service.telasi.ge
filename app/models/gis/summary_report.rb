# -*- encoding : utf-8 -*-
class Gis::SummaryReport
  include Mongoid::Document
  include Mongoid::Timestamps
  field :groupid, type: Integer
  field :text_ka, type: String
  field :text_ru, type: String
  field :sent,    type: Integer, default: 0
  field :total,   type: Integer, default: 0
  embeds_many :details, class_name: 'Gis::SummaryReportDetail'

  def sent?; self.sent == self.total end

  def send_report
    self.details.each do |det|
      number = det.receiver.mobile
      text = det.receiver.locale == 'ka' ? self.text_ka : self.text_ru
      Magti.send_sms(number, text) if Magti::SEND
      det.update_attributes(sent: true)
    end
  end

  def self.generate_summary_report(groupid)
    # get receivers in this group
    receivers = Gis::SummaryReceiver.where(active: true).to_a.select{|x| x.groupids.include?(groupid)}
    total = receivers.size
    return if total == 0
    # generate report texts
    Ext::Gis::Transformator.sync_current_status_and_prepare_report
    text_ka, text_ru = Ext::Gis::Transformator.status_report_text
    # create report
    report = Gis::SummaryReport.create(groupid: groupid, text_ka: text_ka, text_ru: text_ru, total: total)
    # add details
    receivers.each do |receiver|
      Gis::SummaryReportDetail.create(report: report, receiver: receiver, mobile: receiver.mobile, sent: false)
    end
    # generation done!
    report
  end
end

class Gis::SummaryReportDetail
  include Mongoid::Document
  embedded_in :report, class_name: 'Gis::SummaryReport'
  belongs_to :receiver, class_name: 'Gis::SummaryReceiver'
  field :mobile, type: String
  field :sent, type: Boolean, default: false
end
