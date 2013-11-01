require 'socket'

module Transmitter
  module_function

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
