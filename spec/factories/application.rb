# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :applicant do
    tin         '02001000490'
    name        'დიმიტრი ყურაშვილი'
    address     'ქ. აბაშა, კაჭარავას 35'
    mobile      '(595)335514'
    email       'dimakura@gmail.com'
    #association :application
  end

  factory :bank_account do
    swift       'TBCGE22'
    bank        'თი-ბი-სი ბანკი'
    eban        'TB0290GE000000001929238999'
    #association :application
  end

  factory :application do |app|
    app.address          'ქ. თბილისი, ჯიქიას 7'
    app.address_code     '180.34.290.100'
    app.written_response true
    app.email_response   true
    app.tariff_id        1
    app.owner            Factory(:user, :email => 'application_owner@c12.ge')
    app.applicant        Factory.build(:applicant) {|a| a.application = app }
    app.bank_account     Factory.build(:bank_account) { |ba| ba.application = app }
  end
end
