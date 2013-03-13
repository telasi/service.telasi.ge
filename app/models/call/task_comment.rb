class Call::TaskComment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  belongs_to :user
  belongs_to :task, class_name: 'Call::Task'

  def text_html
    self.text.gsub("\n", '<br>')
  end

end
