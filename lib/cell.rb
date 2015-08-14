require_relative "maze"

class Cell
  #the 'god' attribute means it is the start, or the 'S' cell.
  attr_accessor :parent, :status, :current, :pos, :god, :gscore, :hscore, :fscore

  def initialize(options = {})
    defaults = { :current => false , :god => false}
    options = defaults.merge(options)

    @god = options[:god]
    @status = options[:status]
    @parent = options[:parent]
    @current = options[:current]
    @pos = options[:pos]
  end

  def set_f_score(maze)
    @fscore = gscore + calc_h_score(maze)
  end

  def gscore
    @gscore = calc_g_score unless self.god == true
  end

  def set_h_score(maze)
    @hscore = calc_h_score(maze)
  end

  def calc_g_score
    self.parent.god == true ? relative_g_score : relative_g_score + self.parent.calc_g_score
  end

  def calc_h_score(end_pos)
    vertical_difference = (end_pos[0] - self.pos[0]).abs
    horizontal_difference = (end_pos[1] - self.pos[1]).abs
    (vertical_difference + horizontal_difference)*10
  end

  #compares the natural g_score of cell to the g_score if 'self' was the parent.
  def better_g_score?(cell)
    original_parent = cell.parent
    natural_g_score = cell.calc_g_score

    cell.parent = self
    comparative_g_score = cell.calc_g_score
    cell.parent = original_parent

    (natural_g_score > comparative_g_score) ? true : false
  end

  def get_parent_positions
    self.parent.god == true ? [self.pos] : [self.pos] + self.parent.get_parent_positions
  end

  private


  def relative_g_score
    (@pos[0] == @parent.pos[0]) || (@pos[1] == @parent.pos[1]) ? 10 : 14
  end

end
