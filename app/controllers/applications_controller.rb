# -*- encoding : utf-8 -*-

class ApplicationsController < ApplicationController
  def index
  end

  def new
    @title = 'ახალი განცხადება'
    @application = Application.new(params[:application])
  end

end
