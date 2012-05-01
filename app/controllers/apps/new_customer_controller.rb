# -*- encoding : utf-8 -*-
class Apps::NewCustomerController < ApplicationController

	def new
		@title = 'ქსელზე მიერთების ახალი განცხადება'
		if request.post?
			@application = Application.new(params[:application])
			@application.applicant = Applicant.new(params[:applicant])
			@application.owner = current_user
			@application.type = Application::TYPE_NEW_CUSTOMER
			# XXX
		else
			applicant = Applicant.new(:mobile => current_user.mobile, :email => current_user.email)
			@application = Application.new(:applicant => applicant)
		end
	end

end
