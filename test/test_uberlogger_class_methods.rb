require 'minitest/autorun'
require 'uberlogger'

class TestUberLoggerClassMethods < MiniTest::Unit::TestCase
  def setup
    UberLogger.__send__(:loggers).clear
  end

  def test_instance_does_nothing
    assert_same UberLogger, UberLogger.instance
  end

  def test_simple_log_acquisition
    l1 = UberLogger['simple']
    assert_instance_of UberLogger, l1
    assert_equal 'simple', l1.name
    assert_equal UberLogger::DEFAULT_PATTERN, l1.format.pattern

    assert_same l1, UberLogger['simple']
    assert_same l1, UberLogger.getLogger('simple')
  end

  def test_parented_log_acquisition
    l1 = UberLogger['simple', 'parent']
    assert_instance_of UberLogger, l1
    assert_equal 'parent::simple', l1.name
    assert_equal UberLogger::DEFAULT_PATTERN, l1.format.pattern

    refute_same l1, UberLogger['simple']
    assert_same l1, UberLogger['simple', 'parent']
    assert_same l1, UberLogger['simple', parent: 'parent']
    assert_same l1, UberLogger.getLogger('simple', 'parent')
    assert_same l1, UberLogger.getLogger('simple', parent: 'parent')
  end

  def test_alternate_pattern_log_acquisition
    l1 = UberLogger['simple', pattern: '%m']
    assert_instance_of UberLogger, l1
    assert_equal 'simple', l1.name
    assert_equal '%m', l1.format.pattern

    assert_same l1, UberLogger['simple']
    assert_same l1, UberLogger.getLogger('simple')
  end
end
