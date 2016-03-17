# -*- encoding : utf-8 -*-
class Sys::SmsClientDataController<ApplicationController

  # before_action :set_clientdata, only: [:show, :edit, :update, :destroy]
  # before_action :set_article, only: [:edit, :update, :show, :destroy]


	def index
       @clientdata_full=Sms_client_data.all
	end


    def show    
      @sms_client_data = Sms_client_data.find(params[:id])	
    end

    def new
      @sms_client_data = Sms_client_data.new
    end

	def edit
	  @sms_client_data = Sms_client_data.find(params[:id])
	end

    def create
      @sms_client_data = Sms_client_data.new(params[:sms_client_data])
      respond_to do |format|
	      if @sms_client_data.save
	        format.html { redirect_to sys_sms_client_data_path, 
	        	notice: 'ჩანაწერი დამატებულია.' }
	      else
	        format.html { render action: "new" }
	      end
      end

    end



	def update    

    respond_to do |format|
      @sms_client_data = Sms_client_data.find(params[:id])	
       if @sms_client_data.update_attributes(params[:sms_client_data])
       	  #redirect_to sys_sms_client_data_path
          #redirect_to sys_sms_client_datum_path(@sms_client_data)
          format.html { redirect_to sys_sms_client_datum_path(@sms_client_data), 
          	                  notice: 'კლიენტის მონაცემები წარმეტებით შეიცვალა' }
       else
         format.html { render action: "edit" }
      end
    end

    # @article=Article.find(params[:id])
    #if @sms_client_data.update(sms_client_data_params)
     #  redirect_to sys_sms_client_datum_path(@sms_client_data)
       #redirect_to sys_sms_client_data_path
   # else
    #  render 'edit'
    #end


    end

  def destroy
    @sms_client_data = Sms_client_data.find(params[:id])
    @sms_client_data.destroy

    respond_to do |format|
      format.html { redirect_to sys_sms_client_data_path ,
                    notice: 'ჩანაწერი წაშლილია'}

    end
  end   

private

    def sms_client_data_params
      params.require(:sms_client_data).permit(:clientname, :phone , :lang , :active , :group)
      # category_ids:[] gamoiyeneba create actionshi @article = Article.new(article_params) aq ketdeba whitelist ingi
      #[] aris array form
      # radgan cxrilebs shoris gawerilia constraintebi, 
      # @article rails avtomaturad xvdeba masivshi ra uyos
    end


end	