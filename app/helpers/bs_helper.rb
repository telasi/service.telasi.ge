# -*- encoding : utf-8 -*-
module BsHelper

  def route_header_class(route)
    if route.sent?
      "error"
    elsif route.complete?
      "warning"
    elsif route.synced?
      "success"
    end
  end

  def route_header_status_name(route)
    status = route.status if route.instance_of? Bs::RouteStoreHeader
    status = route if route.instance_of?(Integer) or route.instance_of?(Fixnum)
    # 
  end

end