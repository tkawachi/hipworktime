require 'spec_helper'

describe WorkTime do
  subject do
    @target_date = Date.new(2012, 8, 1)
    WorkTime.new(@target_date)
  end

  its(:to_s) { should_not be_blank }
  its(:work_times) { should == [] }
end