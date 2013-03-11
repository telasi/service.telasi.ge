# -*- encoding : utf-8 -*-
class Call::CustomersController < ApplicationController

  def index
    @title = 'აბონენტების ძებნა'
    @search_form = CustomerForm.search(params[:dim])
    accnumb = params[:dim][:accnumb] if params[:dim]
    @customers = search_customers(params[:dim], params[:page])
    #Bs::Customer.where('accnumb LIKE ?', "%#{accnumb}%").paginate(per_page: 10, page: params[:page]).order(:accnumb)
    @customer_table = CustomerForm.customer_table(@customers)

    #if params[:accnumb]
    #  @customer = Bs::Customer.where(accnumb: params[:accnumb].to_geo).first
    #  redirect_to call_customer_info_url(custkey: @customer.custkey) if @customer
    #end
  end

  def customer_info
    @title = 'მონაცემები აბონენტზე'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @customer_form = CustomerForm.customer_form(@customer)
    @trash_customer_form = TrashCustomerForm.customer_form(@customer.trash_customer)
    @trash_customer_form.collapsed = true
    @water_customer_form = WaterCustomerForm.customer_form(@customer)
    @water_customer_form.collapsed = true
  end

  def items
    @title = 'აბონენტის ისტორია'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @items = Bs::Item.where(custkey: @customer.custkey).order('ITEMKEY desc').paginate(page: params[:page], per_page: 15)
    @item_table = ItemForm.item_table(@items)
    @customer_form = CustomerForm.customer_form(@items.first.customer) unless @items.empty?
    @customer_form.collapsed = true
  end

  def item
    @title = 'ოპერაციის დეტალები'
    @item = Bs::Item.where(itemkey: params[:itemkey]).first
    @customer = @item.customer
    @account = @item.account
    @item_form = ItemForm.item_form(@item)
    @account_form = AccountForm.account_form(@item.account)
    @account_form.collapsed = true
    @customer_form = CustomerForm.customer_form(@customer, {title: 'აბონენტი'})
    @customer_form.collapsed = true
  end

  def cuts
    @title = 'ჩაჭრების ისტორია'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @cuts = Bs::CutHistory.where(custkey: params[:custkey]).order('OPER_DATE desc').paginate(page: params[:page], per_page: 15)
    @cut_table = CutForm.cut_table(@cuts)
    @customer_form = CustomerForm.customer_form(@customer, {title: 'აბონენტი'})
    @customer_form.collapsed = true
  end

  def cut
    @title = 'ოპერაციის დეტალები'
    @cut = Bs::CutHistory.where(cr_key: params[:cutkey]).first
    @customer = @cut.customer
    @cut_form = CutForm.cut_form(@cut)
    @account_form = AccountForm.account_form(@cut.account)
    @account_form.collapsed = true
    @customer_form = CustomerForm.customer_form(@cut.customer, {title: 'აბონენტი'})
    @customer_form.collapsed = true
  end

  private

  def search_customers(params, page)
    conditions = []
    values = {}
    join_address = false
    join_regions = false
    join_street = false
    unless params.blank?
      unless params[:accnumb].blank?
        conditions << 'customer.accnumb LIKE :accnumb'
        values[:accnumb] = "%#{params[:accnumb].to_geo}%"
      end
      unless params[:custname].blank?
        conditions << 'customer.custname LIKE :custname'
        values[:custname] = "%#{params[:custname].to_geo}%"
      end
      unless params[:regionname].blank?
        conditions << 'region.regionname LIKE :regionname'
        values[:regionname] = "%#{params[:regionname].to_geo}%"
        join_address = join_regions = true
      end
      unless params[:streetname].blank?
        conditions << 'street.streetname LIKE :streetname'
        values[:streetname] = "%#{params[:streetname].to_geo}%"
        join_address = join_street = true
      end
      unless params[:building].blank?
        conditions << '(address.building LIKE :building OR address.house LIKE :building)'
        values[:building] = "%#{params[:building].to_geo}%"
        join_address = true
      end
      unless params[:flate].blank?
        conditions << 'address.flate LIKE :flate'
        values[:flate] = "%#{params[:flate].to_geo}%"
        join_address = true
      end
    end
    rel = Bs::Customer
    rel = rel.joins('INNER JOIN bs.address ON customer.premisekey = address.premisekey') if join_address
    rel = rel.joins('INNER JOIN bs.region ON address.regionkey = region.regionkey') if join_regions
    rel = rel.joins('INNER JOIN bs.street ON address.streetkey = street.streetkey') if join_address
    rel.where(conditions.join(' AND '), values).paginate(per_page: 15, page: page).order(:accnumb)
  end

end
