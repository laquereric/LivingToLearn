module NetzkeComponentInclude

#############
# Toolbars
#############

  def public_toolbar_items
    [
      {:text => "Register", :handler => :to_register},
      {:text => "Login", :handler => :to_login},
    ]
  end

  def user_toolbar_items
    [
     {:text => "Logout", :handler => :to_logout}
    ]
  end

###############
# Tabs
###############

  def tab_item(contents,key)
    region_key= "#{key.to_s}__region".to_sym
    region= contents[region_key]
    return nil if region.nil?

    title_key= "#{key.to_s}__title".to_sym
    title= contents[title_key]
    title||= key.to_s.titleize

    return ( region.nil? ? nil : {
      :title => title,
      :cls => "#{key.to_s} transparent-class",
      :html => "#{contents[:notice]}</br>#{contents[:alert]}</br>#{region}"
    } )
  end

  def tab_items(contents)
    [:message,:target,:main].map{ |key| tab_item(contents,key)}.compact
  end

#########################
# Screen
##########################
  def screen_config
    screen= Screen.default
    if screen.mode == :fullscreen
      { :fullscreen => true }
    else
      res= screen.device.resolution
      {
        :height => res[:height],
        :width => res[:width]
      }
    end
  end

end
