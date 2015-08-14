class Maze
  attr_accessor :width, :height, :grid, :start, :finish

  def initialize(maze_file)
    @width, @height = get_width_height(maze_file)
    @grid = make_grid(maze_file)
    @start, @finish = find_start_finish(maze_file)
  end

  def print_maze
    @grid.each { |line| puts line }
  end

  def [](*pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(row,col,value)
    @grid[row][col] = value
  end

  def mark(*pos,value)
    self[pos[0],pos[1]] = value
  end


  def evaluate_path_space(pos)
    candidates = return_candidates(pos)
    candidates.select do |pos|
      self[pos[0],pos[1]] == " "
    end
  end

private

  def return_candidates(pos)
    moves = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
    moves.map do |direction|
      [pos[0]+ direction[0], pos[1] + direction[1]]
    end
  end

  def get_width_height(maze_file)
    maze_width, maze_height = 0, 0
    File.open("#{maze_file}").each_line do |line|
      maze_width = line.length - 1
      maze_height += 1
    end
    [maze_width, maze_height]
  end

  def make_grid(maze_file)
    maze_grid = [ ]
    File.open("#{maze_file}").each_line do |line|
      maze_grid.push(line.chomp)
    end
    maze_grid
  end

  def find_start_finish(maze_file)
      start, finish = [], []
      @grid.each_index do |row|
        char_arr = [] ; @grid[row].each_char { |char| char_arr << char}
        char_arr.each_index do |col|
          start = [row,col] if @grid[row][col] == "S"
          finish = [row,col] if @grid[row][col] == "E"
        end
      end
      [start,finish]
    end

end
