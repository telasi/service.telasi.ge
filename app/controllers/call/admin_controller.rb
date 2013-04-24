# -*- encoding : utf-8 -*-
class Call::AdminController < Call::CallController

  def index
    @title = 'ადმინისტრირება'
    navbuttons
  end

  # statuses

  def statuses
    @title = 'სტატუსები'
    @statuses = Call::Status.asc(:order_by)
    navbuttons
  end

  def new_status
    @title = 'ახალი სტატუსი'
    @status = Call::Status.new(open: false, default: false)
    @form = StatusForm.status_form(@status, auth_token)
    @form.edit = true
    if request.post?
      @form << params[:dim]
      if @form.valid?
        @form >> @status
        @status.save
        redirect_to call_statuses_url, notice: 'სტატუსი დამატებულია!'
      end
    end
    navbuttons
  end

  def edit_status
    @title = 'სტატუსის შეცვლა'
    @status = Call::Status.find(params[:id])
    @form = StatusForm.status_form(@status, auth_token)
    @form.edit = true
    if request.post?
      @form << params[:dim]
      if @form.valid?
        @form >> @status
        @status.save
        redirect_to call_statuses_url, notice: 'სტატუსი შეცვლილია.'
      end
    end
    navbuttons
  end

  def delete_status
    @status = Call::Status.find(params[:id])
    @status.destroy
    redirect_to call_statuses_url, notice: 'სტატუსი წაშლილია.'
  end

  # region data

  def regions
    @title = 'რეგიონები'
    @regions = Call::RegionData.asc(:_id)
    navbuttons
  end

  def sync_regions
    Call::RegionData.sync
    redirect_to call_regions_url, notice: 'რეგიონები სინქრონიზირებულია.'
  end

  def edit_region
    @title = 'მობილურების შეცვლა'
    @region = Call::RegionData.find(params[:id])
    @form = RegionDataForm.region_data_form(@region, auth_token)
    @form.edit = true
    if request.post?
      @form << params[:dim]
      if @form.valid?
        @form >> @region
        @region.save
        redirect_to call_regions_url, notice: 'რეგიონი შეცვლილია.'
      end
    end
    navbuttons
  end

  def delete_region
    mobiles = Call::RegionData.find(params[:id])
    mobiles.destroy
    redirect_to call_home_url, notice: 'მობილურები წაშლილია.'
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'ადმინისტრირება' => call_admin_url }
    if @statuses or @status
      @nav['სტატუსები'] = call_statuses_url
      @nav['სტატუსი'] = nil if @status
    end
    if @regions or @region
      @nav['რეგიონები'] = call_regions_url
      @nav['რეგიონი'] = nil if @region
    end
  end

end
