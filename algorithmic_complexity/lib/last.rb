require "benchmark"

number_array = [1,2,4,5,6,7,8,9,10]

puts number_array.last

time = Benchmark.measure do
  (1..10000).each { |i| i }
end

puts time
