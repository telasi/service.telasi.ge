# -*- encoding : utf-8 -*-
class Sys::BilloperationController < ApplicationController

  def index
    @title = 'ბილინგის ოპერაციები'
    @operations = Ext::Billoperation.asc(:opertpkey, :billoperkey)
  end

  def sync
    Ext::Billoperation.sync
    redirect_to sys_billoperations_url, notice: 'ოპერაციები სინქრონიზირებულია.'
  end

end
