xml.id(route.route_header_id)
xml.cycledate(route.cycledate.strftime('%d-%b-%Y'))
xml.schedule(route.schedkey)
xml.route(route.routekey)
xml.inspector(route.inspectorid)
xml.inspector_name(route.inspector.persname.strip.to_ka)
xml.downloads(route.download_count)
xml.uploads(route.upload_count)
xml.status(route.status)
xml.count(route.items.size)
if route.route
  xml.route_name(route.route.routename.strip.to_ka)
  xml.block_id(route.route.blockkey)
  xml.block_name(route.route.block.blockname.strip.to_ka)
  xml.region_name(route.route.block.region.regionname.strip.to_ka)
  xml.region_id(route.route.block.regionkey)
end
