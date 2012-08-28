require 'spec_helper'

describe Message do
  subject do
    Message.new(
        {
            date: "2012-08-03T13:11:50+09:00",
            from: "Takashi Kawachi",
            message: "hello!"
        }.stringify_keys
    )
  end
  its(:start?) { should be_false }
  its(:end?) { should be_false }
  its(:to_s) { should_not be_blank }
  it { subject.for_date?(Date.new(2012, 8, 2)).should be_false }
  it { subject.for_date?(Date.new(2012, 8, 3)).should be_true }
  it { subject.for_date?(Date.new(2012, 8, 4)).should be_false }

end