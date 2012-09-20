# -*- encoding : utf-8 -*-
module BsHelper

  def route_header_class(route)
    if route.sent?
      "warning"
    elsif route.complete?
      "success"
    elsif route.synced?
      "canceled"
    end
  end

  def route_header_status_name(route)
    status = route.status if route.instance_of? Bs::RouteStoreHeader
    status = route if route.instance_of?(Integer) or route.instance_of?(Fixnum)
    # 
  end

end