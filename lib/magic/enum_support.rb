# temporary code to support flagged enums (AnchorStyles.Bottom | AnchorStyles.Top)
# this code will be removed when | is implemented on enums in IronRuby
module EnumSupport
  def enum_to_int(enval)
    entype = enval.GetType()
    undertype = Enum.GetUnderlyingType(entype)
    Convert.ChangeType(enval, undertype)
  end
  
  def int_to_enum(entype, value)
    Enum.ToObject(entype, value)
  end
end