# -*- encoding : utf-8 -*-
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Telasi::StandardPhoto
  include Telasi::Queryable

  attr_accessor :password_confirmation

  # ელექტრონული ფოსტა
  field :email, type: String

  # პაროლის "მარილი"
  field :salt, type: String

  # დაკრიპტული მარილი
  field :hashed_password, type: String

  # მობილური
  field :mobile, type: String

  # სახელი
  field :first_name, type: String

  # გვარი
  field :last_name, type: String

  # არის თუ არა ეს სისტემური ადმინისტრატორი?
  field :sys_admin, type: Boolean

  # ახალი აბონენტის რეგისტრაციის ადმინისტრატორი.
  field :new_cust_admin, type: Boolean

  # GIS ნახვა.
  field :gis_viewer, type: Boolean

  # Person ID for connection with BS database.
  field :bs_person, type: Integer
  field :bs_cut_person, type: Integer
  field :bs_login, type: String
  field :bs_cut_login, type: String

  # BS administrator role
  field :bs_admin, type: Boolean

  # BS inspector role
  field :bs_inspector, type: Boolean

  # BS cutter role
  field :bs_cutter, type: Boolean

  # C(ivil) R(egistry) A(gency) role
  field :cra, type: Boolean

  # არის თუ არა მომხმარებლის ელ. ფოსტა დადასტურებული?
  field :email_confirmed, type: Boolean

  # კოდი, რომელიც გამოიყენება ამ ელ. ფოსტის მისამართის დასადასტურებლად.
  field :email_confirm_hash, type: String

  # არის თუ არა მომხმარებლის მობილური დადასტურებული?
  field :mobile_confirmed, type: Boolean

  # პაროლის აღდგენის კოდი
  field :new_password_hash, type: String

  # აბონენტის ნომერი.
  field :accnumbs, type: Array
  # დადასტურებული აბონენტის ნომრები.
  field :confirmed_accnumbs, type: Array

  # მომხარებლის ენა.
  field :language, type: String, default: 'ka'

  # ასოირებული აბონენტები.
  has_many :customers, class_name: 'UserCustomer', inverse_of: :user

  ### >> ქოლ-ცენტრის ოპციები: დასაწყისი

  # აქვს თუ არა ქოლ-ცენტრით სარგებლობის უფლება.
  field :call_center, type: Boolean
  field :call_admin,  type: Boolean, default: false

  # ყველა რეგიონი აქვს?
  field :all_regions, type: Boolean

  # რეგიონების მასივი, რომელზეც შეიძლება ამ მომხმარებელს იმუშაოს.
  has_and_belongs_to_many :regions, class_name: 'Ext::Region'

  # favorite "call::task"s
  field :favorite_task_ids, type: Array

  ### << ქოლ-ცენტრი: ბოლო

  # შემოწმების ოპერაციები
  validates_presence_of :salt
  validates_presence_of :hashed_password
  validates_presence_of :email, :message => 'ჩაწერეთ ელ. ფოსტა'
  validates_presence_of :mobile, :message => 'ჩაწერეთ მობილური'
  validates_presence_of :first_name, :message => 'ჩაწერეთ სახელი'
  validates_presence_of :last_name, :message => 'ჩაწერეთ გვარი'
  #validates_presence_of :password, :message => 'ჩაწერეთ პაროლი'
  validates_confirmation_of :password, :message => 'პაროლი არ ემთხვევა'
  validates_uniqueness_of :email, :message => 'ეს მისამართი უკვე რეგისტრირებულია'
  validate :mobile_format, :email_format, :password_presence

  # ტრიგერები
  before_create :before_user_create
  before_update :before_user_update

  index({ email: 1 })
  index({ bs_login: 1 })
  index({ email: 1, mobile: 1, first_name: 1, last_name: 1 })

  # მომხმარებლის ავტორიზაცია.
  def self.authenticate(email, pwd)
    user = User.where(:email => email).first
    user if user and Digest::SHA1.hexdigest("#{pwd}dimitri#{user.salt}") == user.hashed_password
  end

  # მომხმარებლის ავტორიზაცია: ბილინგის მომხმარებლით.
  def self.authenticate_bs(username, pwd, cut)
    if cut
      user = User.where(:bs_cut_login => username).first
    else
      user = User.where(:bs_login => username).first
    end
    user if user and Digest::SHA1.hexdigest("#{pwd}dimitri#{user.salt}") == user.hashed_password
  end

  # მობილურის "კომპაქტიზაცია": ტოვებს მხოლოდ ციფრებს.
  def self.compact_mobile(mob)
    mob.scan(/[0-9]/).join('') if mob
  end

  # ამოწმებს მობილურის ნომრის კორექტულობას.
  # კორექტული მობილურის ნომერი უნდა შეიცავდეს 9 ციფრს.
  def self.correct_mobile?(mob)
    not not (compact_mobile(mob) =~ /^[0-9]{9}$/)
  end

  # ელ.ფოსტის შემოწმება.
  def self.correct_email?(email)
    not not (email =~ /^\S+@\S+$/)
  end

  def self.by_q(q)
    self.search_by_q(q, :email, :mobile, :first_name, :last_name)
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    unless pwd.nil? or pwd.strip.empty?
      self.salt = "salt#{rand 100}#{Time.now}"
      self.hashed_password = Digest::SHA1.hexdigest("#{pwd}dimitri#{salt}")
    end
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  # აგენერირებს აღდგენის კოდს ამ მომხამრებლისთვის.
  def prepeare_restore!
  	self.new_password_hash = Digest::SHA1.hexdigest("#{self.email}#{rand 1000}dimitri#{Time.now}")
  	self.save
  end

  def has_role?(role)
    if role.is_a? Array
      role.each { |r| return true if self.has_role?(r) }
      false
    elsif role.to_sym == :all
      true
    else
      self.send(role.to_sym) if self.respond_to?(role.to_sym)
    end
  end

  # customer accounts

  def all_accounts
    (self.accnumbs || []) + (self.confirmed_accnumbs || [])
  end

  def confirmed?(accnumb)
    (self.confirmed_accnumbs || []).include?(accnumb)
  end

  def to_s
    self.full_name
  end

  private

  def mobile_format
    if self.mobile and not User.correct_mobile?(self.mobile)
      errors.add(:mobile, 'არასწორი მობილური') 
    end
  end

  def email_format
    if self.email and not User.correct_email?(self.email)
      errors.add(:email, 'არასწორი ელ. ფოსტა')
    end
  end

  def password_presence
    if self.hashed_password.nil? and self.password.nil?
      errors.add(:password, 'ჩაწერეთ პაროლი')
    end
  end

  def before_user_create
    is_first = User.count == 0
    self.sys_admin = is_first if self.sys_admin.nil?
    self.email_confirmed = is_first if self.email_confirmed.nil?
    self.mobile_confirmed = false if self.mobile_confirmed.nil?
    self.mobile = User.compact_mobile(self.mobile)
    self.email_confirm_hash = Digest::SHA1.hexdigest("#{self.email}#{rand 100}#{Time.now}") unless self.email_confirmed
    true
  end

  def before_user_update
    self.mobile = User.compact_mobile(self.mobile)
  end

end
