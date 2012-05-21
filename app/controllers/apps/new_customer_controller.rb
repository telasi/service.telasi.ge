# -*- encoding : utf-8 -*-
class Apps::NewCustomerController < ApplicationController

  # ახალი განცხადება.
  def new
    @title = 'ქსელზე მიერთება: ახალი განცხადება'
    if request.post?
      @application = Apps::Application.new(params[:apps_application])
      @application.applicant = Apps::Applicant.new(params[:apps_applicant])
      @application.owner = current_user
      @application.new_customer_application = Apps::NewCustomerApplication.new
      @application.type = Apps::Application::TYPE_NEW_CUSTOMER
      @application.add_log(current_user, 'განცხადება შექმნილია.', Log::CREATE)
      redirect_to apps_new_customer_path(:id => @application.id), :notice => 'განცხადება შექმნილია.' if @application.save
    else
      applicant = Apps::Applicant.new(:mobile => current_user.mobile, :email => current_user.email)
      @application = Apps::Application.new(:applicant => applicant)
    end
  end

  # განცხადების რედაქტირება.
  def edit
    @title = 'აპლიკანტის შეცვლა'
    @application = Apps::Application.where(_id: params[:id]).first
    if request.put?
      redirect_to apps_new_customer_path, notice: 'აპლიკანტი შეცვლილია.' if @application.applicant.update_attributes(params[:apps_applicant])
    end
  end

  # განცხადების ნახვა: ძირითადი გვერდი.
  def show
    @title = 'განცხადების დეტალები'
    @application = Apps::Application.where(_id: params[:id]).first
    # XXX
  end

  # განცხადების წაშლა.
  def delete
    @application = Apps::Application.where(_id: params[:id]).first
    @application.destroy
    redirect_to apps_home_path, :notice => 'განცხადება წაშლილია.'
  end

  ### აბონენტების მართვა

  # განცხადების ნახვა: კლიენტების სია.
  def items
    @title = 'აბონენტები'
    @application = Apps::Application.where(_id: params[:id]).first
  end

  # ახალი აბონენტის დამატება.
  def new_item
    @title = 'ახალი აბონენტი'
    @application = Apps::Application.where(_id: params[:id]).first
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

  # აბონენტის წაშლა.
  def edit_item
    @title = 'აბონენტის რედაქტირება'
    @application = Apps::Application.where(_id: params[:id]).first
    @item = @application.new_customer_application.items.where(_id: params[:item_id]).first
    if request.put?
      if @item.update_attributes(params[:apps_new_customer_item])
        @application.new_customer_application.calculate
        redirect_to apps_new_customer_items_path(id: @application.id), notice: 'აბონენტი განახლებურია.'
      end
    end
  end

  # აბონენტის ჩანაწერის წაშლა.
  def delete_item
    app = Apps::Application.where(_id: params[:id]).first
    item = app.new_customer_application.items.where(_id: params[:item_id]).destroy_all
    app.new_customer_application.calculate
    redirect_to apps_new_customer_items_path(id: app.id), notice: 'აბონენტი წაშლილია.'
  end

  ### შენიშვნების მართვა

  # განცხადების ნახვა: შენიშვნების სია.
  def notes
    @title = 'შენიშვნები'
    @application = Apps::Application.where(_id: params[:id]).first
    @logs = @application.logs.desc(:created_at).paginate(page: params[:page], per_page: 5)
  end

  def new_note
    @title = 'შენიშვნები'
    @application = Apps::Application.where(_id: params[:id]).first
    if request.post?
      @log = Log.new(params[:log])
      @log.user = current_user
      @application.logs << @log
      redirect_to apps_new_customer_notes_path, notice: 'შენიშვნა დამატებულია' if @application.save
    else
      @log = Log.new
    end
  end

  ### დოკუმენტების მართვა

  # განცხადების ნახვა: დოკუმენტაციის ნახვა.
  def docs
    @title = 'დოკუმენტები'
    @application = Apps::Application.where(_id: params[:id]).first
  end

  # ახალი დოკუმენტის ატვირთვა.
  def new_doc
    @title = 'ახალი დოკუმენტის ატვირთვა'
    @application = Apps::Application.where(_id: params[:id]).first
    if request.post?
      @doc = Document.new(params[:document])
      @doc.documentable = @application
      redirect_to apps_new_customer_docs_path, :notice => 'ფაილის ატვირთულია.' if @doc.save
    else
      @doc = Document.new
    end    
  end

  # დოკუმენტის რედაქტირება.
  def edit_doc
    @title = 'დოკუმენტის რედაქტირება'
    @application = Apps::Application.where(_id: params[:id]).first
    @doc = Document.where(_id: params[:doc_id]).first
    if request.put?
      redirect_to apps_new_customer_docs_path, notice: 'ფაილი განახლებულია.' if @doc.update_attributes(params[:document])
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

end
