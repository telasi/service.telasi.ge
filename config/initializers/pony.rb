# -*- encoding : utf-8 -*-
require 'pony'

smtp_options = {
  :address        => 'telmail.telasi.ge',
  :port           => '587',
  :enable_starttls_auto => true,
  :user_name      => '',
  :password       => password,
  :authentication => :login,
  #:domain         => "telasi.ge"
}

Pony.options = {:via => :smtp, :via_options => smtp_options}
