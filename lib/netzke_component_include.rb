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

  def alert_tag(contents)
    if contents[:alert]
      "<div class=\"alert\">#{contents[:alert]}<div></br>"
    else
      ""
    end
  end

  def notice_tag(contents)
    if contents[:notice]
      "<div class=\"notice\">#{contents[:notice]}<div></br>"
    else
      ""
    end
  end

  def tab_html(contents,region)
    "#{notice_tag(contents)}#{alert_tag(contents)}<div class=\"tab-region\">#{region}<div>"
  end

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
      :html => self.tab_html(contents,region)
    } )
  end

  def tab_item_keys
    [:message,:target,:main]
  end

  def tab_items(contents)
    tab_item_keys.map{ |key| tab_item(contents,key) }.compact
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
