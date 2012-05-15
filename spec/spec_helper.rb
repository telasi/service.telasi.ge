# -*- encoding : utf-8 -*-
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'mongoid'
require 'capybara'
require 'mongoid-rspec'
require 'capybara/rspec'
require 'factory_girl'
require 'includes'

HTTPI.log = false
Savon.log = false

Capybara.javascript_driver = :webkit
Capybara.default_wait_time = 5
Capybara.current_driver = :webkit

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include RSpec::Matchers
  config.include FactoryGirl::Syntax::Methods
  config.include Mongoid::Matchers
  config.before(:all) do
    # clear database
    Mongoid.master.collections.each(&:remove)
    # clear ActionMailer deliveries
    ActionMailer::Base.deliveries.clear
  end
end

