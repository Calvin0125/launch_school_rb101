CHOICES = ['rock', 'paper', 'scissors']

def prompt(message)
  puts "=> #{message}"
end

def display_results(choice, computer_choice)
  if (choice == 'rock' && computer_choice == 'scissors') ||
     (choice == 'paper' && computer_choice == 'rock') ||
     (choice == 'scissors' && computer_choice == 'paper')
    prompt("You won!")
  elsif choice == computer_choice
    prompt("It's a draw.")
  else
    prompt("You lose.")
  end
end

loop do
  choice = ''
  loop do
    prompt("Choose one: #{CHOICES.join(', ')}")
    choice = gets.chomp

    if CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  computer_choice = CHOICES.sample

  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

  display_results(choice, computer_choice)

  prompt("Do you want to play again? ('y' for yes)")
  answer = gets.chomp.downcase
  break unless answer == 'y'
end

prompt("Thank you for playing rock, paper, scissors.")
