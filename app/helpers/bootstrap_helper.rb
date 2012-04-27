# -*- encoding : utf-8 -*-
module BootstrapHelper

  def bootstrap_alert(text, opts = {})
    %Q{<div class="alert alert-#{opts[:class] || 'warning'} fade in"><a class="close" data-dismiss="alert" href="#">&times;</a>#{text}</div>}.html_safe unless text.blank?
  end

end
