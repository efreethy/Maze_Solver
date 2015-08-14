require "pathbuilder.rb"
require "maze.rb"
require "cell.rb"
require 'byebug'

describe PathBuilder do
  before do
    @maze = Maze.new("maze1.txt")
    @path = PathBuilder.new(@maze)
  end

  describe "#start" do
    it "makes starting cell the current cell and pushes it into open set" do
      @path.start
      start_pos = @maze.start
      x, y = start_pos[0], start_pos[1]
      expect(@path.grid[x][y]).to be_a_kind_of(Cell)
      expect(@path.grid[x][y].current).to be_truthy
    end
  end

  describe "#find_candidates" do
    it "evaluates path space" do
      @path.start
      expect(@maze.evaluate_path_space(@path.current.pos)).to eq([[5,1],[5,2],[6,2]])
    end
  end


  describe "#evaluate_candidates" do
    it "expands the open set, sets all scores, returns only open candidates" do
      @path.start
      @path.evaluate_candidates
      expect(@path.open_set.length).to eq(3)
      expect(@path.grid[6][2].gscore).to eq(10)
      expect(@path.grid[6][2].hscore).to eq(170)
      expect(@path.grid[6][2].fscore).to eq(180)
      expect(@path.grid[5][1].fscore).to eq(180)
      expect(@path.grid[5][2].fscore).to eq(174)

    end
  end

  describe "#pick_lowest_f_score" do
    it "picks the lowest available fscore among candidates" do
      @path.start
      candidates = @path.evaluate_candidates
      best_choice = @path.pick_lowest_f_score
      expect(best_choice).to eq(@path.grid[5][2])
    end
  end

  describe "#switch_to_best_choice" do
    it "closes the current cell, moving to the best choice cell" do
      @path.start
      candidates = @path.evaluate_candidates
      best_choice = @path.pick_lowest_f_score
      @path.switch_to_best_choice(best_choice)
      expect(@path.grid[6][1].current).to be_falsey
      expect(@path.grid[5][2].current).to be_truthy
      expect(@path.current).to eq(@path.grid[5][2])
    end
  end



end
