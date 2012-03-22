# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :applicant do
    tin     '02001000490'
    name    'დიმიტრი ყურაშვილი'
    address 'ქ. აბაშა, კაჭარავას 35'
    mobile  '(595)335514'
    email   'dimakura@gmail.com'
  end
  factory :bank_account do
    swift 'TBCGE22'
    bank  'თი-ბი-სი ბანკი'
    eban  'TB0290GE000000001929238999'
  end
  factory :application do
    address          'ქ. თბილისი, ჯიქიას 7'
    address_code     '180.34.290.100'
    written_response true
    email_response   true
    tariff_id        1
    association      :owner, :factory => :user
    association      :applicant
    association      :bank_account
  end
end