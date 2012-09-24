xml.reesters do
  @routes.each do |route|
    xml.reester do
      xml.id(route.route_header_id)
      xml.cycledate(route.cycledate.strftime('%d-%b-%Y'))
      xml.schedule(route.schedkey)
      xml.route(route.routekey)
      xml.inspector(route.inspectorid)
      xml.block_id(route.route.blockkey)
      xml.block_name(route.route.block.blockname.strip.to_ka)
      xml.region_id(route.route.block.regionkey)
      xml.region_name(route.route.block.region.regionname.strip.to_ka)
      xml.downloads(route.download_count)
      xml.uploads(route.upload_count)
      xml.status(route.status)
      xml.count(route.items.size)
    end
  end
end