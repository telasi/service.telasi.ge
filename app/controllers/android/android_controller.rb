# -*- encoding : utf-8 -*-
class Android::AndroidController < ApplicationController

  def index
    @title = 'Android'
  end

  # ავტორიზაცია ანდროიდის მომხმარებლებისთვის.
  def authenticate
    @user 
  end

  def users
    @title = 'მომხმარებლები'
    @users = User.excludes(bs_person: nil)
  end

  def sync_logins
    User.excludes(bs_person: nil).each do |user|
      person = Bs::Person.where(perskey: user.bs_person).first
      if person
        user.bs_login = person.login
        user.save
      end
    end
    redirect_to android_users_url, notice: 'მომხმარებლები სინქრონიზირებულია'
  end

  def routes
    @title = 'მარშრუტები'
    @routes = Bs::RouteStoreHeader.paginate(per_page: 10, page: params[:page]).order('route_header_id DESC')
  end

  def route
    @route = Bs::RouteStoreHeader.find(params[:id])
    @title = "მარშრუტი №#{@route.routekey}"
  end

end
