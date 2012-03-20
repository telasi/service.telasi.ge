# -*- encoding : utf-8 -*-

class User
  include Mongoid::Document

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

  # არის თუ არა მომხმარებლის ელ. ფოსტა დადასტურებული?
  field :email_confirmed, type: Boolean

  # არის თუ არა მომხმარებლის მობილური დადასტურებული?
  field :mobile_confirmed, type: Boolean

  # შემოწმების ოპერაციები
  validates_presence_of :salt
  validates_presence_of :hashed_password
  validates_presence_of :email, :message => 'ჩაწერეთ ელ. ფოსტა'
  validates_presence_of :mobile, :message => 'ჩაწერეთ მობილური'
  validates_presence_of :first_name, :message => 'ჩაწერეთ სახელი'
  validates_presence_of :last_name, :message => 'ჩაწერეთ გვარი'
  validates_presence_of :password, :message => 'ჩაწერეთ პაროლი'
  validates_confirmation_of :password, :message => 'პაროლი არ ემთხვევა'
  validates_uniqueness_of :email, :message => 'ეს მისამართი უკვე რეგისტრირებულია'
  validate :validate_mobile_format

  # ტრიგერები
  before_create :before_user_create

  # მომხმარებლის ავტორიზაცია.
  def self.authenticate(email, pwd)
    user = User.where(:email => email).first
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

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    self.salt = "salt#{rand 100}#{Time.now}"
    self.hashed_password = Digest::SHA1.hexdigest("#{pwd}dimitri#{salt}")
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

  def validate_mobile_format
    if self.mobile and not User.correct_mobile?(self.mobile)
      errors.add(:mobile, 'არასწორი მობილური') 
    end
  end

  def before_user_create
    is_first = User.count == 0
    self.sys_admin = is_first if self.sys_admin.nil?
    self.email_confirmed = is_first if self.email_confirmed.nil?
    self.mobile_confirmed = false if self.mobile_confirmed.nil?
    self.mobile = User.compact_mobile(self.mobile)
    true
  end
end
