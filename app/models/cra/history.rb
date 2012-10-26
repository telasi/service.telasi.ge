# -*- encoding : utf-8 -*-
class Cra::History
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  field :action,   type: String
  field :request,  type: String
  field :response, type: String

  def object
    @object || (@object = eval(self.response))
  end

  def is_person?
    obj = self.object
    
  end

  def self.make_log(user)
    action = CRA.serv.last_action.to_s
    request = CRA.serv.last_request.to_s
    response = CRA.serv.last_response.to_s
    Cra::History.new(user: user, action: action, request: request, response: response).save
  end
end
