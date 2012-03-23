# -*- encoding : utf-8 -*-
require 'telasi'

class ApplicationsController < ApplicationController

  def index
  end

  def tariffs
    @tariffs = Tariff2012.all
    respond_to do |format|
      format.html {  @title = 'მომსახურების ტარიფები' }
      format.json { render :json => @tariffs, :format => false }
    end
  end

  def new
    @title = 'ახალი განცხადება'
    if params[:tariff_id]
      @tariff = Tariff2012.find(params[:tariff_id])
      if request.post?
        puts params
        @application = Application.new(params[:application])
        @application.build_applicant(params[:applicant])
        @application.build_bank_account(params[:bank_account])
        @application.owner = current_user
        @application.tariff_id = @tariff.id
        @application.status = Application::STATUS_START
        @application.type = Application::TYPE_CONNECT
        redirect_to(show_application_url(@application), :notice => 'განცხადება შენახულია') if @application.save
      else
        @application = Application.new(:applicant => Applicant.new, :bank_account => BankAccount.new)
      end
    else
      @tariffs = Tariff2012.all
    end
  end

  def show
    @title = 'განცხადების პარამეტრები'
    @application = Application.find(params[:id])
    @tariff = @application.tariff
  end

  def print
    app = Application.find(params[:id])
    output = Telasi.render_application(app)
    send_data output, :filename => 'application.pdf', :type => :pdf, :disposition => 'inline'
  end

  def edit
    @title = 'განცხადების შეცვლა'
    @application = Application.find(params[:id])
    #@tariff = Tariff2012.find(@application.tariff_id)
    if request.put?
      params[:application][:applicant] = params[:applicant]
      params[:application][:bank_account] = params[:bank_account]
      redirect_to(show_application_url(@application), :notice => 'განცხადება განახლებულია') if @application.update_attributes(params[:application])
    end
  end

  def delete
    app = Application.find(params[:id])
    app.destroy
    redirect_to home_url, :notice => 'განცხადება წაშლილია'
  end

  def new_item
    @title = 'ახალი აბონენტი'
    @application = Application.find(params[:id])
    if request.post?
      @item = ApplicationItem.new(params[:application_item])
      @item.application = @application
      redirect_to show_application_url(@application), :notice => 'აბონენტი დამატებულია' if @item.save
    else
      @item = ApplicationItem.new
    end
  end

  def edit_item
    @title = 'აბონენტის რედაქტირება'
    @application = Application.find(params[:app_id])
    @item = @application.application_items.find(params[:id])
    if request.put?
      redirect_to show_application_url(@application), :notice => 'აბონენტი შეცვლილია' if @item.update_attributes(params[:application_item])
    end
  end

  def delete_item
    app = Application.find(params[:app_id])
    item = app.application_items.find(params[:id])
    item.destroy
    redirect_to show_application_url(app), :notice => 'აბონენტი წაშლილია'
  end

end
