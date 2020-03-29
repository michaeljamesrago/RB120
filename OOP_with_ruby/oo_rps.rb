#Class Score will take two params at initialization, the Player objects.
#It will make them into keys for a hash, the value of which will be initialized
#to zero. It will increment by one each time a player wins. There will be a
# to_s method which will output "#{name}: score, #{name} score". The play will
# repeat as long as neither player has 10 points.
class Score
  POINTS_TO_WIN = 3

  def initialize(human, computer)
    @board = { human => 0, computer => 0 }
  end

  def points(player)
    @board[player]
  end

  def increment(player)
    @board[player] += 1 if player
  end

  def to_s
    scores = ''
    @board.each do |k, v|
      scores << "#{k.name}: #{v} \t"
    end
    scores
  end

  def winner
    @board.any?{ |k, v| return k if v == POINTS_TO_WIN }
    nil
  end
end

class Move
  attr_reader :value
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end
end

class Player
  attr_accessor :move, :name
  def initialize
    @move = nil
    set_name
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name."
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors: "
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value}"
    puts "#{computer.name} chose #{computer.move.value}"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors!"
  end

  def display_winner
    winner = nil
    if human.move > computer.move
      puts "#{human.name} won!!"
      winner = human
    elsif computer.move > human.move
      puts "#{computer.name} won!!"
      winner = computer
    else
      puts "It's a tie!!"
    end
    return winner
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, your answer must be y or n."
    end
    return true if answer == 'y'
    false
  end

  def play
    display_welcome_message

    loop do
      score = Score.new(human, computer)
      while !score.winner do
        human.choose
        computer.choose
        display_moves
        winner = display_winner
        score.increment(winner)
        puts score
      end
      puts "Winner is #{score.winner.name}!"
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
