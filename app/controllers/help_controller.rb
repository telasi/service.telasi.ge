# -*- encoding : utf-8 -*-
require 'yaml'

class HelpController < ApplicationController

  # დახმარების გვერდები.
  def index
    @tutorials = YAML.load_file('config/menus/help.yml')
    @tutorial = params[:tutorial]
    @section = params[:section]
    if @tutorial and @section
      @title = @tutorials[@tutorial][@section]
      path = "#{@tutorial}/#{@section}"
    else
      @title = 'საწყისი'
      path = 'index'
    end
    @body = load_body(path)
  end

  private

  def load_body(path)
    IO.read(File.join(Rails.root, 'app/views/help', "#{path}.md"))
  rescue Exception => ex
    '<p class="muted">ეს სტატია ჯერ არ დაწერილა</p>'
  end

end
