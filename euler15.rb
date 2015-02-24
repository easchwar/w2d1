# class PathFinder
#   def initialize
#     @count = 0
#     @size = 14
#     @target = [@size, @size]
#   end
#
#   def travel(pos)
#     x, y = pos
#     return 0 if x > @size || y > @size
#     if pos == @target
#       return 1
#     end
#     travel([x+1, y]) + travel([x, y+1])
#   end
# end
#
# finder = PathFinder.new
#
# puts finder.travel([0,0])

size = 21
grid = Array.new(size) {Array.new(size){0}}

size.times do |idx|
  grid[idx][0] = 1
  grid[0][idx] = 1
end

grid.each_with_index do |row, idx|
  next if idx==0
  (1...row.length).each do |idy|
    row[idy] = row[idy-1] + grid[idx-1][idy]
  end
end

p grid[-1][-1]
