class Iphone
  attr_accessor :type
  attr_accessor :model
  attr_accessor :orientation

  def initialize(type,model,orientation)
    self.type= type
    self.model= model
    self.orientation= orientation
  end

  def resolution

    if type == :phone and model == :m3 and orientation == :vertical
      { :width => 320, :height => 480}
    elsif type == :phone and model == :m3 and orientation == :horizontal
      { :width => 480, :height => 320}

    elsif type == :phone and model == :m4 and orientation == :vertical
      { :width => 480, :height => 960}
    elsif type == :phone and model == :m4 and orientation == :horizontal
      { :width => 960, :height => 480}
    end

  end

end

