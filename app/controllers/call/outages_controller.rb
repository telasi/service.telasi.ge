# -*- encoding : utf-8 -*-
class Call::OutagesController < Call::CallController
  def index
    @title = 'გათიშვები'
    @outages = Call::Outage.where(active: true).desc(:_id)
    @outage = Call::Outage.find(params[:id]) if params[:id].present?
    navbuttons
  end

  def archive
    @title = 'გათიშვების არქივი'
    @search = params[:search] == 'clear' ? {} : params[:search]
    rel = Call::Outage
    if @search
      customer = Bs::Customer.where(accnumb: @search[:accnumb].strip.to_geo).first rescue nil
      rel = rel.where(custkey: customer.custkey) if customer
      rel = rel.where(category: @search[:category]) if @search[:category].present?
      d1 = Date.strptime(@search[:d1]) if @search[:d1].present?
      d2 = Date.strptime(@search[:d2]) if @search[:d2].present?
      rel = rel.where(:created_at.gte => d1) if d1.present?
      rel = rel.where(:created_at.lte => d2 + 1) if d2.present?
    end
    @outages = rel.desc(:_id).paginate(page: params[:page], per_page: 10)
    navbuttons
  end

  def show
    @title = 'გათიშვის თვისებები'
    @outage = Call::Outage.find(params[:id])
    navbuttons
  end

  def on
    outage = Call::Outage.find(params[:id])
    outage.active = false ; outage.save
    redirect_to call_outages_url, notice: 'გათიშვა გაუქმებულია'
  end

  def ons
    outages = Call::Outage.in(_id: params[:ids])
    outages.each do |out|
      out.active = false
      out.save
    end
    render text: 'ok'
  end

  def new
    @title = 'ახალი გათიშვა'
    if request.post?
      @outage = Call::Outage.new(params[:call_outage])
      redirect_to call_outage_url(id: @outage.id), notice: 'გამორთვა დამატებულია' if @outage.save
    else
      @outage = Call::Outage.new
    end
    navbuttons
  end

  def edit
    @title = 'გათიშვის შეცვლა'
    @outage = Call::Outage.find(params[:id])
    if request.post?
      redirect_to call_outage_url(id: @outage.id), notice: 'გამორთვა შეცვლილია' if @outage.update_attributes(params[:call_outage])
    end
    navbuttons
  end

  def delete
    outage = Call::Outage.find(params[:id])
    outage.streets.destroy_all
    outage.destroy
    redirect_to call_outages_url, notice: 'გამორთვა წაშლილია'
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'გათიშვები' => call_outages_url }
    if @outage or action_name == 'archive'
      @nav[@title] = nil
    end
  end
end
