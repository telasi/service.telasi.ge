# -*- encoding : utf-8 -*-

require 'spec_helper'

def correct_mobile(mob)
  context mob do
    subject { User.correct_mobile? mob }
    it('უნდა იყოს სწორი') { should == true }
  end
end

def incorrect_mobile(mob)
  context mob do
    subject { User.correct_mobile? mob }
    it('არაა სწორი') { should == false }
  end
end

describe 'მობილურის ფორმატის შემოწმება' do
  correct_mobile '595335514'
  correct_mobile '599422451'
  incorrect_mobile '59533551'
  incorrect_mobile '(595)335-514'
end