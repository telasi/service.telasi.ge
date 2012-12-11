# -*- encoding : utf-8 -*-
module CraHelper

  def cra_address_icon(identificator_id)
    case identificator_id
    when 1 then 'fff/world.png' # ჩვენი ქვეყანა
    when 2 then 'fff/world.png' # რეგიონი
    when 116 then 'fff/world.png' # საზღვარგარეთი
    when 127 then 'fff/world.png' # ქვეყანა

    when 6 then 'fff/building.png' # ქალაქი    
    when 32 then 'fff/building.png' # ქალაქის რაიონი
    
    when 4 then 'fff/building.png' # სოფელი
    when 5 then 'fff/building.png' # დაბა
    when 100 then 'fff/building.png' # სამხედრო დასახლება
    when 39 then 'fff/building.png' # დასახლება
    when 28 then 'fff/building.png'  # კორპუსი

    when 7 then 'fff/arrow_turn_right.png' # ქუჩა
    when 15 then 'fff/arrow_turn_right.png' # შესახვევი
    when 66 then 'fff/arrow_turn_right.png' # გზა
    when 12 then 'fff/arrow_turn_right.png' # სანაპირო
    when 91 then 'fff/arrow_turn_right.png' # მთა
    when 19 then 'fff/arrow_turn_right.png' # აღმართი
    when 13 then 'fff/arrow_out.png' # მოედანი
    when 11 then 'fff/arrow_turn_right.png' # გზატკეცილი
    when 18 then 'fff/arrow_turn_right.png' # ჩიხი
    when 21 then 'fff/arrow_turn_right.png' # ხეივანი
    when 22 then 'fff/arrow_turn_right.png' # ხევი
    when 17 then 'fff/arrow_turn_right.png' # გასასვლელი

    when 3 then 'fff/bricks.png' # რაიონი
    when 42 then 'fff/brick.png' # მასივი
    when 10 then 'fff/brick.png' # გამზირი
    when 26 then 'fff/brick.png' # მიკრორაიონი
    when 104 then 'fff/brick.png' # მეურნეობა
    when 81 then 'fff/brick.png' # კომპლექსი
    when 82 then 'fff/brick.png' # ფერდობი
    when 90 then 'fff/brick.png' # სამხედრო ქალაქი
    when 131 then 'fff/brick.png' # ზემო პლატო
    when 103 then 'fff/brick.png' # უბანი
    when 27 then 'fff/brick.png' # კვარტალი

    when 29 then 'fff/house.png' # სახლი
    when 113 then 'fff/house.png' # ბინა
    when 155 then 'fff/house.png' # სასტუმრო
    when 156 then 'fff/house.png'  # ბაგა-ბაღი
    when 142 then 'fff/house.png'  # მიმდებარე ტერიტორია
    when 134 then 'fff/house.png'  # აგარაკი

    when 102 then 'fff/lorry.png' # სადგური
    when 140 then 'fff/cancel.png'  # სასჯელაღსრულების დაწესებულება
    when 157 then 'fff/cog.png'  # ქარხანა
    when 92 then 'fff/shading.png'  # ნაკვეთი
    when 166 then 'fff/medal_gold_3.png'  # აკადემია
    when 154 then 'fff/bug.png' # მებაღეობა

    when 122 then 'fff/application.png' # გაურკვეველი
    when 99 then 'fff/application.png' # მისამართის გარეშე
    end
  end

end
