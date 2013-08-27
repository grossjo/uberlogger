# -*- ruby encoding: utf-8 -*-

verbose, $VERBOSE = $VERBOSE, nil
require "log4r"
require "log4r/outputter/syslogoutputter"
$VERBOSE = verbose

# This is a super logger, literally an uber-logger. The goal is to provide a
# python-like logging facility, with relatively simple to use logging
# functionality that supports multiple logging mechanisms.
#
#     x = UberLogger['logger-name']
class UberLogger
  VERSION = '0.6.3'
  DEFAULT_PATTERN = "%d - [%l] [%c]: %m"

  class << self
    # Looks up a logger by name and returns it. If a logger does not exist
    # for that name, creates a new logger for that name and returns it.
    def [](name, options = { parent: nil, pattern: nil })
      options = { parent: options } if options.kind_of? String

      name = "#{options[:parent]}::#{name}" if options[:parent]
      loggers[name] ||= UberLogger.new(name, options[:pattern])
    end

    # Make UberLogger.instance a pass-through method to match the older API
    # based around Singleton.
    def instance
      self
    end

    # Make UberLogger.getLogger call the new API. This allows older code to
    # work.
    #
    #     UberLogger.instance.getLogger(name) # old style
    #     UberLogger[name] # new style
    def getLogger(name, options = { parent: nil, pattern: nil })
      self[name, options]
    end

    def loggers
      @loggers ||= {}
    end
    private :loggers
  end

  attr_reader :name, :format, :logger

  include Log4r

  DEFAULT_MAX_LOG_SIZE = 1024 ** 3 # 1 MB logs as the default size

  # Log4r is stupidly noisy with warnings. Shut it up. This will affect
  # other threads for a very short time.
  def silence
    verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = verbose
  end
  private :silence

  def initialize(name, pattern = nil)
    @name = name

    @log = silence { Log4r::Logger.new(name) }

    # Chayim likes his logs formatted a very specific way. If you don't
    # deal.
    @format = PatternFormatter.new(pattern: pattern || DEFAULT_PATTERN)
  end

  # Resolves the log level from a text name matching the 7 syslog
  # facilities.
  def resolve_level(name)
    case name.to_s
    when /debug/
      Log4r::DEBUG
    when /info/
      Log4r::INFO
    when /fatal/
      return Log4r::FATAL
    when /warn/
      Log4r::WARN
    when /error/
      Log4r::ERROR
    when /emerg/, /alert/, /crit/
      Log4r::FATAL
    else
      raise ArgumentError, "Invalid log level specified."
    end
  end
  private :resolve_level

  # Adding a file-based logger with rotation.
  def add_file(filename, options = { level: nil,
               max_log_size: DEFAULT_MAX_LOG_SIZE, rolling_seconds: nil,
               count: 10 })
    logger = if options[:rolling_seconds]
               options[:count] ||= 10
               config = {
                 filename: filename,
                 maxtime: options[:rolling_seconds],
                 count: options[:count]
               }
               silence { Log4r::RollingFileOutputter.new(@name, config) }
             elsif options[:max_log_size]
               config = {
                 filename: filename,
                 maxsize: options[:max_log_size]
               }
               silence { Log4r::RollingFileOutputter.new(@name, config) }
             end

    return unless logger
    logger.formatter = @format
    logger.level = resolve_level(options[:level]) if options[:level]
    @log.add(logger)
  end

  # Adding a syslog-based logger.
  def add_syslog(options = { level: nil })
    syslogger = silence { Log4r::SyslogOutputter.new(@name) }
    syslogger.formatter = @format
    syslogger.level = resolve_level(options[:level]) if options[:level]
    @log.add(syslogger)

    @syslog = true
  end

  # Add the ability to log to the console, to our logger
  def add_console(options = { level: nil, stdout: true, stderr: false })
    level = resolve_level(options[:level]) if options[:level]

    if options[:stdout]
      conlogger = silence { Log4r::StdoutOutputter.new(@name) }
      conlogger.formatter = @format
      conlogger.level = level if level
      @log.add(conlogger)
    end

    if options[:stderr]
      errlogger = silence { Log4r::StderrOutputter.new(@name) }
      errlogger.formatter = @format
      errlogger.level = level if level
      @log.add(errlogger)
    end
  end

  # Log the message at the debug level
  def debug(msg)
    @log.debug(msg)
  end

  # Log the message at the info level
  def info(msg)
    @log.info(msg)
  end

  # Log the message at the warning level
  def warn(msg)
    @log.warn(msg)
  end

  # Log the message at the error level
  def error(msg)
    @log.error(msg)
  end

  # Log the message at the fatal level
  def fatal(msg)
    @log.fatal(msg)
  end

  # Make a two parameter form of logging easy to use.
  def log(severity, msg)
    case severity
    when :fatal, :error, :warn, :info, :debug
      @log.__send__(severity.to_sym, msg)
    else
      @log.debug("#{severity.to_s.upcase}: #{msg}")
    end
  end

  # The string representation is just the logger name
  def to_s
    @name
  end
end
