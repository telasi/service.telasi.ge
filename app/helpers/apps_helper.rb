# -*- encoding : utf-8 -*-
module AppsHelper

  def app_type(app)
    case app.type
    when Apps::Application::TYPE_NEW_CUSTOMER
      'ქსელზე მიერთება'
    else
      '?'
    end
  end

  def app_link(app)
    case app.type
    when Apps::Application::TYPE_NEW_CUSTOMER
      url = apps_new_customer_path(:id => app.id)
    else
      url = nil
    end
    link_to app_number(app), url
  end

  def app_number(app)
    if app.number.blank?
      tooltiped_text '<ნომრის გარეშე>', 'განცხადებას ნომერი მიენიჭება თელასში გამოგზავნის შემდეგ', :right
    else
      app.number
    end
  end

  def new_customer_item_type
    {'ჯამური' => Apps::NewCustomerItem::TYPE_SUMMARY, 'ინდივიდუალური' => Apps::NewCustomerItem::TYPE_DETAIL}
  end

end
