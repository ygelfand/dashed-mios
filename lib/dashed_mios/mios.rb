require 'mios'
module DashedMios
  class Mios
    attr_accessor :controller
    def initialize
      CONFIG.setup(:settings)
      @controller = ::MiOS::Interface.new(CONFIG.settings[:mios][:url])
    end
    def run(action)
      target = nil
      if action['device_name']
        target = controller.devices.detect{ |dev| dev.name == action['device_name'] }
      end
      target.send(action['perform'].to_sym) if target && action['perform'] 
    end
  end
end
