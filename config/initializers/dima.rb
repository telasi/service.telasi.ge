module Dima::Html

  class TextField

    def val
      @val.to_s.to_ka if @val
    end

    def val=(v)
      @val = v.to_s.to_geo if v
    end

  end

end