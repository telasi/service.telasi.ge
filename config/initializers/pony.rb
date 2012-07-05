require 'pony'

smtp_options = {
  :address        => '92.241.77.33',
  :port           => '25',
  #:user_name      => 'support@telasi.ge',
  #:password       => password,
  #:authentication => :plain,
  #:domain         => "telasi.ge"
}

Pony.options = {:via => :smtp, :via_options => smtp_options}
