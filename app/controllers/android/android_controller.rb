# -*- encoding : utf-8 -*-
class Android::AndroidController < ApplicationController

  include Android::BsLoginController

  def index
    @title = 'Android'
  end

  # ავტორიზაცია ანდროიდის მომხმარებლებისთვის.
  def authenticate
    process_login
  end

  def auth_cut
    @cut = 'cut'
    process_login(@cut)
  end

  def cut_users
    @users = Bs::Person.where("persstat = 0 and perstype = 4 and login is not null")
  end

  def users
    @title = 'მომხმარებლები'
    @users = User.or({:bs_cut_person.ne => nil}, {:bs_person.ne => nil})
  end

  def sync_logins
    User.excludes(bs_person: nil).each do |user|
      person = Bs::Person.where(perskey: user.bs_person).first
      if person
        user.bs_login = person.login
        user.save
      end
    end

    User.excludes(bs_cut_person: nil).each do |user|
      person = Bs::Person.where(perskey: user.bs_cut_person).first
      if person
        user.bs_cut_login = person.login
        user.save
      end
    end

    redirect_to android_users_url, notice: 'მომხმარებლები სინქრონიზირებულია'
  end

  def routes
    @title = 'მარშრუტები'
    rel = Bs::RouteStoreHeader
    if params[:perskey]
      @inspector = Bs::Person.find(params[:perskey])
      rel = rel.where(inspectorid: params[:perskey])
    elsif params[:blockkey]
      @block = Bs::Block.find(params[:blockkey])
      rel = rel.joins(:route).where('route.blockkey=?', params[:blockkey])
    elsif params[:regionkey]
      @region = Bs::Region.find(params[:regionkey])
      rel = rel.joins(:route => :block).where('block.regionkey=?', params[:regionkey])
    end
    @routes = rel.paginate(per_page: 10, page: params[:page]).order('route_header_id DESC')
  end

  def route
    @route = Bs::RouteStoreHeader.find(params[:id])
    @title = "მარშრუტი №#{@route.routekey}"
  end

end
