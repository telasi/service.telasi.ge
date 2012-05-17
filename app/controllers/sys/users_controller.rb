# -*- encoding : utf-8 -*-
class Sys::UsersController < ApplicationController

  # მომხმარებლების საწყისი გვერდი.
  def index
    @title = 'მომხმარებლები'
    @users = User.desc(:_id).paginate(:per_page => 5)
  end

end