require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def winning_move_key(marker)
    line = WINNING_LINES.find do |winning_line|
      squares = @squares.values_at(*winning_line)
      marked = squares.find { |square| square.marker != Square::INITIAL_MARKER }
      two_identical_markers_and_an_empty_square?(squares) &&
        marked.marker == marker
    end
    line.find { |key| @squares[key].marker == Square::INITIAL_MARKER }
  end

  def can_win_on_next_move?(marker)
    WINNING_LINES.any? do |line|
      squares = @squares.values_at(*line)
      marked = squares.find { |square| square.marker != Square::INITIAL_MARKER }
      two_identical_markers_and_an_empty_square?(squares) &&
        marked.marker == marker
    end
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def two_identical_markers_and_an_empty_square?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 2
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker=nil)
    @marker = marker ? marker : choose_marker
  end

  def choose_marker
    marker = nil
    puts "Choose your marker:"
    loop do
      marker = gets.chomp.lstrip.chr
      break if marker.match(/\S/)
      puts "Sorry, that is not a valid marker."
      puts "Choose your marker:"
    end
    marker
  end
end

class TTTGame
  DEFAULT_COMPUTER_MARKER = "O"

  attr_reader :board, :human, :computer

  def initialize
    clear
    display_welcome_message
    @board = Board.new
    @human = Player.new
    c = @human.marker == DEFAULT_COMPUTER_MARKER ? "X" : DEFAULT_COMPUTER_MARKER
    @computer = Player.new(c)
    @current_marker = @human.marker
    @computer_score = 0
    @human_score = 0
  end

  def play
    clear

    loop do
      display_board

      players_make_moves

      award_point if board.someone_won?
      display_result
      break if best_3_of_5_winner
      break unless play_again?
      reset
      display_play_again_message
    end

    display_3_of_5_result
    display_goodbye_message
  end

  private

  def players_make_moves
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == @human.marker
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts "You have won #{@human_score} games."
    puts "Computer has won #{@computer_score} games."
    puts ""
    board.draw
    puts ""
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    if board.can_win_on_next_move?(computer.marker)
      computer_winning_move
    elsif board.can_win_on_next_move?(human.marker)
      computer_blocking_move
    else
      computer_regular_move
    end
  end

  def computer_winning_move
    key = board.winning_move_key(computer.marker)
    board[key] = computer.marker
  end

  def computer_blocking_move
    key = board.winning_move_key(human.marker)
    board[key] = computer.marker
  end

  def computer_regular_move
    if board.unmarked_keys.include?(5)
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def award_point
    if board.winning_marker == human.marker
      @human_score += 1
    elsif board.winning_marker == computer.marker
      @computer_score += 1
    end
  end

  def best_3_of_5_winner
    return human.marker if @human_score == 3
    return computer.marker if @computer_score == 3
    nil
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def display_3_of_5_result
    if best_3_of_5_winner == human.marker
      puts "You have won the tournament!"
    elsif best_3_of_5_winner == computer.marker
      puts "The computer has won the tournament!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = human.marker
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end
end

game = TTTGame.new
game.play
