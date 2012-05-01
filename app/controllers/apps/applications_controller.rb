# -*- encoding : utf-8 -*-
class Apps::ApplicationsController < ApplicationController
	def index
		@title = 'განცხადებები'
		@applications = Application.all
	end
end
