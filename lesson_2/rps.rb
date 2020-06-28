CHOICES = %w(rock paper scissors lizard Spock)

RULES = {
  'rock' => %w(lizard scissors),
  'lizard' => %w(paper Spock),
  'scissors' => %w(paper lizard),
  'Spock' => %w(scissors rock),
  'paper' => %w(Spock rock)
}

def prompt(message)
  puts "=> #{message}"
end

def letter_to_choice(letter)
  case letter
  when 'r'
    'rock'
  when 'p'
    'paper'
  when 's'
    'scissors'
  when 'l'
    'lizard'
  when 'sp'
    'Spock'
  else
    'invalid'
  end
end

def win?(first, second)
  RULES[first].include?(second)
end

def display_results(choice, computer_choice)
  if win?(choice, computer_choice)
    prompt("You won!")
  elsif choice == computer_choice
    prompt("It's a draw.")
  else
    prompt("You lose.")
  end
end

computer_score = 0
player_score = 0

loop do
  choice = ''
  loop do
    prompt("Choose one: #{CHOICES.join(', ')}")
    prompt("Type the first letter of your choice, or 'sp' for Spock.")
    choice = letter_to_choice(gets.chomp)

    if CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  computer_choice = CHOICES.sample

  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

  if win?(choice, computer_choice)
    player_score += 1
  elsif win?(computer_choice, choice)
    computer_score += 1
  end

  display_results(choice, computer_choice)

  prompt("Score\n   You: #{player_score}\n   Computer: #{computer_score}")

  if computer_score == 5
    prompt("The computer is the grand winner!")
    break
  elsif player_score == 5
    prompt("You are the grand winner!")
  end

  prompt("Do you want to play again? ('y' for yes)")
  answer = gets.chomp.downcase
  break unless answer == 'y'
end

prompt("Thank you for playing rock, paper, scissors, lizard, Spock.")
