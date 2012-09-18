# -*- encoding : utf-8 -*-
module BsHelper

  def route_header_class(route)
    if route.sent?
      "warning"
    elsif route.complete?
      "success"
    end
  end

end