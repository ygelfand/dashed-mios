module MiOS
  module Services
    module AlarmPartition2

      URN = 'urn:micasaverde-com:serviceId:AlarmPartition2'

      def arm!(mode="Armed", async=false, quick: false, pin: nil , &block)
        set(URN, quick ? 'RequestQuickArmMode' : 'RequestArmMode', {'State' => mode, 'PINCode' => pin }, async, &block)
      end

      def disarm!(pin, async=false, &block)
        arm!('Disarmed', async, pin: pin, &block)
      end
    
      def panic!(mode='Fire', async=false, &block)
        set(URN, 'RequestPanicMode', {'State' => mode}, async, &block)
      end

      def current_mode
        value_for(URN, 'ArmMode', as: String)
      end

      def armed?
        current_mode == 'Armed'
      end

      def disarmed?
        !armed?
      end

    end
  end
end
