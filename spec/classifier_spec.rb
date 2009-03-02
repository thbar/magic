require File.dirname(__FILE__) + "/spec_helper"

describe "Classifier.classify" do
  extend Classifier

  it "converts 'button' to 'Button'" do
    classify("button").should == "Button"
  end
  
  it "converts 'flow_layout_panel' to 'FlowLayoutPanel'" do
    classify("flow_layout_panel").should == "FlowLayoutPanel"
  end

end