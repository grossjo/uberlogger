require 'minitest/autorun'
require 'uberlogger'
require 'stringio'

class TestUberLogger < MiniTest::Unit::TestCase
  def setup
    @logger = UberLogger['simple', pattern: '%l %m']
    outputters.clear
  end

  def teardown
    Dir["minitest*.log"].each { |f| FileUtils.rm f }
  end

  def silence
    verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = verbose
  end

  def infect_outputters
    outputters.map { |o|
      class << o
        attr_accessor :out
      end

      yield o if block_given?
    }
  end

  def outputters
    @logger.instance_variable_get(:@log).outputters
  end

  def test_construction
    assert_equal 'simple', @logger.name
    assert_equal '%l %m', @logger.format.pattern
  end

  def test_add_console_stdout
    @logger.add_console
    infect_outputters { |o| o.out = StringIO.new }
    @logger.info "message"
    outputters.each { |o| assert_equal "INFO message\n", o.out.string }
  end

  def test_add_console_stderr
    @logger.add_console(stderr: true)
    infect_outputters { |o| o.out = StringIO.new }
    @logger.info "message"
    outputters.each { |o| assert_equal "INFO message\n", o.out.string }
  end

  def test_add_file
    @logger.add_file('minitest.log')
    assert_instance_of Log4r::RollingFileOutputter, outputters.first
    assert_match %r{minitest\d+.log}, outputters.first.filename
  end
end
