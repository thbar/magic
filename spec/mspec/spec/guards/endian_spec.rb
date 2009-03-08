require File.dirname(__FILE__) + '/../spec_helper'
require 'mspec/guards/endian'

describe Object, "#big_endian" do
  before :each do
    @guard = BigEndianGuard.new
    BigEndianGuard.stub!(:new).and_return(@guard)
    ScratchPad.clear
  end

  it "yields on big-endian platforms" do
    @guard.stub!(:pattern).and_return([1])
    big_endian { ScratchPad.record :yield }
    ScratchPad.recorded.should == :yield
  end

  it "does not yield on little-endian platforms" do
    @guard.stub!(:pattern).and_return([0])
    big_endian { ScratchPad.record :yield }
    ScratchPad.recorded.should_not == :yield
  end

  it "sets the name of the guard to :big_endian" do
    big_endian { }
    @guard.name.should == :big_endian
  end

  it "calls #unregister even when an exception is raised in the guard block" do
    @guard.stub!(:pattern).and_return([1])
    @guard.should_receive(:unregister)
    lambda do
      big_endian { raise Exception }
    end.should raise_error(Exception)
  end
end

describe Object, "#little_endian" do
  before :each do
    @guard = LittleEndianGuard.new
    LittleEndianGuard.stub!(:new).and_return(@guard)
    ScratchPad.clear
  end

  it "yields on little-endian platforms" do
    @guard.stub!(:pattern).and_return([0])
    little_endian { ScratchPad.record :yield }
    ScratchPad.recorded.should == :yield
  end

  it "does not yield on big-endian platforms" do
    @guard.stub!(:pattern).and_return([1])
    little_endian { ScratchPad.record :yield }
    ScratchPad.recorded.should_not == :yield
  end

  it "sets the name of the guard to :little_endian" do
    little_endian { }
    @guard.name.should == :little_endian
  end

  it "calls #unregister even when an exception is raised in the guard block" do
    @guard.stub!(:pattern).and_return([0])
    @guard.should_receive(:unregister)
    lambda do
      little_endian { raise Exception }
    end.should raise_error(Exception)
  end
end
