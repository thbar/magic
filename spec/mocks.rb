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

class UIElement
end

class MockControl < UIElement
end
  
