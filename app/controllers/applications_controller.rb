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
    @application = Application.new(params[:application])
  end

end
