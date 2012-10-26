# -*- encoding : utf-8 -*-
class Cra::CraController < ApplicationController
  before_filter :cra_validation

  private

  def cra_validation
    user = current_user
    if user.blank?
      session[:return_url] = request.url
      redirect_to login_url, notice: 'გაიარეთ ავტორიზაცია.'
    elsif !can_view?(user)
      redirect_to login_url, notice: 'არ გაქვთ შესვლის უფლება.'
    end
  end

  def can_view?(user)
    if user.has_role?([:cra])
      true
    else
      false
    end
  end

  public

  def index
    @title = 'საჯარო რეესტრის მონაცემების ძებნა'
  end

  def last
    @passport = CRA.serv.by_personal_id(params[:private_number]) rescue nil
    if @passport
      @title = @passport.full_name
    else
      flash.now[:notice] = 'ასეთი პიროვნება ვერ მოიძებნა.'
      render action: 'index'
    end
  end

  def last_id
    @passport = CRA.serv.by_id_card(params[:id_serial], params[:id_number]) rescue nil
    if @passport
      @title = @passport.full_name
    else
      flash.now[:notice] = 'ასეთი პიროვნება ვერ მოიძებნა.'
      render action: 'index'
    end
  end

  def all
    begin
      date = Date.strptime(params[:date], '%d-%b-%Y')
      d = date.strftime('%d').to_i
      m = date.strftime('%m').to_i
      y = date.strftime('%Y').to_i
      @documents = CRA.serv.list_by_name_and_dob(params[:last_name], params[:first_name], y, m, d)
    rescue
      @documents = []
    end
    if @documents.any?
      @title = @documents[0].full_name
    else
      flash.now[:notice] = 'ასეთი დოკუმენტი ვერ მოიძებნა.'
      render action: 'index'
    end
  end

  def history
    @title = 'აღრიცხვა'
    @items = Cra::History.all.desc(:_id).paginate(page: params[:page], per_page: 10)
  end

end
