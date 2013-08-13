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

  def response_text
    resp = eval_result
    if resp.is_a?(Array)
      first = resp.first
      "#{first.first_name} #{first.last_name} -- #{resp.size} დოკუმენტი"
    elsif resp.is_a?(CRA::PassportInfo)
      "#{resp.first_name} #{resp.last_name}"
    elsif not resp.blank?
      resp.to_s[0..100]
    else
      "შედეგის გარეშე"
    end
  end

  private

  def eval_result
    unless @_response_initialized
      begin
        resp = eval(self.response) # rescue self.response.to_s
      rescue Exception => ex
        resp = self.response.to_s
      end
      if resp.is_a?(Hash)
        resp = CRA::PassportInfo.eval_hash(resp) rescue nil
      else
        resp
      end
      @_response_initialized = true
      @_response = resp
    end
    @_response
  end

end
