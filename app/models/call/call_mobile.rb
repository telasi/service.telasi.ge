# -*- encoding : utf-8 -*-
class Call::CallMobile < ActiveRecord::Base
  self.table_name  = 'bs.call_mobile'
  self.primary_key = :id

  self.set_integer_columns :status,:id

  before_save {self.note_call = note_call_bs}
  before_save {self.custname = custname_bs}
  before_save {self.operator_call = operator_call_bs}

  VALID_MOBILE_REGEX = /^5[0-9]{8}\z/

  validates  :mobile ,  format: {with: VALID_MOBILE_REGEX } , :allow_blank => true
  validates  :accnumb , presence: true

  def  note_call_bs
  	  if !self.note_call.nil?  
        self.note_call.tr("აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ","ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä")
      else
  	    'მონაცემები არ იძებნება'
      end
  end

  def  note_bill_bs
  	  if !self.note_bill.nil?  
        self.note_bill.tr("აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ","ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä")
      else
  	    'მონაცემები არ იძებნება'
      end
  end


  def  custname_bs
  	  if !self.custname.nil?  
        self.custname.tr("აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ","ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä") 
      else
  	    'მონაცემები არ იძებნება'
      end      
  end

  def  operator_call_bs
  	  if !self.operator_call.nil?  
         self.operator_call.tr("აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ","ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä") 
      else
  	    'მონაცემები არ იძებნება'
      end     
  end


  def  bs_note_call
  	  if !self.note_call.nil?  
         self.note_call.tr("ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä","აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ").force_encoding("UTF-8") 
      else
  	    nil
      end
  end

  def  bs_custname
  	  if !self.custname.nil?    	
        self.custname.tr("ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä","აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ").force_encoding("UTF-8") 
      else
  	    nil
      end     
  end

  def  bs_operator_call
  	  if !self.operator_call.nil?    	
         self.operator_call.tr("ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä","აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ").force_encoding("UTF-8") 
      else
  	    nil
      end    
  end

  def  bs_note_bill
  	  if !self.note_bill.nil?    	
         self.note_bill.tr("ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä","აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ").force_encoding("UTF-8") 
      else
  	    nil
      end    
  end

  def status_desc
     case self.status 
       when  2  then  'უარყოფილი'  
       when  0  then  'საწყისი'
       when  1  then  'დადასტურებული'         
     else  
       self.status           	
     end
  end



end
