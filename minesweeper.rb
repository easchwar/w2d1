class Tile
  attr_accessor :flagged, :bombed, :neighbors, :revealed

  def initialize(bombed=false)
    @bombed = bombed
    @flagged = false
    @revealed = false
    @neighbors = []
  end

  def reveal
    return false if @bombed
    @revealed = true
    if neighbor_bomb_count == 0
      @neighbors.each do |neighbor|
        neighbor.reveal
      end
    end
    return true
  end

  def neighbor_bomb_count
    count = 0
    @neighbors.each do |neighbor|
      count += 1 if neighbor.bombed
    end
    count
  end
end

class Board
  def initialize(size=9)
    @size = size
    @tile_grid = Array.new(size) { Array.new(size) { Tile.new } }
    fill_board
  end

  def fill_board
    nums = (0..10).to_a
    @size.times do |x|
      @size.times do |y|
        @tile_grid[x][y].neighbors = possible_neighbors([x, y])
        @tile_grid[x][y].bombed = true if nums.sample == 5
      end
    end
  end

  def possible_neighbors(pos)
    x, y = pos
    neighbors = []
    (x - 1..x + 1).each do |x_pos|
      (y - 1..y + 1).each do |y_pos|
        next if [x_pos,y_pos] == pos
        if x_pos > 0 && x_pos < @size &&
           y_pos > 0 && y_pos < @size
          neighbors << @tile_grid[x_pos][y_pos]
        end
      end
    end
  end

  def reveal(x,y)
    @tile_grid[x][y].reveal
  end

  def won?
  end

  def loss?
  end

  def over?
  end

  def render
    output = ""
    @size.times do |x|
      @size.times do |y|
        current_tile = @tile_grid[x][y]
        if !current_tile.revealed
          output += "*"
        elsif current
  end

  def display
    puts render
  end


end

class Game
  def initialize
    @board = Board.new
  end

  def play_game
    until @board.over?
      @board.display
      make_move(user_input)
    end
  end

  def user_input
    puts "Enter your move: "
    gets.chomp.split(' ').map(&:to_i)
  end

  def make_move(move)
    @board.reveal(move[0],move[1])
  end

end
