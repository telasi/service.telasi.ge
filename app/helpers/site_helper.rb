# -*- encoding : utf-8 -*-
require 'yaml'

module SiteHelper
  def application_menu
    user = current_user
    menu = YAML.load_file('config/main_menu.yml')
    menu = menu[(user ? 'authorized' : 'not_authorized')]
    main_menu = menu['main']
    secondary_menu = menu['secondary']
    page = request.fullpath[1..-1]
    page = 'home' if page.empty?
    render :partial => 'layouts/main_menu', :locals => {:items => main_menu, :secondary_items => secondary_menu, :page => page, :user => user}
  end

  def icon_text(icn, txt = nil)
    %Q{<i class="icon-#{icn}"></i> #{txt}}.strip.html_safe
  end

  def number_format(num, prec = 2)
    number_with_precision(num, :precision => prec, :delimiter => ' ', :separator => ',')
  end

  def support_phone
    '2 779-868'
  end

  def support_email
    mail_to 'sys@telasi.ge'
  end

end
