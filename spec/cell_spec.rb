require "cell.rb"
require "maze.rb"

describe Cell do
  before do
    @maze = Maze.new("maze1.txt")
    @cell1 = Cell.new(:pos => [6,1], :status => "open", :god => true)
    @cell2 = Cell.new(:pos => [1,14], :current => true)
    @cell3 = Cell.new(:pos => [2,2], :value => "*", :status => "closed")
    @cell4 = Cell.new(:pos => [5,1], :parent => @cell1)
    @cell5 = Cell.new(:pos => [4,2], :parent => @cell4)
    @cell6 = Cell.new(:pos => [3,1], :parent => @cell5)
    @cell7 = Cell.new(:pos => [4,1], :parent => @cell6)
  end



  describe "#calc_g_score" do
    it "calculates a cells gscore recursively" do
      expect(@cell5.calc_g_score).to eq(24)
    end

    it "will do it again" do
      expect(@cell6.calc_g_score).to eq(38)
    end
  end

  describe "#gscore" do
    it "sets instance variable to the cells gscore" do
      expect(@cell6.gscore).to eq(38)
    end
  end

  describe "#calc_h_score" do
    it "calculates a cells h_score" do
      expect(@cell1.calc_h_score([1,14])).to eq(180)
    end
  end

  describe "#set_h_score" do
    it "calculates a cells h_score" do
      expect(@cell3.set_h_score(@maze.finish)).to eq(130)
   end
  end

  describe "#set_f_score" do
    it "will return the sum of h and g score, namely, the f score" do
      expect(@cell6.gscore).to eq(38)
      expect(@cell6.set_h_score(@maze.finish)).to eq(150)
      expect(@cell6.set_f_score(@maze.finish)).to eq(188)
    end
  end

  describe "#better_g_score?" do
    it "evaluate g_score as if 'self' was the parent, returns true if g_score is better" do
        expect(@cell5.better_g_score?(@cell7)).to be_truthy
    end
  end

  describe "#get_parent_positions" do
    it "extract best path of travel through grabbing parents positons" do
      expect(@cell6.get_parent_positions).to eq([[3,1],[4,2],[5,1]])
    end
  end


end
