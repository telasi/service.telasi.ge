# -*- encoding : utf-8 -*-
module Android::BsLoginController

  def process_login(cut = nil)
    @user = current_user
    @user = User.authenticate_bs(params[:username], params[:password], cut) unless @user
    if @user
      yield if block_given?
    else
      @message = 'არასწორი მომხმარებელი ან პაროლი.'
      render partial: 'android/readings/error'
    end
  end

end
