xml.discrecstatuses do
  @discrecstatuses.each do |item|
    xml.discrecstatus do
      xml.discrecstatuskey(item.discrecstatuskey)
      xml.discrecstatus_det_key(item.discrecstatus_det_key)
      xml.status(item.status)
      xml.discrecstatusname(item.discrecstatus.discrecstatname.to_ka)
      xml.name(item.name.to_ka)
    end
  end
end