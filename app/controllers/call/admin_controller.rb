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
        redirect_to call_statuses_url, notice: 'სტატუსი დამატებულია.'
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

  # documents

  def docs
    @title = 'დოკუმენტები'
    @docs = Call::Doc.asc(:order_by)
    navbuttons
  end

  def new_doc
    @title = 'ახალი დოკუმენტი'
    @doc = Call::Doc.new
    @form = DocsForm.doc_form(@doc, auth_token)
    @form.edit = true
    if request.post?
      @form << params[:dim]
      if @form.valid?
        @form >> @doc
        @doc.save
        redirect_to call_admin_docs_url, notice: 'დოკუმენტი დამატებულია.'
      end
    end
    navbuttons
  end

  def edit_doc
    @title = 'დოკუმენტის შეცვლა'
    @doc = Call::Doc.find(params[:id])
    @form = DocsForm.doc_form(@doc, auth_token)
    @form.edit = true
    if request.post?
      @form << params[:dim]
      if @form.valid?
        @form >> @doc
        @doc.save
        redirect_to call_admin_docs_url, notice: 'დოკუმენტი შეცვლილია.'
      end
    end
    navbuttons
  end

  # categories

  def categories
    @title = 'კატეგორიები'
    @categories = Call::Category.asc(:order_by)
    navbuttons
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
    if @docs or @doc
      @nav['დოკუმენტები'] = call_admin_docs_url
      @nav['დოკუმენტი'] = nil if @doc
    end
    if @categories or @category
      @nav['კატეგორიები'] = call_categories_url
      #@nav[@title] = nil if @category
    end
  end
end
