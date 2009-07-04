$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
raise "ironruby required" unless defined?(RUBY_ENGINE) && RUBY_ENGINE == 'ironruby'

require 'System.Windows.Forms'
require 'magic'
include System::Windows::Forms

form = Magic.build do
  @menu = main_menu do
    menu_item("&File") do
      menu_item("&New")
      menu_item("&Quit").click { Application.Exit }
      menu_item("&Other Quit", :click => lambda { Application.Exit })
    end
  end
  form(:text => "Title", :menu => @menu) do
    flow_layout_panel(:dock => :fill) do
      button(:text => "Click me!").click do
        MessageBox.Show("Hello from button!")
      end
    end
  end
end

Application.Run(form)
