require File.dirname(__FILE__) + "/magic/instanciator"
require File.dirname(__FILE__) + "/magic/classifier"

# DSL-like object creation. Not that much .Net related, except for the Control/MenuItem specifics
# which could be extracted and made configurable. This is likely to happen.
class Magic
  include Instanciator
  include Classifier

  class << self
    def build(&description)
      self.new.instance_eval(&description)
    end
  end

  def method_missing(method,*args)
    # push stuff recursively on a stack so that we can add the item to its parents children collection
    @stack ||= []
    clazz = eval(classify(method.to_s))
    instance = build_instance_with_properties(clazz, *args)
    # add to the parent control only if it's a well known kind
    # todo - extract configurable mappings ?
    if @stack.last
      @stack.last.controls.add(instance) if (defined?(Control) && instance.is_a?(Control))
      @stack.last.menu_items.add(instance) if (defined?(MenuItem) && instance.is_a?(MenuItem))
      @stack.last.children.add(instance) if (defined?(UIElement) && instance.is_a?(UIElement))
    end
    @stack.push(instance)
    yield if block_given?
    @stack.pop
  end
end
