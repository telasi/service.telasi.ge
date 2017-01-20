xml.headers do
  @routes.each do |header|
    xml.header do
      xml << render(partial: 'android/cutrecon/cutrecon_header', locals: {header: header})
    end
  end
end