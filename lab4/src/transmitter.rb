require 'socket'

module Transmitter
  module_function

  def recive(file, socket)
    pack_counter = 0
    oob_counter = 0

    loop do
      reader, _, urgent = IO.select([socket], nil, [socket], 10)
      break unless reader or urgent

      if(io = urgent[0])
        io.recv(1, IO::MSG_OOB)
        oob_counter += 1
        #puts " recive oob #{oob_counter}: #{oob_data}"
      end

      if io = reader[0]
        package = io.recv(1024)
        break if (package.nil? || package.empty?)
        file.write(package)
        pack_counter += 1
      end
    end

    puts "was recived #{oob_counter} oob"
  end


  def send(file, socket)
    pack_counter = 0
    oob_counter = 0

    loop do
      _, writer = IO.select(nil,[socket], nil, 10)
      break unless writer
      
      if io = writer[0]
        package = file.read(1024)
        break if (package.nil? || package.empty?)
        io.send(package, 0)
        pack_counter += 1
        #puts "send packs: #{pack_counter}"

        if(pack_counter % 200 == 0)
          #puts "send oob #{oob_counter}: *"
          oob_counter += 1
          io.send('*', IO::MSG_OOB)
        end
      end
    end

    puts "was send #{oob_counter} oob"
  end
  
end
