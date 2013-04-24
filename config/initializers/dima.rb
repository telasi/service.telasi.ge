# -*- encoding : utf-8 -*-
module Dima::Html

  class TextField
    attr_accessor :original

    def val
      unless self.original
        @val.to_s.to_ka if @val
      else
        @val
      end
    end

    def val=(v)
      unless self.original
        @val = v ? v.to_s.to_geo : nil
      else
        @val = v
      end
    end

  end

end
