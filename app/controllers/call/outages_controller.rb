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

    ##############################  damatebulia bacho 12/04/2016
     ruby_id=outage.id
     func_oci8
     @conn_io1.exec("
                    UPDATE call.outage_crashlogs   
                      SET STATUS= 'C'
                     WHERE ruby_id='#{ruby_id}'
                    ")

     @conn_io1.commit
     @conn_io1.logoff
    ##############################


    redirect_to call_outages_url, notice: 'გათიშვა გაუქმებულია'
  end

  def ons
    outages = Call::Outage.in(_id: params[:ids])
    outages.each do |out|
      out.active = false
      out.save

    ##############################  damatebulia bacho 12/04/2016
     ruby_id=out.id
     func_oci8
     @conn_io1.exec("
                    UPDATE call.outage_crashlogs   
                      SET STATUS= 'C'
                     WHERE ruby_id='#{ruby_id}'
                    ")

     @conn_io1.commit
     @conn_io1.logoff
    ##############################

    end
    render text: 'ok'
  end

  def new
    @title = 'ახალი გათიშვა'
    if request.post?
      @outage = Call::Outage.new(params[:call_outage])
      redirect_to call_outage_url(id: @outage.id), notice: 'გამორთვა დამატებულია' if @outage.save
    #raise  params[:call_outage]
    

   # damatebulia 08/04/2016  bacho

   call_outage= params[:call_outage]

   ruby_id=@outage.id
   accnumb=call_outage[:accnumb]
   custkey=call_outage[:custkey]
   category=call_outage[:category]   
   description=call_outage[:description]   
   start_date=call_outage[:start_date]   
   start_time=call_outage[:start_time]   
   end_date=call_outage[:end_date]   
   end_time=call_outage[:end_time]                  
   func_oci8
   @conn_io1.exec("insert into call.outage_crashlogs   
                    ( RUBY_ID,
                      START_DATE,
                      START_TIME,
                      END_DATE,
                      END_TIME,
                      STATUS,
                      ACCNUMB,
                      CUSTKEY,
                      CATEGORY,
                      DESCRIPTION
                      ) 
                   values 
                      ('#{ruby_id}',
                       to_date('#{start_date}','yyyy-mm-dd'),
                      '#{start_time}',
                       to_date('#{end_date}','yyyy-mm-dd'),
                      '#{end_time}',
                      'A',
                      '#{accnumb}',
                      '#{custkey}',
                      '#{category}',
                      '#{description}'
                      ) ")

   @conn_io1.commit
   @conn_io1.logoff

   ###############################
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
    ##############################  damatebulia bacho 11/04/2016
   
     call_outage= params[:call_outage]

     ruby_id=@outage.id
     accnumb=call_outage[:accnumb]
     custkey=call_outage[:custkey]
     category=call_outage[:category]   
     description=call_outage[:description]   
     start_date=call_outage[:start_date]   
     start_time=call_outage[:start_time]   
     end_date=call_outage[:end_date]   
     end_time=call_outage[:end_time]       

     func_oci8
     ruby_id=@outage.id
     @conn_io1.exec("
                    UPDATE call.outage_crashlogs   
                               SET  RUBY_ID='#{ruby_id}',
                                    START_DATE= to_date('#{start_date}','yyyy-mm-dd'),
                                    START_TIME= '#{start_time}',
                                    END_DATE= to_date('#{end_date}','yyyy-mm-dd'),
                                    END_TIME= '#{end_time}',
                                    -- STATUS= 'Y',
                                    ACCNUMB= '#{accnumb}',
                                    --CUSTKEY=null,
                                    CATEGORY='#{category}',
                                    DESCRIPTION= '#{description}'
                      WHERE ruby_id='#{ruby_id}'
                    ")

     @conn_io1.commit
     @conn_io1.logoff

    ##############################



    end
    navbuttons
  end

  def delete
    outage = Call::Outage.find(params[:id])
    outage.streets.destroy_all
    outage.destroy
    ##############################  damatebulia bacho 11/04/2016
     func_oci8
     @conn_io1.exec("DELETE call.outage_crashlogs WHERE RUBY_ID='#{params[:id]}'")

     @conn_io1.commit
     @conn_io1.logoff

    ##############################
    redirect_to call_outages_url, notice: 'გამორთვა წაშლილია'
  end

  ################################ ბაჩო 19/04/2016
  def outage_sync

    
    outage = Call::Outage.where(active: true).where(category: 1)
    #debugger
    outage.each do |out|
    out.streets.destroy_all
    end
    #debugger
    outage.destroy
    check_array = []

         func_oci8
             cursor = @conn_io1.parse("select distinct
                                               trunc(b.start_date + 1 / 6) start_date,
                                               to_char(b.start_date + 1 / 6, 'HH24:MI') start_time,
                                               trunc(b.end_date + 1 / 6) end_date,
                                               to_char(b.end_date + 1 / 6, 'HH24:MI') end_time,
                                               'true' active,
                                               c.accnumb,
                                               a.custkey,
                                               '1' category,
                                               b.description 
                                          from call.outage_bases b, call.outage_tps tp, bs.account a, bs.customer c
                                         where tp.base_id = b.id
                                           and tp.acckey = a.acckey
                                           and trunc(b.start_date) = trunc(sysdate)
                                           and c.custkey=a.custkey ")


             cursor.exec

     while r = cursor.fetch 
      #debugger




       aa = Call::Outage.new( 
                                  start_date:   r[0],
                                  start_time:   r[1],
                                  end_date:     r[2],
                                  end_time:     r[3],
                                  active:       true,
                                  accnumb:      r[5],
                                  custkey:      r[6],
                                  category:     r[7],
                                  description:  r[8].to_ka
                                  )
     ## dublirebisgan dacva
     if !check_array.include?(r[6])
        check_array.push(r[6])   
        aa.save!
     end
     #####################################


     end

    cursor.close
    @conn_io1.logoff
   
    #redirect_to call_outages_url, notice: 'განახლება დასრულებულია'
  end 
  ##############################

  def syncpage

  end  

  #############################

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'გათიშვები' => call_outages_url }
    if @outage or action_name == 'archive'
      @nav[@title] = nil
    end
  end

  # damatebulia 08/04/2016  bacho
  def func_oci8
   require 'oci8'
   @conn_io1 =OCI8.new(Bsconnection::USR, Bsconnection::PASS, Bsconnection::IPSID) # dziritadze aq unda chauweros call iuzeri
  end
  ###############################

end
