# -*- encoding : utf-8 -*-

require 'mongoid'

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

  # შემოწმების ოპერაციები
  validates_presence_of :salt
  validates_presence_of :hashed_password
  validates_presence_of :email, :message => 'ჩაწერეთ ელ. ფოსტა'
  validates_presence_of :mobile, :message => 'ჩაწერეთ მობილური'
  validates_presence_of :first_name, :message => 'ჩაწერეთ სახელი'
  validates_presence_of :last_name, :message => 'ჩაწერეთ გვარი'
  validates_presence_of :password, :message => 'ჩაწერეთ პაროლი'
  validates_confirmation_of :password, :message => 'პაროლი არ ემთხვევა'
  validates_uniqueness_of :email

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    self.salt = "salt#{rand 100}#{Time.now}"
    self.hashed_password = Digest::SHA1.hexdigest("#{pwd}dimitri#{salt}")
  end

end
