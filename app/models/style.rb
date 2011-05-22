class Style

  def self.choose_layout(for_site,subdomain)
    layout = nil
    layout = self.choose_site_layout(subdomain) if layout.nil? and for_site
    layout = 'application' if layout.nil?
    return layout
  end

  def self.choose_site_layout(subdomain)
    layout = nil
    #layout = layout_specific_to_type(subdomain) if layout.nil?
    layout = layout_specific_to_entity(subdomain) if layout.nil?
    layout = layout_specific_to_muni(subdomain) if layout.nil?
    return layout
  end

  def self.layout_specific_to_country(subdomain)
    filename = File.join(Rails.root,'app','views','layouts','site',
      "country_#{subdomain.country}",
      'application.html.erb'
    )
p filename
    if File.exists?(filename)
p 'hit'
      filename
    else
      nil
    end
  end

  def self.layout_specific_to_state(subdomain)
    filename = File.join(Rails.root,'app','views','layouts','site',
      "country_#{subdomain.country}",
      "state_#{subdomain.state}",
      'application.html.erb'
    )
p filename
    if File.exists?(filename)
p 'hit'
      filename
    else
      nil
    end
  end

   def self.layout_specific_to_county(subdomain)
    filename = File.join(Rails.root,'app','views','layouts','site',
      "country_#{subdomain.country}",
      "state_#{subdomain.state}",
      "county_#{subdomain.county}",
      'application.html.erb'
    )
p filename
    if File.exists?(filename)
p 'hit'
      filename
    else
      nil
    end
  end

  def self.layout_specific_to_muni(subdomain)
    filename = File.join(Rails.root,'app','views','layouts','site',
      "country_#{subdomain.country}",
      "state_#{subdomain.state}",
      "county_#{subdomain.county}",
      "muni_#{subdomain.muni}",
      'application.html.erb'
    )
p filename
    if File.exists?(filename)
p 'hit'
      filename
    else
      nil
    end
  end

  def self.layout_specific_to_entity(subdomain)
    filename = File.join(Rails.root,'app','views','layouts','site',
      "country_#{subdomain.country}",
      "state_#{subdomain.state}",
      "county_#{subdomain.county}",
      "muni_#{subdomain.muni}",
      "name_#{subdomain.name}",
      'application.html.erb'
    )
p filename
    if File.exists?(filename)
p 'hit'
      filename
    else
      nil
    end
  end

end
