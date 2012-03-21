# -*- encoding : utf-8 -*-

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
        if @application.save
        #  @application.applicant.save
        #  @application.bank_account.save
          redirect_to(home_url, :notice => 'განცხადება შენახულია')
        end
      else
        @application = Application.new(:email_response => true, :applicant => Applicant.new, :bank_account => BankAccount.new)
      end
    else
      @tariffs = Tariff2012.all
    end
  end

end
