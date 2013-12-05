require 'socket'

module Transmitter
  module_function

  def recive(file, socket)
    pack_counter = 0
    oob_counter = 0
    data_counter = 0

    loop do
      reader, _, urgent = IO.select([socket], nil, [socket], 10)
      break unless reader or urgent

      if(io = urgent[0])
        io.recv(1, IO::MSG_OOB)
        oob_counter += 1
        puts "data: #{data_counter}"
      end

      if io = reader[0]
        package = io.recv(2048)
        break if (package.nil? || package.empty?)
        file.write(package)
        data_counter += package.length
        pack_counter += 1
      end
    end
    puts "was recived #{data_counter} data"
    puts "was recived #{oob_counter} oob"
  end


  def send(file, socket)
    pack_counter = 0
    oob_counter = 0
    data_counter = 0

    loop do
      _, writer = IO.select(nil,[socket], nil, 10)
      break unless writer
      
      if io = writer[0]
        package = file.read(2048)
        break if (package.nil? || package.empty?)
        io.send(package, 0)
        data_counter += package.length
        pack_counter += 1

        if(pack_counter % 200 == 0)
          #puts "send: #{data_counter}"
          oob_counter += 1
          io.send('*', IO::MSG_OOB)
          sleep(0.05)
        end
      end
    end

    puts "was send #{data_counter} data"
    puts "was send #{oob_counter} oob"
  end
  
end
