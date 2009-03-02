require File.dirname(__FILE__) + "/spec_helper"

describe "Instanciator.build_instance_with_properties" do
  extend Instanciator
  
  def instance_from(klass,options={})
    build_instance_with_properties(klass,options)
  end

  it "creates an instance of the given class" do
    instance_from(Control).should be_kind_of(Control)
  end
  
  it "set the passed propertie value on the instance" do
    instance_from(Label, :text => "Hello").text.to_s.should == "Hello"
  end
  
  it "forwards the firsts arguments to the constructor if it's not a Hash" do
    # sugar for MenuItem
    instance_from(MenuItem, "Hello").text.to_s.should == "Hello"
  end
  
  it "defines a block if the passed property is a Proc" do
    @called = false
    handler = lambda { @called = true }
    
    # TODO - instead of triggering a click, just find a way to ensure the lambda is registered
    instance_from(Button, :click => handler).perform_click
    
    @called.should == true
  end

  it "understand symbol for value if the property is an enum" do
    instance_from(FlowLayoutPanel, :dock => :fill).dock.should == DockStyle.fill
  end

end