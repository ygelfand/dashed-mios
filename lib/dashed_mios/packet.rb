module DashedMios
  class Packet
    attr_reader :raw_packet, :raw_data
    def initialize(raw_packet)
      @raw_packet = raw_packet
      @raw_data = @raw_packet.raw_data
    end
    def valid?
    end
    def type
      case raw_data[21]
      when "\x01"
        'Request'
      when "\x02"
        'Reply'
      end
    end
    def src_mac_address
      hex_array(6,6).join('')
    end
    def ip_src
      dec_array(28,4).join '.'
    end
    def dst_mac_address
      hex_array(0,6).join('')
    end
    def ip_dst
      dec_array(38,4).join '.'
    end
    private
    def hex_array(offset,length)
      raw_data[offset,length].unpack('H2'*length)
    end
    def dec_array(offset,length)
      raw_data[offset,length].unpack('C'*length)
    end
  end
end
