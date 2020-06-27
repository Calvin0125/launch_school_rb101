def prompt(message)
  puts "=> #{message}"
end

def valid_number?(num)
  num != 0
end

def operation_to_message(op)
  case op
  when '1'
    'Adding'
  when '2'
    'Subtracting'
  when '3'
    'Multiplying'
  when '4'
    'Subtracting'
  end
end

prompt("Welcome to Calculator! Enter your name:")

name = ''
loop do
  name = gets.chomp
  name.empty? ? prompt("Make sure to use a valid name.") : break
end

# must initialize variables outside loop scope
num1 = ''
num2 = ''

prompt("Hello, #{name}")

loop do
  loop do
    prompt("What's the first number?")
    num1 = gets.chomp.to_i
    if valid_number?(num1)
      break
    else
      prompt("That doesn't look like a valid number")
    end
  end
  loop do
    prompt("Whats the second number?")
    num2 = gets.chomp.to_i
    if valid_number?(num2)
      break
    else
      prompt("That doesn't look like a valid number")
    end
  end

  operator_prompt = <<-MSG
  What operation would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG
  prompt(operator_prompt)
  operator = ''
  loop do
    operator = gets.chomp
    %w(1 2 3 4).include?(operator) ? break : prompt("Must choose 1, 2, 3, or 4")
  end

  result = case operator
           when '1'
             num1 + num2
           when '2'
             num1 - num2
           when '3'
             num1 * num2
           when '4'
             (num1.to_f / num2.to_f).round(4)
           else
             0
           end

  prompt("#{operation_to_message(operator)} the two numbers...")
  prompt("The result is #{result}")
  prompt("Would you like to perform another calculation? (Y for yes)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt("Thank you for using calculator. Goodbye!")
