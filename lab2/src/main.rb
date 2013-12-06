#!/usr/bin/env ruby
require 'socket'
require '../../spolks_lib/utils'
require '../../spolks_lib/network'

# Parse Command line arguments
parser = Utils::OptionsParser.new()
options = parser.options

port = options[:port]
host = options[:host]

socket = Network::ServerTCP.new(port, host)

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
    client = nil
  end
rescue Interrupt
  puts " Exit"
ensure
  socket.close
  client.close unless client.nil?
end
