# -*- encoding : utf-8 -*-
require 'c12-commons'

module Telasi
  def self.print_application(app, file)
    C12::PDF::Document.generate file, :page_size => 'A4', :margin => [30, 40] do |pdf|
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
  end

  def self.render_header(app, pdf)
    pdf.move_down 100
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
    pdf.change_font(:serif, DEF_FONT_SIZE + 2)
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

end
