# -*- encoding : utf-8 -*-
class Call::AdminController < ApplicationController

  # status

  def new_status
    @title = 'ახალი სტატუსი'
    @stat = Call::Status.new(open: false, default: false)
    @form = StatusForm.status_form(@stat, auth_token)
    @form.edit = true
    if request.post?
      @form << params[:dim]
      if @form.valid?
        @form >> @stat
        @stat.save
        redirect_to call_home_url, notice: 'სტატუსი დამატებულია!'
      end
    end
  end

  def edit_status
    @title = 'სტატუსის შეცვლა'
    @stat = Call::Status.find(params[:id])
    @form = StatusForm.status_form(@stat, auth_token)
    @form.edit = true
    if request.post?
      @form << params[:dim]
      if @form.valid?
        @form >> @stat
        @stat.save
        redirect_to call_home_url, notice: 'სტატუსი შეცვლილია.'
      end
    else
      #@form << @stat
    end
  end

  def delete_status
    @stat = Call::Status.find(params[:id])
    @stat.destroy
    redirect_to call_home_url, notice: 'სტატუსი წაშლილია.'
  end

  # mobiles

  def sync_mobiles
    Call::Mobiles.sync
    redirect_to call_home_url, notice: 'რეგიონები სინქრონიზირებულია.'
  end

end
