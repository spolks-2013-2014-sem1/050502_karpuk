#!/home/nikita/.rvm/bin/ruby -w
require "socket"
require '../../spolks_lib/utils'
include Socket::Constants

# Parse Command line arguments
parser = Utils::OptionsParser.new()
options = parser.options

port = options[:port]
host = '0.0.0.0'

socket = Socket.new(AF_INET, SOCK_STREAM, 0)
socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, true)

sockaddr = Socket.sockaddr_in(port, host)
socket.bind(sockaddr)
socket.listen(5)

client = nil
begin
  loop do
    client, addrinfo = socket.accept
    puts "Connected client: #{addrinfo.inspect}"

    #send to client information about him
    client.puts "Server identify your information:"
    client.puts "  Address : #{addrinfo.ip_address}"
    client.puts "  Port    : #{addrinfo.ip_port}"

    client.close
    client =nil
  end
rescue Interrupt
  puts " Exit"
ensure
  socket.close
  client.close unless client.nil?
end
