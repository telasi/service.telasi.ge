# -*- encoding : utf-8 -*-
class DatePickerInput < SimpleForm::Inputs::StringInput 
  def input                    
    value = object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= value.strftime('%d-%b-%Y') if value.present?
    input_html_classes << 'datepicker'
    input_html_classes << 'span2'
    super
  end
end
