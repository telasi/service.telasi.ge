# -*- encoding : utf-8 -*-
class Apps::NewCustomerController < ApplicationController

  # ახალი განცხადება.
  def new
    @title = 'ქსელზე მიერთება: ახალი განცხადება'
    if request.post?
      @application = Apps::Application.new(params[:apps_application])
      @application.applicant = Apps::Applicant.new(params[:apps_applicant])
      @application.new_customer_application = Apps::NewCustomerApplication.new(params[:apps_new_customer_application])
      @application.owner = current_user
      @application.type = Apps::Application::TYPE_NEW_CUSTOMER
      redirect_to apps_new_customer_path(:id => @application.id), :notice => 'განცხადება შექმნილია.' if @application.save
    else
      applicant = Apps::Applicant.new(:mobile => current_user.mobile, :email => current_user.email)
      new_customer_application = Apps::NewCustomerApplication.new(:voltage => Apps::NewCustomerApplication::VOLTAGE_220)
      @application = Apps::Application.new(:applicant => applicant, :new_customer_application => new_customer_application)
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
      @item.new_customer_application = @application.new_customer_application
      redirect_to apps_new_customer_items_path(id: @application.id) if @item.save
    else
      @item = Apps::NewCustomerItem.new(type: Apps::NewCustomerItem::TYPE_DETAIL, voltage: @application.new_customer_application.voltage, personal_use: true)
    end
  end

  # აბონენტის წაშლა.
  def edit_item
    @title = 'აბონენტის რედაქტირება'
    @application = Apps::Application.where(_id: params[:id]).first
  end

  # აბონენტის ჩანაწერის წაშლა.
  def delete_item
    app = Apps::Application.where(_id: params[:id]).first
    item = app.new_customer_application.new_customer_items.where(_id: params[:item_id]).destroy_all
    redirect_to apps_new_customer_items_path(id: app.id)
  end

  ### შენიშვნების მართვა

  # განცხადების ნახვა: შენიშვნების სია.
  def notes
    @title = 'შენიშვნები'
    @application = Apps::Application.where(_id: params[:id]).first
  end

  ### დოკუმენტების მართვა

  # განცხადების ნახვა: დოკუმენტაციის ნახვა.
  def docs
    @title = 'დოკუმენტები'
    @application = Apps::Application.where(_id: params[:id]).first
  end

end
