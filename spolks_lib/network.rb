require 'socket'
include Socket::Constants

module Network
  include Socket::Constants
  
  PACK_SIZE = 1024
  TIMEOUT  = 10
  BACK_LOG = 5

  class ServerTCP < Socket
    def initialize(port, host)
      super(AF_INET, SOCK_STREAM, 0)
      setsockopt(SOL_SOCKET, SO_REUSEADDR, true)
      sockaddr = Socket.sockaddr_in(port, host)
      bind(sockaddr)
      listen(BACK_LOG)
    end
  end

  class ClientTCP < Socket
    def initialize(port, host)
      super(AF_INET, SOCK_STREAM, 0)
      setsockopt(SOL_SOCKET, SO_REUSEADDR, true)
      sockaddr = Socket.sockaddr_in(port, host)
      connect(sockaddr)
    end
  end

end