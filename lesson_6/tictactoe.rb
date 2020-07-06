require 'pry'
require 'pry-byebug'
INITIAL_MARKER = ' '
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], \
                 [1, 4, 7], [2, 5, 8], [3, 6, 9], \
                 [1, 5, 9], [3, 5, 7]]
def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're an #{PLAYER_MARKER}."
  puts "Computer is an #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop: enable Metrics/MethodLength, Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_turn!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def defense(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2
      return brd.select { |key, _| line.include?(key) }.key(' ')
    end
  end
  nil
end

def offense(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2
      return brd.select { |key, _| line.include?(key) }.key(' ')
    end
  end
  nil
end

def computer_turn!(brd)
  binding.pry
  square = if offense(brd)
             offense(brd)
           elsif defense(brd)
             defense(brd)
           elsif empty_squares(brd).include?(5)
             5
           else
             empty_squares(brd).sample
           end
  binding.pry
  brd[square] = COMPUTER_MARKER
end

def take_turn!(brd, current_player)
  if current_player == 'player'
    player_turn!(brd)
  elsif current_player == 'computer'
    computer_turn!(brd)
  end
end

def alternate_player(current_player)
  current_player == 'player' ? 'computer' : 'player'
end

def draw?(brd)
  true if empty_squares(brd).empty?
end

def win?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def joinor(array, delimiter = ',', word = 'or')
  case array.length
  when 0 then ''
  when 1 then array[0]
  when 2 then array.join(" #{word} ")
  else
    array[-1] = "#{word} #{array.last}"
    array.join(delimiter)
  end
end

computer_score = 0
player_score = 0

loop do
  board = initialize_board
  current_player = ''
  loop do
    prompt "Choose who goes first. Enter 'p' for player or 'c' for computer."
    choice = gets.chomp
    if choice.downcase == 'p'
      PLAYER_MARKER = 'X'
      COMPUTER_MARKER = 'O'
      current_player = 'player'
      break
    elsif choice.downcase == 'c'
      PLAYER_MARKER = 'O'
      COMPUTER_MARKER = 'X'
      current_player = 'computer'
      break
    else
      prompt "That's not a valid choice."
    end
  end

  loop do
    display_board(board)

    take_turn!(board, current_player)
    current_player = alternate_player(current_player)

    break if win?(board) || draw?(board)
  end

  display_board(board)

  if win?(board)
    prompt "#{detect_winner(board)} won!"
    detect_winner(board) == 'Player' ? player_score += 1 : computer_score += 1
  else
    prompt "It's a tie!"
  end

  prompt "Player Score: #{player_score}"
  prompt "Computer Score: #{computer_score}"

  if player_score == 5
    prompt "Player is the overall winner!"
    break
  elsif computer_score == 5
    prompt "The computer is the overall winner!"
    break
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe! Goodbye"
