# -*- encoding : utf-8 -*-
require 'rubygems'

# Set oracle's NLS_LANG parameter.
ENV['NLS_LANG'] = 'AMERICAN_AMERICA.UTF8'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
