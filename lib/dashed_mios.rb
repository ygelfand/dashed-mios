Dir[File.dirname(__FILE__) + '/mios/services/*.rb'].each {|file| require file }
require_relative 'dashed_mios/config'
require_relative 'dashed_mios/packet'
require_relative 'dashed_mios/button_press'
require_relative 'dashed_mios/mios'
CONFIG = DashedMios::Config.new
MIOS = DashedMios::Mios.new
