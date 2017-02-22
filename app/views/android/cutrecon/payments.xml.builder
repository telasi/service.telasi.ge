xml.payments do
  @payments.each do |item|
    xml.payment do
      xml.paydate(item.paydate.strftime('%Y-%m-%d %H:%M:%S'))
      xml.amount(item.amount)
      xml.billnumber(item.billnumber)
      xml.status(item.status)
    end
  end
end