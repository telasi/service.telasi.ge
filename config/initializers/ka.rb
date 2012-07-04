# -*- encoding : utf-8 -*-
class String
  GEO = 'ÀÁÂÃÄÅÆÈÉÊËÌÍÏÐÑÒÓÔÖ×ØÙÚÛÜÝÞßàáãä'
  KA = 'აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ'
  LAT = 'abgdevzTiklmnopJrstufqRySCcZwWxjh'

  def translate(from, to)
    txt = ""
    self.split('').each do |c|
      indx = from.index(c)
      txt += indx ? to[indx] : c
    end
    txt
  end

  def to_ka
    self.translate(GEO, KA)
  end

  def to_geo
    self.translate(KA, GEO)
  end

  def to_lat
    self.translate("#{GEO}#{KA}", "#{LAT}#{LAT}")
  end

end
