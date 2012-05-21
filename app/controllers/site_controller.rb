# -*- encoding : utf-8 -*-
class SiteController < ApplicationController

  # საიტის საწყისი გვერდი.
  def index
    @title = 'საწყისი'
  end

  # MARKDOWN ტექსტის გენერაცია.
  def markdown
    @text = params[:text]
    render layout: false
  end
  
end
