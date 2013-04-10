# -*- encoding : utf-8 -*-
module Dima::Html

  class TextField

    def val
      @val.to_s.to_ka if @val
    end

    def val=(v)
      @val = v ? v.to_s.to_geo : nil
    end

  end

end
