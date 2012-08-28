require 'spec_helper'

describe TimeRange do
  subject { TimeRange.new(DateTime.new(0, 1, 1), DateTime.new(0, 1, 2)) }
  its(:to_s) { should_not be_blank }
end