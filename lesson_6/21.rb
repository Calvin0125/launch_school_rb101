require 'colorize'

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

  aces_total = if total + 11 + aces.length - 1 > 21
                 1
               else
                 11
               end

  aces_total + (aces.length - 1)
end

def play_again?
  prompt "Would you like to play again? ('y' for yes)"
  answer = gets.chomp
  answer.downcase == 'y'
end

def hit_or_stay
  loop do
    prompt "Hit or stay? ('h' for hit, 's' for stay)"
    choice = gets.chomp.downcase
    return choice if %w(h s).include?(choice)
    prompt "That's not a valid option."
  end
end

def player_turn!(player_hand, deck, dealer_hand)
  loop do
    system 'clear'
    prompt "The dealer has #{CARD_STRINGS[dealer_hand[0]]}."
    show_player_hand(player_hand)

    break if hit_or_stay == 's'
    player_hand << deal_card!(deck)

    if busted?(player_hand)
      system 'clear'
      show_player_hand(player_hand)
      break
    end
  end
end

def dealer_turn!(dealer_hand, deck)
  loop do
    break if calculate_total(dealer_hand) > 17 || busted?(dealer_hand)
    dealer_hand << deal_card!(deck)
  end
end

def busted?(hand)
  calculate_total(hand) > 21
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

def show_player_hand(player_hand)
  prompt "You have #{stringify_cards(player_hand)}, for a total of " + \
         calculate_total(player_hand).to_s.green + '.'
end

def show_dealer_hand(dealer_hand)
  prompt "The dealer had #{stringify_cards(dealer_hand)}, for a total of " + \
         calculate_total(dealer_hand).to_s.green + '.'
end

def display_results(player_hand, dealer_hand)
  case calculate_winner(player_hand, dealer_hand)
  when 'player'
    show_dealer_hand(dealer_hand)
    prompt 'You won!'
  when 'dealer'
    show_dealer_hand(dealer_hand)
    prompt 'The dealer won!'
  when 'tie'
    show_dealer_hand(dealer_hand)
    prompt "It's a tie!"
  end
end

def calculate_winner(player_hand, dealer_hand)
  if calculate_total(player_hand) > calculate_total(dealer_hand)
    'player'
  elsif calculate_total(dealer_hand) > calculate_total(player_hand)
    'dealer'
  else
    'tie'
  end
end

loop do
  deck = initialize_deck

  player_hand, dealer_hand = deal_hands!(deck)

  player_turn!(player_hand, deck, dealer_hand)
  if busted?(player_hand)
    prompt "You busted."
    show_dealer_hand(dealer_hand)
    prompt "The dealer wins!"
    play_again? ? next : break
  end

  dealer_turn!(dealer_hand, deck)
  if busted?(dealer_hand)
    show_dealer_hand(dealer_hand)
    prompt "The dealer busted."
    prompt "You win!"
    play_again? ? next : break
  end

  display_results(player_hand, dealer_hand)
  play_again? ? next : break
end

prompt "Thank you for playing 21!"
