# -*- encoding : utf-8 -*-
class Call::Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :custkey, type: Integer
  field :title, type: String
  field :mobile, type: String
  field :body, type: String

  has_many :comments, class_name: 'Call::TaskComment', order: :_id.desc
  has_many :messages, class_name: 'Call::Sms', order: :_id.desc
  belongs_to :status, class_name: 'Call::Status'
  belongs_to :region, class_name: 'Ext::Region'
  belongs_to :user

  def customer
    Bs::Customer.where(custkey: self.custkey).first
  end

  def self.by_user(user)
    if user.all_regions
      where({})
    else
      where(:region_id.in => user.region_ids)
    end
  end

  def send_by(user)
    region = Call::RegionData.where(region_id: self.region.id).first
    if region
      send_to(user, region.mobile1) unless region.mobile1.blank?
      send_to(user, region.mobile2) unless region.mobile2.blank?
    end
  end

  # synchronize this task
  def sync(user)
    if self.status.open
      region = Call::RegionData.where(region_id: self.region.id).first
      if region.cutbase.present?
        clazz = region.cutbase.constantize
        cut = clazz.where("custkey=? AND oper_code=? AND mark_date>?", self.custkey, Bs::CutBase::OPER_RESTORE, Time.now - Call::SYNC).order('cr_key DESC').first        
        if cut
          if cut.mark_code == Bs::CutBase::MARK_START
            new_stat = Call::Status.where(wait: true).first
            if new_stat and new_stat != self.status
              Call::TaskComment.new(task: self, user: user, text: '[SYNC] აბონენტი ჩასართავად მონიშნულია').save
              self.status = new_stat
              self.save
            end
          elsif cut.mark_code == Bs::CutBase::MARK_COMPLETE
            new_stat = Call::Status.where(complete: true).first
            if new_stat and new_stat != self.status
              Call::TaskComment.new(task: self, user: user, text: '[SYNC] აბონენტი ჩართულია').save
              self.status = new_stat
              self.save
            end
          elsif cut.mark_code == Bs::CutBase::MARK_NOT_COMPLETE
            new_stat = Call::Status.where(canceled: true).first
            if new_stat and new_stat != self.status
              Call::TaskComment.new(task: self, user: user, text: '[SYNC] აბონენტი არ/ვერ ჩაირთო').save
              self.status = new_stat
              self.save
            end
          end
        end
      end
    end
  end

  private

  def send_to(user, mobile)
    msg = Call::Sms.new(mobile: mobile, text: message_text, user:user, task: self)
    Magti.send_sms(mobile, msg.text.to_lat) if Magti::SEND
    msg.save
  end

  def message_text
    cust  = self.customer
    acc   = self.customer.accounts.first
    meter = acc.mtnumb
    msg = []
    msg << "მრიცხ:#{meter}" unless meter.blank?
    msg << "მის:#{acc.address.to_s}"
    msg << "აბონ:#{cust.accnumb.to_ka} #{cust.custname.to_ka}"
    msg << "ტელ:#{self.mobile}" unless self.mobile.blank?
    msg << "კომენტ: #{self.title}"
    msg.join("; ")
  end

end
