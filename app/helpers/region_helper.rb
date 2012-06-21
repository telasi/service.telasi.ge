# -*- encoding : utf-8 -*-
module RegionHelper

  # აჩვენებს რეგიონის გამოსახულებებს.
  def region_icons(reg, opts = {})
    if opts[:small]
      "#{image_tag 'sun16.png' if reg.show_on_map} #{image_tag 'clean16.png' if reg.trash_office}".html_safe
    else
      "#{image_tag 'sun32.png' if reg.show_on_map} #{image_tag 'clean32.png' if reg.trash_office}".html_safe
    end
  end

end
