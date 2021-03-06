# -*- encoding : utf-8 -*-
require 'yaml'

module MenuHelper

  # ძირითადი მენიუს შექმნა
  def main_menu
    html = ''
    YAML.load_file('config/menus/main_menu.yml').each do |key, val|
      item_class = page_match?(val['select']) ? 'active' : 'common'
      html += %Q{<li class="#{item_class}"><a href="#{val['url']}">#{t val['label']}</a></li>}
    end
    %Q{<ul class="nav">#{html}</ul>}.html_safe
  end

  # მეორადი მენიუს შექმნა
  def secondary_menu
    if current_user
      menu = %Q{
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" id="user-box">
            #{current_user.full_name}
            <b class="caret"></b>
          </a>
          <ul class="dropdown-menu">
            <li>#{link_to t(:user_account), account_url}</li>
            <li>#{link_to t(:change_password), change_password_url}</li>
            <li class="divider"/>
            <li>#{link_to t(:logout), logout_url, data: {confirm: t(:logout_confirm)}}</li>
          </ul>
        </li>
      }
    else
      item_class = page_match?('users/login') ? 'active' : 'common'
      menu = %Q{<li class="#{item_class}">#{link_to t(:login), '/user/login'}</li>}
    end
    %Q{<ul class="nav pull-right">#{menu}</ul>}.html_safe
  end

  private

  def app_menu_url(item, opts = {})
    url = item['url']
    opts.each { |k,v| url[":#{k}"] = v.to_s if url[":#{k}"] }
    url
  end

  def app_menu_selected(item)
    if item['select']
      page_match?(item['select'])
    else
      item['sub_menu'].each do |k, v|
        return true if page_match?(v['select'])
      end
      false
    end
  end

  public

  # ქმნის პროგრამის ძირითად მენიუს.
  def application_menu(path, opts = {})
    main_menu = ''
    menu = YAML.load_file(path)
    menu.each do |key, val|
      url = app_menu_url(val, opts)
      item_selected = app_menu_selected(val)
      main_menu += %Q{<li class="#{item_selected ? 'selected' : 'common'}"><a href="#{url}">#{t val['label']}</a></li>}
    end
    %Q{<div class="application_menu"><ul>#{main_menu}</ul></div>}.html_safe
  end

  protected

  # ემთხვევა თუ არა მიმდინარე გვერდი პირობაში მოცემულ არჩევანს?
  #
  # პირობის ჩაწერა შესაძლებელია <code>'controller/action'</code> სახით.
  # ასევე შესაძლებელია მხოლოდ კონტროლერის სახელის მითითება.
  # თუ საჭიროა რამდენიმე კონტროლერის/ბრძანების დამთხვევა, ცალკეული შემთხვევა გამოიყოფა
  # მძიმით.
  def page_match?(selector)
    selector.split.each do |item|
      contrl, action = item.split('/')
      if action and (contrl == controller.controller_name and action == controller.action_name)
        return true
      elsif action.blank? and contrl == controller.controller_name
        return true
      end
    end
    false
  end

end
