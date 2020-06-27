puts "Welcome to Calculator!"
puts "What's the first number?"
num1 = gets.chomp.to_i
puts "Whats the second number?"
num2 = gets.chomp.to_i
puts "What operation would you like to perform? 1) add 2) subtract 3) multiply 4) divide"
operator = gets.chomp
case operator
when '1'
  result = num1 + num2
when '2'
  result = num1 - num2
when '3'
  result = num1 * num2
when '4'
  result = (num1.to_f / num2.to_f).round(4)
else
  result = 0
end

puts "The result is #{result}"