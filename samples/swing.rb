$LOAD_PATH << File.dirname(__FILE__) + "/../../lib"
raise "jruby required" unless defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'

require 'magic'
require 'java'

import 'javax.swing.JFrame'
import 'javax.swing.JButton'

frame = Magic.build do
  JFrame do
    title 'Hello!'
    size 400,500
    JButton('Press me') do |b|
      b.addActionListener do
        b.setText 'Pressed!'
      end
    end
  end
end

frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
frame.show
