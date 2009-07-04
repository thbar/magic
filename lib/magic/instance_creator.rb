require 'magic/classifier'
require 'magic/enum_support'

# internal sugar to instanciate a given CLR type - apart from enum handling, the code is not CLR specific
module InstanceCreator
  include Classifier
  include EnumSupport
  
  # if klass.property_name is a CLR enum, parse the value to translate it into the CLR enum value
  def parse_enum_if_enum(klass,property_name,value)
    is_dotnet_enum = klass.respond_to?(:to_clr_type) && (type = klass.to_clr_type.get_property(classify(property_name.to_s)).property_type) && (type.is_enum)
    if is_dotnet_enum
      if value.is_a?(Array)
        int_values = value.map { |e| enum_to_int(parse_enum(type,e)) }
        or_combination = int_values.inject { |result,e| result | e }
        int_to_enum(type, or_combination)
      elsif value.is_a?(Symbol)
        parse_enum(type,value)
      else
        value
      end
    else
      value
    end
  end
    
  def parse_enum(type,value)
    Enum.parse(type, classify(value.to_s))
  end
  
  # return the method name to call to set the property, if there is one. Can be either:
  # - a .Net property setter
  # - or a Java setProperty(x) setter
  def setter?(instance, property_name)
    # detect set_x first for java - the second one seems to be detected but fails to work, for some reason
    ["set_#{property_name}", "#{property_name}="].find { |m| instance.respond_to?(m) }
  end
  
  # instanciate the given class and set the properties passed as options
  # support both values and procs for options
  def build_instance_with_properties(klass,*args)
    properties = args.last.is_a?(Hash) ? args.delete_at(args.size-1) : {}
    instance = klass.new(*args)
    properties.keys.inject(instance) { |instance,k| set_property(instance, k, properties[k]) }
  end
  
  # sugarized property setter - allows symbols for enums
  def set_property(instance, k, v)
    setter = setter?(instance, k)
    v.is_a?(Proc) ? instance.send(k,&v) : instance.send(setter, *parse_enum_if_enum(instance.class,k,v))
    instance
  end

end
