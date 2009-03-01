require File.dirname(__FILE__) + '/../spec_helper'
require 'mspec/helpers/argv'

describe Object, "#argv" do
  before :each do
    ScratchPad.clear

    @saved_argv = ARGV
    @argv = ["a", "b"]
  end

  it "replaces and restores the value of ARGV" do
    argv @argv
    ARGV.should == @argv
    argv :restore
    ARGV.should == @saved_argv
  end

  it "yields to the block after setting ARGV" do
    argv @argv do
      ScratchPad.record ARGV
    end
    ScratchPad.recorded.should == @argv
    ARGV.should == @saved_argv
  end
end
