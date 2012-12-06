# -*- encoding : utf-8 -*-
module CraHelper

  def cra_address_icon(identificator_id)
    case identificator_id
    when 1 then 'fff/world.png' # ჩვენი ქვეყანა
    when 2 then 'fff/world.png' # რეგიონი
    when 116 then 'fff/world.png' # საზღვარგარეთი

    when 6 then 'fff/building.png' # ქალაქი    
    when 32 then 'fff/building.png' # ქალაქის რაიონი
    when 3 then 'fff/building.png' # რაიონი
    when 4 then 'fff/building.png' # სოფელი
    when 5 then 'fff/building.png' # დაბა

    when 7 then 'fff/arrow_turn_right.png' # ქუჩა
    when 15 then 'fff/arrow_turn_right.png' # შესახვევი
    when 66 then 'fff/arrow_turn_right.png' # გზა
    when 12 then 'fff/arrow_turn_right.png' # სანაპირო

    when 42 then 'fff/brick.png' # მასივი
    when 10 then 'fff/brick.png' # გამზირი

    when 29 then 'fff/house.png' # სახლი
    when 113 then 'fff/house.png' # ბინა

    when 122 then 'fff/application.png' # გაურკვეველი
    when 99 then 'fff/application.png' # მისამართის გარეშე
    end
  end

end