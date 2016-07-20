module DashedMios
  class ButtonPress
    attr_accessor :arp, :https, :button_history
    def initialize(arp:  true, https:  false)
      @arp = arp
      @https = https
      @button_history = {}
    end
    def filter
      _filter=[]
      _filter <<  "arp" if arp
      _filter <<  "(tcp[tcpflags]  & tcp-syn !=0 and (tcp port 443))" if https
      _filter.join(' or ')
    end
    def watch!(&blk)
      interface  = CONFIG.global[:interface] || Pcap.lookupdev
      capture = Pcap::Capture.open_live(interface, 64, true, 0)
      capture.setfilter(filter)
      Process::Sys.setuid(CONFIG.global[:run_as]) if CONFIG.global[:run_as]
      capture.each_packet do |pkt|
        packet = Packet.new(pkt)
        if CONFIG.global[:dash_vendors].include?(packet.src_mac_address[0,6]) || CONFIG.global[:all_mac_addresses]
          button_history[packet.src_mac_address] ||= {}
          if (button_history[packet.src_mac_address][:last]||0) + 5 < packet.raw_packet.time.to_f
            button_history[packet.src_mac_address][:last] = packet.raw_packet.time.to_f
            MIOS.run(CONFIG.settings[:buttons][packet.src_mac_address][:action]) if CONFIG.settings[:buttons][packet.src_mac_address]
           
            puts "Possible Button detected on #{packet.src_mac_address} via #{match_method(packet)}"
          end
        end
        yield packet if block_given?
      end 
    end

    def match_method(packet)
      if packet.raw_packet.tcp?
        "HTTPS"
      elsif packet.type == "Request"
        "ARP"
      end
    end
  end

end
