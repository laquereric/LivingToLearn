class Screen
  FrameEnable= true
  attr_accessor :mode
  attr_accessor :device
  cattr_accessor :default

  def html_body_style
    #if self.mode ==  :fullscreen
    #  ""
    #else
      "background-image:url('/images/kids_hand_prints.jpg')"
    #end
  end

  def  component_style
   #if self.mode ==  :fullscreen
   #  "background-image:url('/images/kids_hand_prints.jpg')"
   # else
      ""
   #end
  end

  def initialize
    self.mode= if !FrameEnable or Rails.env != 'development'
      :fullscreen
    else
      self.device =  Iphone.new(:phone,:m3,:vertical)
      :frame
    end
  end

end

