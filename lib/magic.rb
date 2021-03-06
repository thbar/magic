require File.dirname(__FILE__) + "/magic/instance_creator"
require File.dirname(__FILE__) + "/magic/classifier"

# DSL-like object creation. Not that much .Net related, except for the Control/MenuItem specifics
# which could be extracted and made configurable. This is likely to happen.
class Magic
  include InstanceCreator
  include Classifier

  class << self
    def build(&description)
      self.new.instance_eval(&description)
    end
  end

  def method_missing(method,*args)
    # push stuff recursively on a stack so that we can add the item to its parents children collection
    @stack ||= []
    parent = @stack.last

    if setter?(parent, method)
      set_property(parent, method, args)
    else
      clazz = Object.const_get(classify(method.to_s))
      instance = build_instance_with_properties(clazz, *args)
      # add to the parent control only if it's a well known kind
      # todo - extract configurable mappings ?
      if parent
        # serve ourselves, first
        parent.send(method,args) if parent.respond_to?(method)
        # Windows Forms Control and MenuItem support
        parent.controls.add(instance) if (defined?(System::Windows::Forms::Control) && instance.is_a?(System::Windows::Forms::Control))
        parent.menu_items.add(instance) if (defined?(System::Windows::Forms::MenuItem) && instance.is_a?(System::Windows::Forms::MenuItem))
        # Silverlight/WPF support
        if defined?(System::Windows::UIElement)
          if instance.is_a?(System::Windows::UIElement)
            if parent.respond_to?(:content)
              parent.content = instance
            else
              parent.children.add(instance)
            end
          end
        end
        # Swing support
        parent.add(instance) if (defined?(Java::JavaAwt::Component) && instance.is_a?(Java::JavaAwt::Component))
      end
      @stack.push(instance)
      yield instance if block_given?
      @stack.pop
    end
  end
end
