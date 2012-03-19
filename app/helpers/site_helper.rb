require 'yaml'

module SiteHelper

  def application_menu
    menu = YAML.load_file('config/main_menu.yml')
    menu = menu['not_authorized']
    main_menu = menu['main']
    secondary_menu = menu['secondary']
    page = request.fullpath[1..-1]
    page = 'home' if page.empty?
    render :partial => 'layouts/main_menu', :locals => {:items => main_menu, :secondary_items => secondary_menu, :page => page}
  end

end
