require_relative "maze"
require_relative "cell"
require_relative "pathbuilder"

maze_file = ARGV[0]

@maze = Maze.new(maze_file)
@path = PathBuilder.new(@maze)

@path.start

iterations = 0
until @path.current.hscore == 10 do
  @path.evaluate_candidates
  best_choice = @path.pick_lowest_f_score
  @path.switch_to_best_choice(best_choice)
  iterations += 1
end


@path.current.get_parent_positions.each do |pos|
    @maze.mark(pos[0],pos[1],"X")
end

@maze.print_maze
puts "It took #{iterations} iterations"
