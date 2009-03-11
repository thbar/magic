class Array
  def add(item)
    push(item)
  end
end

class MockSilverlightContainer
  def children
    @children ||= []
  end
end

module System
  module Windows
    class UIElement
    end
  end
end

class MockWindow
  attr_accessor :content
end

class MockControl < System::Windows::UIElement
end
  
