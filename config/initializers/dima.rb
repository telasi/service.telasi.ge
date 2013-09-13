# -*- encoding : utf-8 -*-
module Dima::Html

  class DateField
    attr_accessor :not_local

    def val
      val = super
      (self.not_local ? val : val.localtime) if val
    end
  end

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
        text = v.to_s
        @val = text.present? ? text.to_geo : nil
      else
        @val = v
      end
    end

  end

end
