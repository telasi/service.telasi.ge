# -*- encoding : utf-8 -*-
class Call::OutagesController < Call::CallController
  def index
    @title = 'გათიშვები'
    @outages = Call::Outage.where(active: true).desc(:_id).paginate(page: params[:page], per_page: params[:per_page])
    @outage = Call::Outage.find(params[:id]) if params[:id].present?
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
    @nav[@title] = nil if @outage
  end
end
