require 'magic/classifier'

# internal sugar to instanciate a given CLR type - apart from enum handling, the code is not CLR specific
module Instanciator
  include Classifier

  # if klass.property_name is a CLR enum, parse the value to translate it into the CLR enum value
  def parse_enum_if_enum(klass,property_name,value)
    type = klass.to_clr_type.get_property(classify(property_name.to_s)).property_type
    type.is_enum ? Enum.parse(type, classify(value.to_s)) : value
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
    v.is_a?(Proc) ? instance.send(k,&v) : instance.send("#{k}=", parse_enum_if_enum(instance.class,k,v))
    instance
  end
end
