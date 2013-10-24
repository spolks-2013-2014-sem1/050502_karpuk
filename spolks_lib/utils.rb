require "optparse"

module Utils

  class OptionsParser

    def initialize
      @options = {}

      begin
        OptionParser.new do |opts|
          opts.banner = 'Usage: main.rb [options]'

          opts.on( "-l PORT", "--listen", String, "listen port" ) do |port|
            @options[:port] = port
            @options[:listen] = true
          end
          
          opts.on('-h', '--help') { puts opts; exit }
          @opts = opts
        end.parse!
      rescue OptionParser::MissingArgument
        puts @opts
        exit
      end

      if options.empty? then
        puts @opts
        exit
      end
    end

    attr_accessor :options

  end

end




