require 'colorize'

MAX_VALUE = 21
DEALER_STAY = 17

CARD_STRINGS = { '2' => 'a ' + '2'.red,
                 '3' => 'a ' + '3'.red,
                 '4' => 'a ' + '4'.red,
                 '5' => 'a ' + '5'.red,
                 '6' => 'a ' + '6'.red,
                 '7' => 'a ' + '7'.red,
                 '8' => 'an ' + '8'.red,
                 '9' => 'a ' + '9'.red,
                 '10' => 'a ' + '10'.red,
                 'J' => 'a ' + 'jack'.red,
                 'Q' => 'a ' + 'queen'.red,
                 'K' => 'a ' + 'king'.red,
                 'A' => 'an ' + 'ace'.red }

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  deck = ('2'..'10').to_a * 4
  deck += ['J', 'Q', 'K', 'A'] * 4
  deck.shuffle
end

def deal_hands!(deck)
  player_hand = deck.shift(2)
  dealer_hand = deck.shift(2)
  return player_hand, dealer_hand
end

def deal_card!(deck)
  deck.shift
end

def calculate_total(hand)
  non_aces, aces = hand.partition { |card| card != 'A' }
  total = 0
  non_aces.each do |card|
    total += if card.to_i > 0
               card.to_i
             else
               10
             end
  end
  total += calculate_aces(aces, total)
end

def calculate_aces(aces, total)
  return 0 if aces.empty?

  aces_total = if total + 11 + aces.length - 1 > MAX_VALUE
                 1
               else
                 11
               end

  aces_total + (aces.length - 1)
end

def play_again?
  answer = ''

  loop do
    prompt "Would you like to play again? ('y' for yes, 'n' for no)"
    answer = gets.chomp.downcase
    break if %w(y n).include?(answer)
    prompt "That's not a valid option."
  end

  answer == 'y'
end

def play_another_five?
  answer = ''

  loop do
    prompt "Would you like to play another 5 rounds? ('y' for yes, 'n' for no)"
    answer = gets.chomp.downcase
    break if %w(y n).include?(answer)
    prompt "That's not a valid option."
  end

  answer == 'y'
end

def hit_or_stay
  loop do
    prompt "Hit or stay? ('h' for hit, 's' for stay)"
    choice = gets.chomp.downcase
    return choice if %w(h s).include?(choice)
    prompt "That's not a valid option."
  end
end

def player_turn!(player_hand, player_total, deck, dealer_hand)
  loop do
    if player_total >= MAX_VALUE
      system 'clear'
      show_player_hand(player_hand, player_total)
      sleep 2
      break
    end

    system 'clear'
    prompt "The dealer has #{CARD_STRINGS[dealer_hand[0]]} and another card."
    show_player_hand(player_hand, player_total)

    break if hit_or_stay == 's'
    player_hand << deal_card!(deck)
    player_total = calculate_total(player_hand)
  end
end

def dealer_turn!(dealer_hand, dealer_total, deck)
  loop do
    show_dealer_hand(dealer_hand, dealer_total)
    sleep 2
    break if dealer_total >= DEALER_STAY || busted?(dealer_total)
    prompt "The dealer hits!"
    sleep 1
    dealer_hand << deal_card!(deck)
    dealer_total = calculate_total(dealer_hand)
  end
end

def busted?(hand)
  hand > MAX_VALUE
end

def stringify_cards(hand)
  words = []
  hand.each do |card|
    words << CARD_STRINGS[card]
  end
  return "#{words[0]} and #{words[1]}" if words.length == 2
  words[-1] = "and #{words.last}"
  words.join(', ')
end

def show_player_hand(player_hand, player_total)
  prompt "You have #{stringify_cards(player_hand)}, for a total of " + \
         player_total.to_s.green + '.'
end

def show_dealer_hand(dealer_hand, dealer_total)
  prompt "The dealer has #{stringify_cards(dealer_hand)}, for a total of " + \
         dealer_total.to_s.green + '.'
end

def display_result_message(result)
  case result
  when 'player busted'
    prompt 'You busted. The dealer won!'
  when 'dealer busted'
    prompt 'The dealer busted. You won!'
  when 'player'
    prompt 'You won!'
  when 'dealer'
    prompt 'The dealer won!'
  when 'tie'
    prompt "It's a tie!"
  end
end

def show_results(player_hand, player_total, dealer_hand, dealer_total, result)
  system 'clear'
  puts "==============" * 5
  show_player_hand(player_hand, player_total)
  show_dealer_hand(dealer_hand, dealer_total)
  display_result_message(result)
  puts "==============" * 5 + "\n\n"
end

def calculate_winner(player_total, dealer_total)
  if player_total > MAX_VALUE
    'player busted'
  elsif dealer_total > MAX_VALUE
    'dealer busted'
  elsif player_total > dealer_total
    'player'
  elsif dealer_total > player_total
    'dealer'
  else
    'tie'
  end
end

def update_scores(result, player_score, dealer_score)
  case result
  when 'player busted', 'dealer'
    dealer_score += 1
  when 'dealer busted', 'player'
    player_score += 1
  end
  return player_score, dealer_score
end

def show_final_results(player_score, dealer_score)
  if dealer_score == 5
    prompt "The dealer is the grand winner!"
  elsif player_score == 5
    prompt "You are the grand winner!"
  end
end

def display_welcome_message
  system 'clear'
  prompt "Welcome to to 21!"
  prompt "Hit to get another card, and stay to keep the cards you have."
  prompt "Whoever is closest to 21 wins, but you lose if you go over."
  prompt "Number cards are worth their number, face cards are 10, " \
         "and aces are 1 or 11."
  prompt "Whoever wins 5 rounds first is the overall winner."
  prompt "Press enter to continue."
  gets.chomp
end

display_welcome_message

loop do
  dealer_score = 0
  player_score = 0
  still_playing = true

  loop do
    deck = initialize_deck

    player_hand, dealer_hand = deal_hands!(deck)

    player_total = calculate_total(player_hand)
    dealer_total = calculate_total(dealer_hand)

    player_turn!(player_hand, player_total, deck, dealer_hand)
    player_total = calculate_total(player_hand)

    unless busted?(player_total)
      dealer_turn!(dealer_hand, dealer_total, deck)
      dealer_total = calculate_total(dealer_hand)
    end

    result = calculate_winner(player_total, dealer_total)
    player_score, dealer_score = \
      update_scores(result, player_score, dealer_score)

    show_results(player_hand, player_total, dealer_hand, dealer_total, result)
    # Adding these prompts to show_results would result in a 7 parameter method
    # or would necessitate having multiple extra calls to calculate_total
    prompt "Player: #{player_score}"
    prompt "Dealer: #{dealer_score}\n\n"

    if player_score == 5 || dealer_score == 5
      show_final_results(player_score, dealer_score)
      break
    end

    still_playing = play_again?
    break unless still_playing
  end

  prompt "Thank you for playing 21!"
  break unless still_playing
  break unless play_another_five?
end
