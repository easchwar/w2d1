require 'yaml'

class Tile
  attr_accessor :flagged, :bombed, :neighbors, :revealed

  def initialize(bombed=false)
    @bombed = bombed
    @flagged = false
    @revealed = false
    @neighbors = []
  end

  def reveal
    @revealed = true
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
  def initialize(size = 9, bombs = 12)
    @size = size
    @tile_grid = Array.new(size) { Array.new(size) { Tile.new } }
    @visited_tiles = []
    @num_bombs = bombs
    fill_board
    place_bombs
  end

  def fill_board
    @size.times do |x|
      @size.times do |y|
        @tile_grid[x][y].neighbors = possible_neighbors([x, y])
      end
    end
  end

  def place_bombs
    indices = []
    @size.times do |i|
      @size.times do |j|
        indices << [i, j]
      end
    end
    bombs = indices.sample(@num_bombs)

    bombs.each do |tile|
      @tile_grid[tile[0]][tile[1]].bombed = true
    end
  end

  def possible_neighbors(pos)
    x, y = pos
    neighbors = []
    (x - 1..x + 1).each do |x_pos|
      (y - 1..y + 1).each do |y_pos|
        next if [x_pos,y_pos] == pos
        if x_pos >= 0 && x_pos < @size &&
           y_pos >= 0 && y_pos < @size
          neighbors << @tile_grid[x_pos][y_pos]
        end
      end
    end
    neighbors
  end

  def reveal(tile)
    return false if tile.flagged
    tile.reveal
    @visited_tiles << tile
    return false if tile.bombed
    if tile.neighbor_bomb_count == 0
      tile.neighbors.each do |neighbor|
        next if @visited_tiles.include?(neighbor)
        reveal(neighbor)
      end
    end
    true
  end

  def flag(tile)
    tile.flagged = tile.flagged ? false : true
  end

  def tile_from_pos(pos)
    x, y = pos
    @tile_grid[x][y]
  end

  def won?
    @size ** 2 - @visited_tiles.length == @num_bombs && !loss?
  end

  def loss?
    @visited_tiles.any?{|tile| tile.bombed}
  end

  def over?
    won? || loss?
  end

  def render
    output = ""
    @size.times do |x|
      @size.times do |y|
        current_tile = @tile_grid[x][y]
        if !current_tile.revealed
          if current_tile.flagged
            output += "F"
          else
            output += "*"
          end
        elsif current_tile.bombed
          output += "!"
        elsif current_tile.neighbor_bomb_count == 0
          output += "_"
        else
          output += "#{current_tile.neighbor_bomb_count}"
        end
      end
      output += "\n"
    end
    output
  end

  def display
    puts render
  end
end

class Game
  def self.load(filename)
    yml_game = File.read(filename)
    YAML::load(yml_game)
  end

  def initialize(size = 9)
    @start_time = Time.now
    @board = Board.new(size)
  end

  def play_game
    until @board.over?
      @board.display
      f, x, y = user_input
      if f.upcase == "F"
        flag([x, y])
      else
        make_move([x, y])
      end
    end
    @board.display
    if @board.won?
      puts "You won in #{Time.now - @start_time} seconds!"
    else
      puts "You Stink!"
    end
  end

  def save(filename)
    File.open(filename, "w") do |f|
      f.puts self.to_yaml
    end
  end

  def user_input
    puts "Enter your move: "
    m, x, y = gets.chomp.split(' ')
    [m, x.to_i, y.to_i]
  end

  def flag(move_pos)
    tile = @board.tile_from_pos(move_pos)
    @board.flag(tile)
  end

  def make_move(move_pos)
    tile = @board.tile_from_pos(move_pos)
    @board.reveal(tile)
  end
end
