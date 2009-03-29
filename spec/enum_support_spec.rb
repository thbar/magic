require File.dirname(__FILE__) + "/spec_helper"

describe EnumSupport do
  extend EnumSupport
  
  it "converts a CLR enum value to the corresponding int value" do
    enum_to_int(AnchorStyles.Bottom).should == 2
  end

  it "converts an int to the corresponding CLR enum value" do
    int_to_enum(AnchorStyles.to_clr_type, 2).should == AnchorStyles.Bottom
  end
  
  it "supports roundtrip with combined flagged enum" do
    int_to_enum(AnchorStyles.to_clr_type, 
      enum_to_int(AnchorStyles.Bottom) | enum_to_int(AnchorStyles.Top)
    ).to_string.to_s.should == "Top, Bottom"
    # note: to_string is overloaded on flagged enums. then we need some conversion to get a ruby string
  end
  
end