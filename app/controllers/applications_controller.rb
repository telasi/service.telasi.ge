# -*- encoding : utf-8 -*-

class ApplicationsController < ApplicationController
  def index
  end

  def tariffs
    @tariffs = Tariff2012.all
    respond_to do |format|
      format.html do
        @title = 'მომსახურების ტარიფები'
      end
    end
  end

  def new
    @title = 'ახალი განცხადება'
    @application = Application.new(params[:application])
  end

end
