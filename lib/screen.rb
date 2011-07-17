class Screen

  attr_accessor :mode
  attr_accessor :device
  cattr_accessor :default

  def initialize
    self.mode= if Rails.env != 'development'
      :fullscreen
    else
      self.device =  Iphone.new(:phone,:m3,:vertical)
      :frame
    end
  end

end

