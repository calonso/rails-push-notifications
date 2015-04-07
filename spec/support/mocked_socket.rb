
class MockedSocket < IO

  def initialize
    super IO.sysopen '/dev/null'
    #sclose_read
  end

  def write

  end

  def flush

  end

  def close

  end

  def read(num)

  end

  def eof?
    true
  end

  def eof
    true
  end

  def closed?
    true
  end

  def stat
    p 'STATED'
    nil
  end

  def readpartial(a, b=nil)
    p 'PARTIAL'
    sleep(10)
  end

  def self.before(*names)
    names.each do |name|
      m = instance_method(name)
      define_method(name) do |*args, &block|
        yield name
        m.bind(self).(*args, &block)
      end
    end
  end

  before(*instance_methods) { |n| puts "start #{n}" }

end
