# -*- encoding : utf-8 -*-
class Bs::WaterExceptions < ActiveRecord::Base
  self.table_name  = 'bs.water_exceptions' 
  self.primary_key = :accnumb
  self.set_integer_columns :status

  #belongs_to :water_customer, class_name: 'Bs::WaterCustomer', foreign_key: :accnumb  


  def water_form_fld
  	if !self.enterdate_w.nil?
     case self.status
       when 0 
       	"სტატუსი: აქტიური ჩანაწერი,  თარიღი: " + self.enterdate_w.strftime("%d/%m/%Y")
       when 1 
        "სტატუსი: ჩართვის სიაში მოხვდა,  თარიღი: " + self.enterdate_w.strftime("%d/%m/%Y")
       when 2         
        "სტატუსი: გაუქმებული ჩანაწერი,  თარიღი: " + self.enterdate_w.strftime("%d/%m/%Y")
       else
        "უცნობი სტატუსი" 
     end  
    else
        "ჩანაწერი არ იძებნება"
    end 
  end

end
