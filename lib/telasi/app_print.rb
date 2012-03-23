# -*- encoding : utf-8 -*-
require 'c12-commons'

module Telasi
  def self.print_application(app, file)
    C12::PDF::Document.generate file, :page_size => 'A4', :margin => [40, 30] do |pdf|
      build_pdf app, pdf
    end
  end

  private

  DEF_FONT_SIZE = 10
  DATA_SIZE = DEF_FONT_SIZE - 1
  SMALL_SIZE = 5

  def self.build_pdf(app, pdf)
    pdf.change_font(:default, DEF_FONT_SIZE)
    render_header(app, pdf)
    render_part1(app, pdf)
    render_part2(app, pdf)
    render_part3(app, pdf)
    render_part4(app, pdf)
    render_part5(app, pdf)
  end

  def self.render_header(app, pdf)
    pdf.move_down 80
    pdf.change_font(:serif, DEF_FONT_SIZE - 1)
    t = %Q{საქართველოს ენერგეტიკისა და წყალმომარაგების მარეგულირებელი ეროვნული კომისიის 2011 წლის 22 ნოემბრის №30/1 გადაწყვეტილებით}
    pdf.table [['', '"დამტკიცებულია"'], ['', t]], :column_widths => [pdf.bounds.width - 250, 250], :cell_style => {:borders => []} do
      row(0).style(:align => :center)
    end

    pdf.move_down 30
    pdf.change_font(:serif, DEF_FONT_SIZE + 3)
    pdf.text 'გ ა ნ ა ც ხ ა დ ი', :align => :center
    pdf.move_down 10
    pdf.change_font(:default, DEF_FONT_SIZE + 1)
    pdf.text 'გამანაწილებელ ქსელზე ახალი მომხმარებლის მიერთების მოთხოვნის შესახებ', :align => :center

    pdf.move_down 30
    pdf.change_font(:default, DEF_FONT_SIZE)
    d = C12::KA.format_date(Time.now)
    pdf.table [['განაცხადის შევსების თარიღი', d]], :column_widths => [200, 150], :cell_style => {:borders => []} do
      column(1).style(:align => :center, :borders => [:bottom], :size => DATA_SIZE)
    end
  end

  def self.render_part1(app, pdf)
    pdf.change_font(:default, DEF_FONT_SIZE + 2)
    pdf.move_down 30
    pdf.text 'I. ზოგადი ინფორმაცია'

    pdf.move_down 20
    pdf.change_font(:default, DEF_FONT_SIZE)
    items = [
      ['ელექტროენერგიის გამანაწილებელი ლიცენზიანტი', 'სს თელასი'],
      ['მიერთების მსურველი (განმცხადებელი)', app.applicant.name],
      ['', 'სახელი, გვარი ან იურიდიული პირის შემთხვევაში მისი სახელი (სახელწოდება), ან სხვა პირის შემთხვევაში მისი სახელწოდება'],
      ['საიდენტიფიკაციო კოდი ან პირადი ნომერი', app.applicant.tin]
    ]
    pdf.table items, :column_widths => [250] do
      column(0).style(:borders => [])
      column(1).style(:borders => [:bottom], :align => :center, :padding => [10, 0, 5, 0], :size => DATA_SIZE)
      row(2).style(:borders => [], :size => SMALL_SIZE, :padding => 2)
    end

    pdf.move_down 20
    pdf.text 'მიერთების მსურველის (განმცხადებლის) საკონტაქტო ინფორმაცია:'
    pdf.move_down 5
    items = [['მისამართი', app.applicant.address]]
    pdf.table items, :column_widths => [100, pdf.bounds.width - 100] do
      column(0).style(:borders => [])
      column(1).style(:borders => [:bottom], :align => :center, :size => DATA_SIZE)
    end

    pdf.move_down 10
    items = [['მობ. ტელ.', app.applicant.mobile, 'ელ. ფოსტა', app.applicant.email]]
    pdf.table items, :column_widths => [75, 120, 75, pdf.bounds.width - 270], :cell_style => {:borders => []} do
      column(1).style(:borders => [:bottom], :align => :center, :size => DATA_SIZE)
      column(2).style(:align => :center)
      column(3).style(:borders => [:bottom], :align => :center, :size => DATA_SIZE)
    end

    pdf.move_down 10
    items = [['მიერთების მსურველის (განმცხადებლის) საბანკო რეკვიზიტები:'], ["#{app.bank_account.swift} #{app.bank_account.bank} #{app.bank_account.eban}".strip]]
    pdf.table items, :column_widths => [pdf.bounds.width] do
      row(0).style(:borders => [])
      row(1).style(:borders => [:bottom], :size => DATA_SIZE, :align => :center)
    end

    pdf.move_down 10
    items = [['ადგილი (მისამართი) სადაც უნდა მოხდეს ელექტრომომარაგება'], [app.address]]
    pdf.table items, :column_widths => [pdf.bounds.width] do
      row(0).style(:borders => [])
      row(1).style(:borders => [:bottom], :size => DATA_SIZE, :align => :center)
    end

    pdf.move_down 10
    email = "#{app.email_response ? '☑' : '☐' } ელექტრონული"
    writn = "#{app.written_response ? '☑' : '☐' } წერილობითი"
    items = [['განაწილების ლიცენზიატის მიერ შეტყობინების გაგზავნის ფორმა:'], ["#{writn}; #{email}"]]
    pdf.table items, :cell_style => {:borders => []}, :column_widths => [pdf.bounds.width] do
      row(1).style(:align => :center)
    end
  end


  def self.render_part2(app, pdf)
    pdf.start_new_page
    count = app.application_items.size
    p2 = (count == 1 or count == 2)
    pdf.change_font(:default, DEF_FONT_SIZE + 2)
    pdf.text "II. ერთი ან ორი აბონენტის მიერთების მოთხოვნის შემთხვევაში #{p2 ? '☑' : '☐'}"

    pdf.move_down 10
    pdf.change_font(:default, DEF_FONT_SIZE)
    pdf.text "განაცხადის მოთხოვნილი აბონენტთა რაოდენობა: ერთი #{count == 1 ? '☑' : '☐'}; ორი #{count == 2 ? '☑' : '☐'}."

    i1 = p2 ? app.application_items[0] : nil
    i2 = p2 ? app.application_items[1] : nil
    pdf.move_down 10
    items = [
      ['აბონენტი 1', 'აბონენტი 2'],
      ['1. დაზუსტებული მისამართი სადაც უნდა მოხდეს ელექტრომომარაგება:']*2,
      [i1 ? i1.address : ' ', i2 ? i2.address : ' '],
      ['2. აბონენტის (მოხმარებული ელ.ენერგიის საფასურის გადახდაზე პასუხისმგებელი პირის) სახელი, გვარი ან იურიდიული პირის სახელი:'] * 2,
      [i1 ? i1.name : ' ', i2 ? i2.name : ' '],
      ['2.1. პირადი ნომერი ან საიდენტიფიკაციო კოდი:'] * 2,
      [i1 ? i1.tin : ' ', i2 ? i2.tin : ' '],
      ['3. ელექტროენერგიის მოხმარების მიზანი:'] * 2,
      [personal_use(i1 ? i1.personal? : nil), personal_use(i2 ?  i2.personal? : nil)],
      ['4. უძრავი ქონების ობიქტის საკადასტრო კოდი (სადაც უნდა მოხდეს ელექტრომომარაგება):'] * 2,
      [i1 ? i1.address_code : ' ', i2 ? i2.address_code : ' '],
      ['5. მოთხოვნილი ძაბვის საფასური:'] * 2,
      [tariff_voltafe(i1), tariff_voltafe(i2)],
      ['6. მოთხოვნილი სიმძლავრე:'] * 2,
      [i1 ? "#{i1.tariff.power}კვტ" : ' ', i2 ? "#{i2.tariff.power}კვტ" : ' '],
      ['7. გამანაწილებელ ქსელზე მიერთების საფასური (შეთავაზებული პაკეტის მიხედვით):'] *2,
      [i1 ? "#{C12.number_format(i1.tariff.price, 0)} ლარი" : ' ', i2 ? "#{C12.number_format(i2.tariff.price, 0)} ლარი" : ' ']
    ]
    lbls = {:borders => [:left, :right]}
    flds = {:align => :center, :size => DATA_SIZE, :borders => [:bottom, :left, :right]}
    pdf.table items, :column_widths => [pdf.bounds.width / 2]*2 do
      row(0).style(:align => :center)
      row(1).style(lbls)
      row(2).style(flds)
      row(3).style(lbls)
      row(4).style(flds)
      row(5).style(lbls)
      row(6).style(flds)
      row(7).style(lbls)
      row(8).style(flds)
      row(9).style(lbls)
      row(10).style(flds)
      row(11).style(lbls)
      row(12).style(flds)
      row(13).style(lbls)
      row(14).style(flds)
      row(15).style(lbls)
      row(16).style(flds)
    end
  end

  def self.render_part3(app, pdf)
    pdf.move_down 20
    count = app.application_items.size
    p3 = count > 2
    pdf.change_font(:default, DEF_FONT_SIZE + 2)
    pdf.text "III. ერთდროულად სამი ან სამზე მეტი აბონენტის მიერთების მოთხოვნის შემთხვევაში #{p3 ? '☑' : '☐'}"

    pdf.change_font(:default, DEF_FONT_SIZE)
    items = [['განაცხადით მოთხოვნილი აბონენტთა (ინდ.აღრიცხვა) საერთო რაოდენობა:', p3 ? "  #{count}  " : ' ' * 5]]
    pdf.table items, :cell_style => {:borders => []} do
      column(1).style(:borders => [:bottom])
    end

    cnt_indv = 0
    cnt_fncl = 0
    cnt_othr = 0
    app.application_items.each do |item|
      if item.personal?
        cnt_indv += 1
      else
        cnt_fncl += 1
      end
    end if p3

    pdf.move_down 10
    pdf.text 'საყოფაცხოვრებო და არასაყოფაცხოვრებო აბონენტთა რაოდენობა:'
    items = [['საყოფაცხოვრებო', (cnt_indv == 0 ? ' ' * 5 : "  #{cnt_indv}  "),
      'არა საყოფაცხოვრებო', (cnt_fncl == 0 ? ' ' * 5 : "  #{cnt_fncl}  "),
      'განცალკევებული აღრიცხვა', (cnt_othr == 0 ? ' ' * 5 : "  #{cnt_othr}  "),
      ]]
    pdf.table items, :cell_style => {:borders => []} do
      column(1).style(:borders => [:bottom])
      column(3).style(:borders => [:bottom])
      column(5).style(:borders => [:bottom])
    end

    pdf.move_down 10
    items = [
      ['უძრავი ქონების საკადასტრო კოდი (სადაც უნდა მოხდეს ელექტრომომარაგება)', (p3 ? app.address_code : '')],
      ['საცხოვრებელი ბინის, საწარმოს ან სხვა სახის ობიექტის (ან ობიექტების) სამშენებლო-საპროექტო დოკუმენტაციით განსაზღვრული (დადგენილი) მისაერთებელი სიმძლავრე:', p3 ? "#{app.tariff.power} კვტ" : ''],
      ['გამანაწილებელ ქსელზე მიერთების საფასური (შეთავაზებული პაკეტის მიხედვით):', p3 ? "#{C12.number_format(app.tariff.price, 0)} ლარი" : '']
    ]
    pdf.table items, :cell_style => { :borders => []}, :column_widths => [pdf.bounds.width - 130, 130] do
      column(1).style(:borders => [:bottom])
    end
  end

  def self.render_part4(app, pdf)
    pdf.start_new_page
    pdf.change_font(:default, DEF_FONT_SIZE + 2)
    pdf.text "IV. თანდართული დოკუმენტაცია"
    pdf.change_font(:default, DEF_FONT_SIZE)

    pdf.move_down 20
    pdf.text 'მიერთების საფასური 50%-ის გადახდის დამადასტურებელი საბუთი ☐'

    pdf.move_down 20
    pdf.text 'ერთდროულად სამი ან სამზე მეტი აბონენტის რეგისტრაციის მოთხოვნის შემთხვევაში: ☐'
    pdf.move_down 20
    pdf.text 'საპროექტო ორგანიზაციის მიერ დამოწმებული, მისაერთებელი ობიექტის "პროექტის ელექტრულ ნაწილზე ახსნა-განმარტებითი ბარათი" (რომელიც დამუშავებულია, დამტკიცებულია პროექტის არქიტექტურულ-სამშენებლო ნაწილის მონაცემების საფუძველზე) ☐'
    pdf.move_down 20
    pdf.text 'აბონენტების მიხედვით დაზუსტებული მისამართები მოთხოვნილი ძაბვის საფეხური და მოთხოვნილი სიმძლავრეები -- შევსებული დანართი 1.1 მიხედვით; ☐'
  end

  def self.render_part5(app, pdf)
    pdf.move_down 40
    pdf.change_font(:default, DEF_FONT_SIZE + 2)
    pdf.text "V. განაცხადის პირობები"
    pdf.change_font(:default, DEF_FONT_SIZE)
    pdf.move_down 20
    pdf.text %Q{ამ განაცხადის ხელმოწერით ვადასტურებ, რომ განაწილების ლიცენზიანტის მიერ ამ განაცხადის მიღებისა და მასში ასახული პირობების შესრულების შემთხვევაში, შევასრულებ საქართველოს  ენერგეტიკისა და წყალმომარაგების მარეგულირებელი კომისიის მიერ დამტკიცებული  "ელექტროენერგიის (სიმძლავრის) მიწოდებისა და მოხმარების წესებით" განსაზღვრულ  ვალდებულებებს, მათ შორის დროულად გადავიხდი გამანაწილებელ ქსელზე ახალი მომხმარებლის მიერთების დადგენილ საფასურს.}

    pdf.move_down 100
    pdf.text 'განმცხადებლის ხელმოწერა   ____________________________'
  end
  
  def self.personal_use(pers)
    if pers.nil?
      '☐ საყოფაცხოვრებო; ☐ არასაყოფაცხოვრებო'
    else
      pers ? '☑ საყოფაცხოვრებო; ☐ არასაყოფაცხოვრებო' : '☐ საყოფაცხოვრებო; ☑ არასაყოფაცხოვრებო'
    end
  end

  def self.tariff_voltafe(it)
    v220 = it ? it.tariff.voltage == '0.220' : false
    v380 = it ? it.tariff.voltage == '0.380' : false
    v610 = it ? it.tariff.voltage == '6/10'  : false
    "#{v220 ? '☑' : '☐'} 220ვ; #{v380 ? '☑' : '☐'} 380ვ; #{v610 ? '☑' : '☐'} 6/10კვ;"
  end
  
end
