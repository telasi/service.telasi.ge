xml.reesters do
  @routes.each do |route|
    xml.reester do
      xml << render(partial: 'android/readings/reester_header', locals: {route: route})
    end
  end
end