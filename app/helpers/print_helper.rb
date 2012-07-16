# -*- encoding : utf-8 -*-
module PrintHelper

  def print_checkbox(checked=false)
    if checked
      %Q{<span class="larger">☒</span>}.html_safe
    else
      %Q{<span class="larger">☐</span>}.html_safe
    end
  end

end
