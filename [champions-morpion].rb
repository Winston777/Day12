require 'pry'
require 'colorize'

class Board

  attr_reader :cases
  attr_accessor :state

  def initialize(cases=[])
    @cases = cases
    # create 9 cases and .push it on a list
    10.times do
      @cases.push(BoardCase.new)
      @state = "game" #state could be game, win, or tie
    end
  end

  def display
    # format each values of boardcase in a beautifull array
    format_array = []
    @cases.each do |a_case|
      case a_case.value
      when nil
        format_array << "|   |".yellow
      when 'X'
        format_array << "| X |".yellow
      when 'O'
        format_array << "| O |".yellow
      end
    end
    puts format_array[1..3].join
    puts format_array[4..6].join
    puts format_array[7..9].join
  end

  def change_case_value(nbcase, new_value)
    # change the case value
    if @cases[nbcase].value == nil
    @cases[nbcase].value = new_value
  else
    puts "Case already written, you lost a turn.".red
    end
  end

  def can_change_value?(nbcase)
    # check if there is no value
    if @cases[nbcase].value != nil
      return false
    else true
    end
  end
  # Return nil if there is no winner, return 1 if player1 win and 2 if player2 win
  def winner?
    wins = [ # Here is all the possibilites to win
      [1, 2, 3], [4, 5, 6], [7, 8, 9],  # <-- Horizontal wins
      [1, 4, 7], [2, 5, 8], [3, 6, 9],  # <-- Vertical wins
      [1, 5, 9], [3, 5, 7],             # <-- Diagonal wins
    ]
    if wins.any? { |win| win.all? {|a_case| @cases[a_case].value == 'X'}}
      @state = "win"

      return 1
    end
    if wins.any? { |win| win.all? {|a_case| @cases[a_case].value == 'O'}}
      @state = "win"
      return 2
    end
  end

  # Return true if game is TIE
  def tie?
    if @cases.all? { |spot| spot == 'X' || spot == 'O' }

      @board.state == "tie"

      return true
    end
  end
end

# A classe to manage a Case
class BoardCase
  # get the value of a case readable
  attr_accessor :value

  def initialize(value=nil)
    @value = value
  end
end

# Define a Player
class Player
  # a player as a name
  attr_reader :sign, :name
  attr_accessor :state

  def initialize(name, sign)
    @name = name
    @sign = sign
    @state = "player"
  end
end

# Will take in charge the game
class Game

  attr_reader :board, :players

  def initialize(players=[])
    # Create two players, ask their name and initialise a board
    intro
    puts "Creating Players"
    puts "******************"
    puts "What's first player's name?"
    @player1 = Player.new(gets.chomp, "X")
    players.push(@player1)
    puts "What's second player's name?"
    @player2 = Player.new(gets.chomp, "O")
    players.push(@player2)
    @players = players
    puts "Creating Board".green
    @board = Board.new

  end

	def intro
    # A small introduction to TicTacToe
    puts "*************************".yellow
    puts "[---CHAMPIONS MORPION---]".yellow
    puts "*************************".yellow
    puts "Guideline :"
    puts "| 1 | | 2 | | 3 |".green
    puts "| 4 | | 5 | | 6 |".green
    puts "| 7 | | 8 | | 9 |".green
  end

  def go
    # Launch the game until there is a winner or a tie
    @board.display
    while @player1.state != "winner" || @board.state != "tie" || @player2.state != "winner"
      if @player2.state == "winner"
        puts "#{@player2.name} Wins!".blue
        break
      end
      turn(@player1)
      if @player1.state != "winner" && @player2.state != "winner"
        turn(@player2)
      elsif @player1.state == "winner"
        puts "#{@player1.name} Wins!".blue
        break
      elsif @player2.state == "winner"
        puts "#{@player2.name} Wins!".blue
        break
      elsif @board.state == "tie"
          puts "It's a Tie?!".yellow
          break
      end
    end
    puts "Game Over".blue
  end

  def turn(player)
    # A turn ask for a move, change case, display and look for winner or tie
    puts "#{player.name} turn:".green
    choice = gets.chomp.to_i
    @board.change_case_value(choice,player.sign)
    @board.display
    if @board.winner? || @board.tie?
      case @board.winner?
      when 1
        @player1.state = "winner"
      when 2
        @player2.state = "winner"
      end
  end
end
end

my_game = Game.new.go
