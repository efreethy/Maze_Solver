require_relative "maze"
require_relative "cell"

class PathBuilder
  attr_accessor :maze, :grid, :open_set, :closed_set, :current, :finish

  def initialize(maze)
    @maze = maze
    @grid = Array.new(maze.height) { Array.new(maze.width) }
    @open_set, @closed_set = [], []
    @finish = @maze.finish
  end


  def start
    start_pos = @maze.start
    x, y = start_pos[0], start_pos[1]
    @grid[x][y] = Cell.new(:god=>true, :pos => start_pos,
                                       :current => true, :status => "open")
    @current = @grid[x][y]
  end

  def find_candidates
    @maze.evaluate_path_space(@current.pos)
  end

  #among all surrounding spaces, it returns places which can be moved to
  #excluding closed cells, and instantiating parent cells if need be
  def evaluate_candidates
    candidates = find_candidates
    change_parents_if_necessary(candidates)
    instantiate_waiting_cells(candidates)
  end

  #returns the cell with lowest_f_score, this cell will be made current
  def pick_lowest_f_score
    lowest_f_score = @open_set.first.fscore
    best_choice = @open_set.first

    @open_set.each do |candidate|
      if candidate.fscore < lowest_f_score
        lowest_f_score = candidate.fscore
        best_choice = candidate
      end
    end
    best_choice
  end

  def switch_to_best_choice(best_choice)
    @open_set.delete(@current)
    @current.current, @current.status = false, "closed"
    @closed_set << @current
    best_choice.current = true
    @current = best_choice
  end

  def extract_best_path
    @current.get_parent_positions
  end

  private
  #lots of work, must set g_score, h_score, f_score, and push to open set
    def instantiate_waiting_cells(candidates)
      candidates.each do |candidate|
        x , y = candidate[0], candidate[1]
        if @grid[x][y].nil?
          @grid[x][y] = Cell.new(:parent => @current, :pos => candidate, :status => "open")
          set_g_h_and_f_scores(x,y)
          @open_set.push(@grid[x][y])
        end
      end
    end

    def change_parents_if_necessary(candidates)
      candidates.each do |candidate|
        x, y = candidate[0], candidate[1]
        if @open_set.include?(@grid[x][y])
           @grid[x][y].parent == @current if @current.better_g_score?(@grid[x][y])
        end
      end
    end

    def set_g_h_and_f_scores(x,y)
      @grid[x][y].gscore = @grid[x][y].calc_g_score
      @grid[x][y].hscore = @grid[x][y].set_h_score(@maze.finish)
      @grid[x][y].fscore = @grid[x][y].set_f_score(@maze.finish)
    end

end
