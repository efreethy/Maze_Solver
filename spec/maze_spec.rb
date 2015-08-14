require "maze.rb"

describe Maze do
  before do
    @maze = Maze.new("maze2.txt")
  end

  it "finds its width and height" do
    expect(@maze.width).to eq(16)
    expect(@maze.height).to eq(6)
  end

  it "finds its own start and finish" do
    expect(@maze.start).to eq([4,1])
    expect(@maze.finish).to eq([1,14])
  end

  describe "#mark" do
    it "can retrieve and mark it's contents" do
      expect(@maze[0,0]).to eq("*")
      @maze.mark(0,0,"X")
      expect(@maze[0,0]).to eq("X")
    end
  end

  describe "#evaluate_path_space" do
    it "returns all available positions to instantiate cells" do
     expect(@maze.evaluate_path_space([1,1])).to eq([[1,2],[2,1],[2,2]])
    end
  end

end
