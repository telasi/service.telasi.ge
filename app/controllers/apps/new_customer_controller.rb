# -*- encoding : utf-8 -*-
class Apps::NewCustomerController < ApplicationController

	def new
		@title = 'ქსელზე მიერთების ახალი განცხადება'
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

	def show
	  @title = 'განცხადების დეტალები'
    @application = Apps::Application.where(:_id => params[:id]).first
    # XXX
	end

	def customers
	  @title = 'აბონენტები'
    @application = Apps::Application.where(:_id => params[:id]).first
    # XXX
	end

	def notes
    @title = 'შენიშვნები'
    @application = Apps::Application.where(:_id => params[:id]).first
	end

	def docs
    @title = 'დოკუმენტები'
    @application = Apps::Application.where(:_id => params[:id]).first
	end

	def delete
    @application = Apps::Application.where(:_id => params[:id]).first
    @application.destroy
    redirect_to apps_home_path, :notice => 'განცხადება წაშლილია.'
	end

end
