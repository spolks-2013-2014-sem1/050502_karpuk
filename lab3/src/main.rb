#!/home/nikita/.rvm/bin/ruby -w
require 'socket'
require '../../spolks_lib/utils'
require '../../spolks_lib/network'

# Parse Command line arguments
parser = Utils::OptionsParser.new
options = parser.options

port = options[:port]
host = options[:host]

server, client, file = nil

begin

  if options[:listen]
    #Server recive file
    file = File.open(options[:file], "w")
    server = Network::ServerTCP.new(port, host)
    puts "Waiting for connection..."
    client, = server.accept
    puts "Reciveing file..."
    loop do
      data = client.recv(1024)
      break if data.empty?
      file.write(data)
    end

  else
    #Client Send file
    file = File.open(options[:file], "r")
    client = Network::ClientTCP.new(port, host)
    loop do
      _, writer = IO.select(nil,[client], nil, 10)
      break unless writer

      data = file.read(1024)
      if server = writer.shift
        break unless data
        len = server.send(data, 0)
      end
    end

  end

rescue Interrupt
  puts " Exit"
rescue Exception => e
  puts "Catch: #{e}"
ensure
  file.close unless file.nil? || file.closed?
  client.close unless file.nil? || client.closed?
  server.close unless file.nil? || server.closed?
end