require File.dirname(__FILE__) + "/spec_helper"

describe Magic do
  # todo - write custom matcher to dry things up a bit
  
  it "builds form with properties" do
    form = Magic.build do
      form(:text => "Hello world", :dock => :fill)
    end
    
    form.should be_kind_of Form
    form.text.to_s.should == "Hello world"
    form.dock.should == DockStyle.Fill
  end
  
  it "understands basic property setting inside the block" do
    form = Magic.build do
      form { text "Hello world" }
    end

    form.should be_kind_of Form
    form.text.to_s.should == "Hello world"
  end
  
  it "understands enum property as symbol setting inside the block" do
    form = Magic.build do
      form { dock :fill }
    end

    form.should be_kind_of Form
    form.dock.should == DockStyle.Fill
  end
  
  it "passes the parent as a block param" do
    expected_form = nil
    Magic.build do
      form do |f|
        expected_form = f
      end
    end.should == expected_form
  end
  
  it "allows nesting of controls" do
    form = Magic.build do
      form(:text => "Hello world") do
        button(:text => "First")
        button(:text => "Second")
      end
    end
    
    form.controls.size.should == 2
    
    form.controls[0].should be_kind_of Button
    form.controls[0].text.to_s.should == "First"

    form.controls[1].should be_kind_of Button
    form.controls[1].text.to_s.should == "Second"
  end
  
  it "supports using variables for later reference" do
    Magic.build do
      @my_button = button(:text => "First text")
      @my_button.text = "Overriden text"
      @my_button
    end.text.to_s.should == "Overriden text"
  end
  
  it "allows non-control (ex: background_worker) instances" do
    Magic.build do
      form do
        @worker = background_worker
        button = button(:text => "Start")
      end
      @worker
    end.should be_kind_of BackgroundWorker
  end
  
  it "supports main_menu and menu_item" do
    form = Magic.build do
      @main_menu = main_menu do
        menu_item("&File") do
          menu_item("&New")
          menu_item("&Quit").click { Application.Exit }
          menu_item("&Other Quit", :click => lambda { Application.Exit })
        end
      end

      form(:menu => @main_menu) # note - you can inline menu declaration if you want
    end
    
    form.menu.should be_kind_of MainMenu
    form.menu.menu_items.first.should be_kind_of MenuItem
    form.menu.menu_items.first.text.to_s.should == "&File"
    form.menu.menu_items.first.menu_items.map { |c| c.text.to_s }.should == ["&New","&Quit","&Other Quit"]
  end
  
  # todo - find a cleaner way to mock out stuff (or not mock any)
  
  it "supports nested WPF UIElement" do
    container = Magic.build do
      @container = mock_silverlight_container do
        mock_control
      end
    end
    
    container.should be_kind_of MockSilverlightContainer
    container.children.first.should be_kind_of MockControl
  end
  
  it "supports WPF content" do
    window = Magic.build do
      mock_window do
        mock_control
      end
    end

    window.should be_kind_of MockWindow
    window.content.should be_kind_of MockControl
  end
  
end