# -*- encoding : utf-8 -*-
class Apps::ApplicationsController < ApplicationController

  # განცხადებების საწყისი გვერდი.
	def index
    @title = 'განცხადებები'
    if current_user.new_cust_admin
      rel = Apps::Application
    else
      rel = Apps::Application.by_user(current_user)
    end
    @applications = rel.desc(:_id).paginate(:page => params[:page], :per_page => 10)
	end

end
