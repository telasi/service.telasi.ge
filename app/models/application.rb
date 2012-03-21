# -*- encoding : utf-8 -*-

# ეს არის აბონენტის განაცხადის კლასი.
class Application
  include Mongoid::Document
  include Mongoid::Timestamps

  # ეს არის "გამანაწილებელ ქსელზე ახალი მომხმარებლის მიერთების"
  # განაცხადის ტიპის აღმნიშვნელი კონსტანტა.
  TYPE_CONNECT = 1

  # განაცხადის საწყისი სტატუსი.
  STATUS_START = 0

  # გაგზავნილი განაცხადის სტატუსი.
  STATUS_SENT = 1

  # ეს არის განაცხადის მოთხოვნის მიღების სტატუსი.
  STATUS_CANCELED = 2

  # ეს არის განაცხადის გაუქმების სტატუსი.
  STATUS_ACCEPTED = 3

  # ეს არის სტატუსი, რომელიც აღნიშნავს,
  # რომ განაცხადი დასრულებულია.
  STATUS_CLOSED = 4

  # განცხადების ტიპი
  field :type, type: Integer

  # განცხადების სტატუსი
  field :status, type: Integer

  # მისამართი (რომელსაც უკავშირდება ეს განაცხადი).
  #
  # მაგალითად, მიერთების განაცხადის შევსებისას ეს არის
  # მისაერთებელი ობიექტის მისამართი. 
  field :address, type: String
  # მისამართის შესაბამისი საკადასტრო კოდი.
  field :address_code, type: String

  # უნდა თუ არა მომხმარებელს პასუხის მიღება წერილობითი სახით.
  field :written_response, type: Boolean

  # უნდა თუ არა მომხმარებელს პასუხის მიღება ელ.ფოსტის მეშვეობით.
  field :email_response, type: Boolean

  # გაგზავნის თარიღი.
  field :send_date, type: Time

  # პასუხის გაცემის თარიღი.
  field :response_date, type: Time

  # დახურვის თარიღი.
  field :close_date, type: Time

  belongs_to :owner, class_name: 'User'

  # ინფორმაცია განმცხადებლის შესახებ.
  embeds_one :applicant

  # ინფორმაცია განმცხადებლის საბანკო ანგარიშის შესახებ.
  #
  # შეიძლება დაგებადოთ კითხვა: თუ რა საჭიროა განმცხადებლის საბანკო
  # ანგარიშის ცოდნა? თუ ჩვენ დაგვჭირდა თანხის დაბრუნება, ამ შემთხვევისთვის
  # გვჭირდება ეს ანგარიში! სწორედ მასზე მოხდება თანხის დაბრუნება.
  embeds_one :bank_account
end

# ინფორმაცია განმცხადებლის შესახებ.
class Applicant
  include Mongoid::Document
  # საიდენტიფიკაციო კოდი
  field :tin, type: String
  # სახელი/დასახელება
  field :name, type: String
  # იურიდიული მისამართი
  field :address, type: String
  # მობილურის ნომერი
  field :mobile, type: String
  # ელ.ფოსტის მისამართი
  field :email, type: String
  # განცხადება, რომელსაც მიეკუთვნება ეს განმცხადებელი.
  embedded_in :application
end

# ინფორმაცია განმცხადებლის საბანკო მონაცემების შესახებ.
class BankAccount
  include Mongoid::Document
  # ბანკის SWIFT კოდი
  field :swift, type: String
  # ბანკის დასახელება
  field :bank, type: String
  # საბანკო ანგარიშის EBAN კოდი.
  field :eban, type: String
  # განცხადება, რომელზეც მობმულია ეს ანგარიში.
  embedded_in :application
end

# ეს არის 2012 წლის ტარიფი ახალი აბონენტის მიერთებაზე.
class Tariff2012
  # ეს მასივი გამოიყენება ტარიფების შესანახად.
  ALL = []

  attr_accessor :id, :voltage, :power, :complete, :price

  # ყველა ტარიფის მიღება
  def self.all
    if ALL.empty?
      tariff_yml = YAML.load_file(File.join(Rails.root, 'config/tariff_2012.yml'))
      tariff_yml.each do |t|
        tariff = Tariff2012.new
        tariff.id = t[0]
        tariff.voltage = t[1]['voltage']
        tariff.power = t[1]['power']
        tariff.complete = t[1]['complete']
        tariff.price = t[1]['price']
        ALL << tariff
      end
    end
    ALL
  end
end
