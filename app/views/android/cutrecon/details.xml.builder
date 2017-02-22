#xml.header do
#  xml << render(partial: 'android/cutrecon/cutrecon_header', locals: {header: @route})
  xml.items do
    @route.items.each do |item|
      xml.item do
        xml.cr_key(item.cr_key)
        xml.custkey(item.custkey)
        xml.accnumb(item.customer.accnumb) if item.customer
        xml.custname(item.customer.custname.strip.to_ka) if item.customer
        xml.orderby(item.orderby)
        xml.address do 
          xml.full_address(item.customer.address.to_s2) if item.customer
          if item.account
            xml.accstatus(item.account.statuskey)
            xml.street_id(item.account.address.street.streetkey)
            xml.street_name(item.account.address.street.streetname.strip.to_ka)
            xml.house(item.account.address.house.strip.to_ka) if item.account.address.house
            xml.building(item.account.address.building.strip.to_ka) if item.account.address.building
            xml.porch(item.account.address.porch.strip.to_ka) if item.account.address.porch
            xml.flate(item.account.address.flate.strip.to_ka) if item.account.address.flate
          end
        end
        xml.mtnumb(item.mtnumb)
        xml.sealnumb(item.sealnumb)
        xml.reading do
          xml.reading(item.reading)
          xml.mark_code(item.mark_code)
          xml.discrecstatuskey(item.discrecstatuskey)
          if item.note
            if item.note.to_ka == 'Automatic reconnection'
              xml.note('')
            else
              xml.note(item.note.to_ka) 
            end
          end
        end
        xml.balance do
          xml.balance(item.balance)
          xml.balance_tr(item.balance_tr)
          xml.balance_w(item.balance_w)
          xml.chargeamount(item.chargeamount)
          d = DateTime.new(1900,1,1)
          #xml.lastpaydate([item.lastpaydate || d, item.lastpaydate_tr  || d, item.lastpaydate_w || d].max.strftime('%Y-%m-%d %H:%M:%S'))
          xml.lastpaydate([item.paydate_sys.strftime('%Y-%m-%d %H:%M:%S'))
        end
      end
    end
  end
#end