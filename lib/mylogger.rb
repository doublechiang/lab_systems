require 'logger'

# our own module logger
module Mylogger
    def logger
        if @logger.nil?
            @logger ||= Logger.new(STDOUT)
            @logger.level = Logger::INFO
        end
        @logger
    end
end