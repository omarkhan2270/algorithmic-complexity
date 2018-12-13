Class Timerr
def self.time(&block)
  start_time = Time.now
  result = block.call
  end_time = Time.now
  @time_taken = end_time - start_time
  result
end

def self.elapsedTime
  return @time_taken
end

Timer.time {puts "hello world"}
