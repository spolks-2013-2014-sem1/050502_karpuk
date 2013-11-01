require "optparse"

module Utils

  class OptionsParser

    def initialize
      @options = {}

      begin
        OptionParser.new do |opts|
          opts.banner = 'Usage: main.rb [options]'

          opts.separator ""
          opts.separator "Specific options:"

          opts.on( "-l PORT", "--listen", String, "listen PORT" ) do |port|
            @options[:listen] = true
            @options[:host] = '0.0.0.0'
            @options[:port] = port
          end

          opts.on("-c PORT", "--connect", "connect to PORT") do |port|
            @options[:listen] = false
            @options[:host] = '0.0.0.0'
            @options[:port] = port
          end

          opts.on( "-n HOST", "--hostname", String, "set hostname") do |host|
            @options[:host] = host
          end

          opts.on( "-f FILE", "--file", String, "use FILE as send data") do |file|
            @options[:file] = file
          end

          opts.separator ""
          
          opts.on_tail('-v', '--version') { puts "version 1.0"; exit }

          opts.on_tail('-h', '--help') { puts opts; exit }
          @opts = opts
        end.parse!
      rescue OptionParser::MissingArgument => e
        puts @opts
        exit 1
      rescue Exception => e
        puts "#{e}"
        puts @opts
        exit 1
      end

      if options.empty? then
        puts @opts
        exit 1
      end
    end

    attr_accessor :options

    def help
      puts @opts
    end

  end
end




