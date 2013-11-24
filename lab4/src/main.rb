#!/home/nikita/.rvm/bin/ruby -w
require 'socket'
require '../../spolks_lib/utils'
require '../../spolks_lib/network'
require_relative 'transmitter'

# Parse Command line arguments
parser = Utils::OptionsParser.new
options = parser.options

port = options[:port]
host = options[:host]

server, client, file = nil

begin

  if options[:listen] # if Server
    file = File.open(options[:file], "rb")
    server = Network::ServerTCP.new(port, host)
    client, = server.accept
    Transmitter::send(file, client)

  else                # if Client
    client = Network::ClientTCP.new(port, host)
    file = File.open(options[:file], "wb")
    Transmitter::recive(file, client)
  end

rescue Interrupt => e
  puts " Exit"
rescue Errno::EPIPE => e
  puts "!! Client was disconnect, file didn't send fully !!!"
rescue Errno::ECONNREFUSED => e
  puts "Server is disable =("
rescue Errno::ENOENT => e
  puts "No such file or directory"
ensure
  file.close unless file.nil? || file.closed?
  client.close unless client.nil? || client.closed?
  server.close unless server.nil? || server.closed?
end