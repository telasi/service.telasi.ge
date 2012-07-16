# -*- encoding : utf-8 -*-
module AppsHelper
  def app_row_class(app)
    case app.type
    when Apps::Application::TYPE_NEW_CUSTOMER
      status = app.new_customer_application.status
      if status == Apps::NewCustomerApplication::STATUS_SENT
        'sent'
      elsif status == Apps::NewCustomerApplication::STATUS_DEPROVED
        'deproved'
      elsif status == Apps::NewCustomerApplication::STATUS_APPROVED
        'approved'
      elsif status == Apps::NewCustomerApplication::STATUS_COMPLETE
        'complete'
      else
        'initial'
      end
    end
  end

  def app_status(app)
    case app.type
    when Apps::Application::TYPE_NEW_CUSTOMER
      status = app.new_customer_application.status
      if status == Apps::NewCustomerApplication::STATUS_SENT
        'წარმოებაში'
      elsif status == Apps::NewCustomerApplication::STATUS_DEPROVED
        'გაუქმებული'
      elsif status == Apps::NewCustomerApplication::STATUS_APPROVED
        'დადასტურებული'
      elsif status == Apps::NewCustomerApplication::STATUS_COMPLETE
        'დასრულებული'
      else
        'წინასწარი'
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
      "№%06d" % app.number
    end
  end

  def new_customer_item_type
    {'ჯამური' => Apps::NewCustomerItem::TYPE_SUMMARY, 'ინდივიდუალური' => Apps::NewCustomerItem::TYPE_DETAIL}
  end

  def new_customer_use_type
    {'საყოფაცხოვრებო' => Apps::NewCustomerItem::USE_PERSONAL, 'არა საყოფაცხოვრებო' => Apps::NewCustomerItem::USE_NOT_PERSONAL, 'საერთო სარგებლობის' => Apps::NewCustomerItem::USE_SHARED}
  end

  def new_customer_use_name(use)
    {Apps::NewCustomerItem::USE_PERSONAL => 'საყოფაცხოვრებო', Apps::NewCustomerItem::USE_NOT_PERSONAL => 'არა საყოფაცხოვრებო', Apps::NewCustomerItem::USE_SHARED => 'საერთო სარგებლობის'}[use]
  end

end
