# -*- encoding : utf-8 -*-
class Call::CallMobilesController < ApplicationController
  
  #helper_method :ka_to_bs_str
  # GET /call/call_mobiles
  # GET /call/call_mobiles.json
  def index
    @call_call_mobiles = Call::CallMobile.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @call_call_mobiles }
    end
  end

  # GET /call/call_mobiles/1
  # GET /call/call_mobiles/1.json
  def show
    @call_call_mobile = Call::CallMobile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @call_call_mobile }
    end
  end

  # GET /call/call_mobiles/new
  # GET /call/call_mobiles/new.json
  def new
    @call_call_mobile = Call::CallMobile.new
    @accnumb = params[:accnumb]
    @custname = params[:custname] 
    if @custname.nil?
      @custname = 'სახელი არ იძებნება'
    end  
    @callmobilearch = Call::CallMobile.where(accnumb: @accnumb).paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @call_call_mobile }
    end
  end

  # GET /call/call_mobiles/1/edit
  def edit
    @call_call_mobile = Call::CallMobile.find(params[:id])
  end

  # POST /call/call_mobiles
  # POST /call/call_mobiles.json
  def create
    @call_call_mobile = Call::CallMobile.new(params[:call_call_mobile])
    @call_call_mobile.accnumb =  params[:accnumb]
    @call_call_mobile.enterdate = params[:enterdate]
    @call_call_mobile.operator_call = params[:operator_call]
    @call_call_mobile.status = params[:status]
    #@call_call_mobile.note_call = note_call_bs
    respond_to do |format|
      if @call_call_mobile.save
        format.html { redirect_to call_call_mobiles_url, notice: 'განაცხადი წარმატებით გაიგზავნა' }
        format.json { render json: @call_call_mobile, status: :created, location: @call_call_mobile }
      else
        format.html { render action: "new" }
        format.json { render json: @call_call_mobile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /call/call_mobiles/1
  # PUT /call/call_mobiles/1.json
  def update
    @call_call_mobile = Call::CallMobile.find(params[:id])

    respond_to do |format|
      if @call_call_mobile.update_attributes(params[:call_call_mobile])
        format.html { redirect_to @call_call_mobile, notice: 'Call mobile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @call_call_mobile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /call/call_mobiles/1
  # DELETE /call/call_mobiles/1.json
  def destroy
    @call_call_mobile = Call::CallMobile.find(params[:id])
    @call_call_mobile.destroy

    respond_to do |format|
      format.html { redirect_to call_call_mobiles_url }
      format.json { head :no_content }
    end
  end




private

    def call_call_mobile_params
      params.require(:call_call_mobile).permit( :id,
                                                :accnumb,
                                                :mobile,
                                                :status,
                                                :enterdate,
                                                :note_call,
                                                :note_bill,
                                                :custname,
                                                :operator_call,
                                                :operator_billing
                                                )
    end



end
