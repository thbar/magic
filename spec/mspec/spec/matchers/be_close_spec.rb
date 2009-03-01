require File.dirname(__FILE__) + '/../spec_helper'
require 'mspec/expectations/expectations'
require 'mspec/matchers/be_close'

# Adapted from RSpec 1.0.8
describe BeCloseMatcher do
  it "matches when actual == expected" do
    BeCloseMatcher.new(5.0, 0.5).matches?(5.0).should == true
  end

  it "matches when actual < (expected + tolerance)" do
    BeCloseMatcher.new(5.0, 0.5).matches?(5.49).should == true
  end

  it "matches when actual > (expected - tolerance)" do
    BeCloseMatcher.new(5.0, 0.5).matches?(4.51).should == true
  end

  it "does not match when actual == (expected + tolerance)" do
    BeCloseMatcher.new(5.0, 0.5).matches?(5.5).should == false
  end

  it "does not match when actual == (expected - tolerance)" do
    BeCloseMatcher.new(5.0, 0.5).matches?(4.5).should == false
  end

  it "does not match when actual < (expected - tolerance)" do
    BeCloseMatcher.new(5.0, 0.5).matches?(4.49).should == false
  end

  it "does not match when actual > (expected + tolerance)" do
    BeCloseMatcher.new(5.0, 0.5).matches?(5.51).should == false
  end

  it "provides a useful failure message" do
    matcher = BeCloseMatcher.new(5.0, 0.5)
    matcher.matches?(5.51)
    matcher.failure_message.should == ["Expected 5.0", "to be within +/- 0.5 of 5.51"]
  end

  it "provides a useful negative failure message" do
    matcher = BeCloseMatcher.new(5.0, 0.5)
    matcher.matches?(5.0)
    matcher.negative_failure_message.should == ["Expected 5.0", "not to be within +/- 0.5 of 5.0"]
  end
end
