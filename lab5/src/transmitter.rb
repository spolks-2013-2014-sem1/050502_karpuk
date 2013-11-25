require 'socket'
require '../../spolks_lib/network'

module Transmitter
  module_function

  # Send file
  def start_udp_client(port, host, file_name)
    puts "UDP CLIENT"
    file = File.open(file_name, 'r')
    client = Network::ClientUDP.new(port, host)
    client.connect(Socket.sockaddr_in(port, host))

    loop do
      _, writer = IO.select(nil,[client], nil, 10)
      break unless writer
      if io = writer[0]
        package = file.read(1024)
        if (package.nil? || package.empty?)
          io.send(Network::FIN, 0) #signal, that file was sent
          break
        end
        io.send(package, 0)
      end
    end

    file.close if file
    client.close if client
  end


  # Recive file
  def start_udp_server(port, host, file_name)
    puts "UDP SERVER"
    file = File.open(file_name, 'w+')
    server = Network::ServerUDP.new(port, host)

    loop do
      reader, _ = IO.select([server], nil, nil, 10)
      break unless reader
      if io = reader[0]
        package = io.recv(1024)
        if (package.nil? || package.empty? || package == Network::FIN)
          break
        end
        file.write(package)
      end
    end

    file.close if file
    server.close if server
  end

  # Send file
  def start_tcp_client(port, host, file_name)

    file = File.open(file_name, 'rb')
    client = Network::ClientTCP.new(port, host)

    send(file, client)

    file.close unless file.nil? || file.closed?
    client.close unless client.nil? || client.closed?

  end

  # Recive file
  def start_tcp_server(port, host, file_name)

    file = File.open(file_name, "wb")
    server = Network::ServerTCP.new(port, host)
    client, = server.accept

    recive(file, client)

    file.close unless file.nil? || file.closed?
    client.close unless client.nil? || client.closed?
    server.close unless server.nil? || server.closed?

  end


  def recive(file, socket)
    loop do
      reader, _ = IO.select([socket], nil, nil, 10)
      break unless reader
      if io = reader[0]
        package = io.recv(1024)
        break if (package.nil? || package.empty?)
        file.write(package)
      end
    end
  end

  def send(file, socket)
    loop do
      _, writer = IO.select(nil,[socket], nil, 10)
      break unless writer
      if io = writer[0]
        package = file.read(1024)
        break if (package.nil? || package.empty?)
        io.send(package, 0)
      end
    end
  end
  
end
