require "benchmark"

array_1 = [12,16,5,9,11,5,4]

i = 0
array_2 = []

array_1.length.times do
  array_2 << array_1.reverse[i]
  i += 1
end

puts array_2

time = Benchmark.measure do
  (1..10000).each { |i| i }
end

puts time
