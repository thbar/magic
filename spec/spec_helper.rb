$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
$LOAD_PATH << File.dirname(__FILE__) + "/mspec/lib" 
$LOAD_PATH << File.dirname(__FILE__)

require 'mspec'

require 'mscorlib'
require "System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
require 'System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'

require 'mocks'
require 'magic'

include System
include System::Windows::Forms
include System::ComponentModel # for background_worker

