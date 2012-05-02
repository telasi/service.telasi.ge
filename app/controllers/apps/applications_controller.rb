# -*- encoding : utf-8 -*-
class Apps::ApplicationsController < ApplicationController
	def index
		@title = 'განცხადებები'
		@applications = Apps::Application.desc(:_id).paginate(:page => params[:page], :per_page => 10)
	end
end
