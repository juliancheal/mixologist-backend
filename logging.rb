require 'logger'

# code based on https://gist.github.com/hyperqube/4041678

module Logging
  def logger
    @logger ||= Logging.logger_for(self.class.name)
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  # Global, memoized, lazy initialized instance of a logger
  class << self
    def logger_for(classname)
      @loggers[classname] ||= configure_logger_for(classname)
    end

    def configure_logger_for(classname)
      logger = Logger.new("./log/mixolator.log")
      logger.level = Logger::INFO
      logger.progname = classname
      logger
    end
  end
end
