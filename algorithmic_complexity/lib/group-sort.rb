require 'benchmark'

puts "Please enter the number of students "
num = gets.chomp

STUDENTS_ARRAY = []
groups_array = []

def student_generator(num)
  num.to_i.times {
    STUDENTS_ARRAY << (0...5).map { ('a'..'z').to_a[rand(26)] }.join
  }
end

puts "you chose #{student_generator(num)} students."

puts "Please type the number of groups"
group_number = gets.chomp.to_i
puts "you chose #{group_number} groups."

groups_array = STUDENTS_ARRAY.each_slice(  (STUDENTS_ARRAY.size/group_number.to_f).round  ).to_a

print "the groups are: #{groups_array}"

time = Benchmark.measure do
  (1..10000).each { |i| i }
end

puts time
