require 'socket'
require '../../spolks_lib/utils'
require '../../spolks_lib/network'
require_relative 'transmitter'

# Parse Command line arguments
parser = Utils::OptionsParser.new
options = parser.options

port = options[:port]
host = options[:host]
file_name = options[:file]

begin

  if options[:listen] # if Server
  	if(options[:udp]) 
    	Transmitter::start_udp_server(port, host, file_name)
    else
    	Transmitter::start_tcp_server(port, host, file_name)
    end
  else               # if Client
  	if(options[:udp])
    	Transmitter::start_udp_client(port, host, file_name)
    else
    	Transmitter::start_tcp_client(port, host, file_name)
    end
  end

rescue Interrupt => e
  puts " Exit"
rescue Errno::EPIPE => e
  puts "!! Client was disconnect, file didn't send fully !!!"
rescue Errno::ECONNREFUSED => e
  puts "socket is disable =("
rescue Errno::ENOENT => e
  puts "No such file or directory"
end