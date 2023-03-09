class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @com = "X" # the computer's marker
    @hum = "O" # the user's marker
    @gamemode = nil
  end

  def start_game
    # start by printing the board
    set_gamemode
    # loop through until the game was won or tied
    if (@gamemode == 1)
      print_board
      computer_x_human
    end
    if (@gamemode == 2)
      computer_x_computer
    end
    
  end

  def get_human_spot
    spot = nil
    until spot
      puts "Enter [0-8]:"
      spot = gets.chomp.to_i
      if spot.between?(0,8)
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = @hum
        else
          spot = nil
          puts 'Invalid entry, please select another position'
        end
      else
        spot = nil
        puts 'Invalid entry'
      end
    end
  end

  def eval_board(player)
    spot = nil
    until spot
      if @board[4] == "4"
        spot = 4
        @board[spot] = player
      else
        spot = get_best_move(@board, player)
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = player
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil
    board.each do |s|
      if s != "X" && s != "O"
        available_spaces << s
      end
    end
    available_spaces.each do |as|
      board[as.to_i] = @com
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = as
        end
      end
    end
    if best_move
      return best_move
    else
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end

  def game_is_over(b)

    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie(b)
    b.all? { |s| s == "X" || s == "O" }
  end

end

def print_board
puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
end

def set_gamemode
  until @gamemode
    puts 'please select the gamemode'
    puts '1 - Computer vs Human'
    puts '2 - Computer vs Computer'
    puts '3 - Human vs Human'
    @gamemode = gets.chomp.to_i
      if !@gamemode.between?(1,3)
        @gamemode = nil
        puts 'please insert an correct value to gamemode'
      end
  end
end

def computer_x_human
  until game_is_over(@board) || tie(@board)
      get_human_spot
      if !game_is_over(@board) && !tie(@board)
        eval_board
      end
      print_board
    end
    if tie(@board)
      puts "it's a tie!"
    end
    puts "Game over"
end

def computer_x_computer
  until game_is_over(@board) || tie(@board)
    #aqui vai a jogada do computador um
    eval_board(@hum)
    print_board
    wait_interaction
    if !game_is_over(@board) && !tie(@board)
      #aqui vai a jogada do computador dois
      eval_board(@com)
    end
    print_board
    wait_interaction
  end
  if tie(@board)
    puts "its a tie!"
  end
  puts "Game over"
end

def wait_interaction
  key = nil
  until key
    puts 'press any key to the next turn'
    key = gets.chomp
  end
end

game = Game.new
game.start_game
