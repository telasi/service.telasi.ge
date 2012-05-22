# -*- encoding : utf-8 -*-
module AppsHelper

  def app_row_class(app)
    case app.type
    when Apps::Application::TYPE_NEW_CUSTOMER
      status = app.new_customer_application.status
      if status == Apps::NewCustomerApplication::STATUS_SENT
        'warning'
      elsif status == Apps::NewCustomerApplication::STATUS_DEPROVED
        'error'
      elsif status == Apps::NewCustomerApplication::STATUS_APPROVED
        'success'
      elsif status == Apps::NewCustomerApplication::STATUS_COMPLETE
        'canceled'
      else
        'normal'
      end
    end
  end

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
      "№%08d" % app.number
    end
  end

  def new_customer_item_type
    {'ჯამური' => Apps::NewCustomerItem::TYPE_SUMMARY, 'ინდივიდუალური' => Apps::NewCustomerItem::TYPE_DETAIL}
  end

end
