# -*- encoding : utf-8 -*-
class Apps::NewCustomerController < ApplicationController

  # ახალი განცხადება.
  def new
    @title = 'ქსელზე მიერთება: ახალი განცხადება'
    if request.post?
      @application = Apps::Application.new(params[:apps_application])
      @application.applicant = Apps::Applicant.new(params[:apps_applicant])
      @application.owner = current_user
      @application.new_customer_application = Apps::NewCustomerApplication.new(params[:new_customer_application])
      @application.type = Apps::Application::TYPE_NEW_CUSTOMER
      @application.add_log(current_user, 'განცხადება შექმნილია.', Log::CREATE)
      redirect_to apps_new_customer_path(:id => @application.id), :notice => 'განცხადება შექმნილია.' if @application.save
    else
      applicant = Apps::Applicant.new(:mobile => current_user.mobile, :email => current_user.email)
      @application = Apps::Application.new(:applicant => applicant, new_customer_application: Apps::NewCustomerApplication.new(need_resolution: true))
    end
  end

  # განცხადების რედაქტირება.
  def edit
    @title = 'აპლიკანტის შეცვლა'
    process_application do
      if request.put?
        redirect_to apps_new_customer_path, notice: 'აპლიკანტი შეცვლილია.' if @application.applicant.update_attributes(params[:apps_applicant]) and  @application.new_customer_application.update_attributes(params[:apps_new_customer_application])
      end
    end
  end

  # განცხადების ნახვა: ძირითადი გვერდი.
  def show
    @title = 'განცხადების დეტალები'
    process_application
  end

  # განცხადების გაგზავნა.
  def sendapp
    process_application do
      if @application.new_customer_application.send!
        @application.add_log(current_user, 'განცხადება გაგზავნილია.', Log::SHARE)
        Magti.send_sms(@application.applicant.mobile, "Tqveni gancxadeba #{'#%06d' % @application.number} miRebulia warmoebaSi.") if Magti::SEND
        redirect_to apps_new_customer_path, notice: 'განცხადება გაგზავნილია.'
      else
        redirect_to apps_new_customer_path
      end
    end
  end

  # განცხადების დადასტურება.
  def approve
    process_application do
      if @application.new_customer_application.approve!
        @application.add_log(current_user, 'განცხადება მიღებულია.', Log::OK)
        Magti.send_sms(@application.applicant.mobile, "Tqveni gancxadeba #{'#%06d' % @application.number} dadasturebulia.") if Magti::SEND
        redirect_to apps_new_customer_path, notice: 'განცხადება დადასტურებულია.'
      else
        redirect_to apps_new_customer_path
      end
    end
  end

  # განცხადების დადასტურება.
  def deprove
    process_application do
      if @application.new_customer_application.deprove!
        @application.add_log(current_user, 'განცხადება გაუქმებულია.', Log::BAN)
        Magti.send_sms(@application.applicant.mobile, "Tqveni gancxadeba #{'#%06d' % @application.number} gauqmebulia.") if Magti::SEND
        redirect_to apps_new_customer_path, notice: 'განცხადება დადასტურებულია.'
      else
        redirect_to apps_new_customer_path
      end
    end
  end

  # წარმოებაში დაბრუნება.
  def to_sent
    process_application do
      if @application.new_customer_application.to_sent!
        @application.add_log(current_user, 'განცხადება დაბრუნებულია წარმოებაში.', Log::SHARE)
        Magti.send_sms(@application.applicant.mobile, "Tqveni gancxadeba #{'#%06d' % @application.number} dabrunebulia warmoebaSi.") if Magti::SEND
        redirect_to apps_new_customer_path, notice: 'განცხადება დაბრუნებულია წარმოებაში.'
      else
        redirect_to apps_new_customer_path
      end
    end
  end

  # დასრულება.
  def complete
    process_application do
      if @application.new_customer_application.complete!
        @application.add_log(current_user, 'განცხადება შესრულებულია.', Log::COMPLETE)
        Magti.send_sms(@application.applicant.mobile, "Tqveni gancxadeba #{'#%06d' % @application.number} Sesrulebulia.") if Magti::SEND
        redirect_to apps_new_customer_path, notice: 'განცხადება შესრულებულია.'
      else
        redirect_to apps_new_customer_path
      end
    end
  end

  # განცხადების წაშლა.
  def delete
    process_application do
      @application.destroy
      redirect_to apps_home_path, notice: 'განცხადება წაშლილია.'
    end
  end

  ### აბონენტების მართვა

  # განცხადების ნახვა: კლიენტების სია.
  def items
    process_application do
      @title = 'აბონენტები'
    end
  end

  # ახალი აბონენტის დამატება.
  def new_item
    process_application do
      @title = 'ახალი აბონენტი'
      if request.post?
        @item = Apps::NewCustomerItem.new(params[:apps_new_customer_item])
        @item.application = @application.new_customer_application
        if @item.save
          @application.new_customer_application.calculate
          redirect_to apps_new_customer_items_path(id: @application.id), notice: 'აბონენტი შექმნილია.'
        end
      else
        @item = Apps::NewCustomerItem.new(type: Apps::NewCustomerItem::TYPE_DETAIL, voltage: Apps::NewCustomerApplication::VOLTAGE_220, personal_use: true)
      end
    end
  end

  # აბონენტის წაშლა.
  def edit_item
    process_application do
      @title = 'აბონენტის რედაქტირება'
      @item = @application.new_customer_application.items.where(_id: params[:item_id]).first
      if request.put?
        if @item.update_attributes(params[:apps_new_customer_item])
          @application.new_customer_application.calculate
          redirect_to apps_new_customer_items_path(id: @application.id), notice: 'აბონენტი განახლებურია.'
        end
      end
    end
  end
  
  # აბონენტის ჩანაწერის წაშლა.
  def delete_item
    process_application do
      item = @application.new_customer_application.items.where(_id: params[:item_id]).destroy_all
      @application.new_customer_application.calculate
      redirect_to apps_new_customer_items_path(id: @application.id), notice: 'აბონენტი წაშლილია.'
    end
  end

  ### შენიშვნების მართვა

  # განცხადების ნახვა: შენიშვნების სია.
  def notes
    process_application do
      @title = 'შენიშვნები'
      @logs = @application.logs.desc(:created_at).paginate(page: params[:page], per_page: 5)
    end
  end

  # ახალი შენიშვნის დამატება.
  def new_note
    process_application do
      @title = 'შენიშვნები'
      if request.post?
        @log = Log.new(params[:log])
        @log.user = current_user
        @application.logs << @log
        redirect_to apps_new_customer_notes_path, notice: 'შენიშვნა დამატებულია' if @application.save
      else
        @log = Log.new
      end
    end
  end

  ### დოკუმენტების მართვა

  # განცხადების ნახვა: დოკუმენტაციის ნახვა.
  def docs
    process_application do
      @title = 'დოკუმენტები'
    end
  end

  # ახალი დოკუმენტის ატვირთვა.
  def new_doc
    process_application do
      @title = 'ახალი დოკუმენტის ატვირთვა'
      if request.post?
        @doc = Document.new(params[:document])
        @doc.documentable = @application
        redirect_to apps_new_customer_docs_path, :notice => 'ფაილის ატვირთულია.' if @doc.save
      else
        @doc = Document.new
      end
    end
  end

  # დოკუმენტის რედაქტირება.
  def edit_doc
    process_application do
      @title = 'დოკუმენტის რედაქტირება'
      @doc = Document.where(_id: params[:doc_id]).first
      if request.put?
        redirect_to apps_new_customer_docs_path, notice: 'ფაილი განახლებულია.' if @doc.update_attributes(params[:document])
      end
    end
  end

  # დოკუმენტის ჩამოტვირთვა.
  def download_doc
    @doc = Document.where(_id: params[:doc_id]).first
    send_data @doc.file.read, filename: @doc.file.path, disposition: 'inline'
  end

  # წაშლა.
  def delete_doc
    doc = Document.where(_id: params[:doc_id]).first
    doc.destroy
    redirect_to apps_new_customer_docs_path, :notice => 'ფაილის წაშლილია.'
  end

  ### გადახდების მართვა.

  # გადახდების მთავარი გვერდი.
  def payments
    process_application do
      @title = 'გადახდები'
      @payments = Apps::Payment.where(application_id: @application.id).asc(:created_at)
    end
  end

  # ახალი გადახდა.
  def new_payment
    process_application do
      @title = 'ახალი გადახდა'
      if request.post?
        @pay = Apps::Payment.new(params[:apps_payment])
        @pay.application = @application
        if @pay.save
          @application.recalculate!
          redirect_to apps_new_customer_payments_path, notice: 'გადახდა გატარებულია.'
        end
      else
        @pay = Apps::Payment.new(date: Date.today)
      end
    end
  end

  # გადახდის შეცვლა.
  def edit_payment
    process_application do
      @title = 'გადახდის შეცვლა'
      @pay = Apps::Payment.find(params[:pay_id])
      if request.put?
        if @pay.update_attributes(params[:apps_payment])
          @application.recalculate!
          redirect_to apps_new_customer_payments_path, notice: 'გადახდა შეცვლილია.'
        end
      end
    end
  end

  # გადახდის წაშლა.
  def delete_payment
    pay = Apps::Payment.find(params[:pay_id])
    pay.destroy
    pay.application.recalculate!
    redirect_to apps_new_customer_payments_path, notice: 'გადახდა წაშლილია.'
  end

  private

  def process_application
    @application = Apps::Application.where(_id: (params[:app_id] || params[:id])).first
    if @application
      yield if block_given?
    else
      redirect_to apps_home_path, notice: 'ასეთი გამოსახულება ვერ მოიძებნა.'
    end
  end

end
