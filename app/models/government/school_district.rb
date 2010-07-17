class Government::SchoolDistrict < Government::GovernmentDetail
  set_table_name :government_school_districts
  belongs_to :county, :class_name => "Entity", :foreign_key => :government_county_id
  belongs_to :state, :class_name => "Entity", :foreign_key => :government_state_id
  belongs_to :country, :class_name => "Entity", :foreign_key => :government_country_id

  def total_funded_pupils_fy2010
    at_risk_pupils_fy2010 + poverty_pupils_fy2010 
  end

  def total_allocation_fy2010
    arra_allocation_fy2010 + ses_allocation_fy2010 
  end

  def per_pupil_allocation_fy2010
    total_allocation_fy2010 / total_funded_pupils_fy2010
  end

####

  def total_funded_pupils_fy2011
    at_risk_pupils_fy2010 + poverty_pupils_fy2010 
  end

  def total_allocation_fy2011
    arra_allocation_fy2010 + ses_allocation_fy2010 
  end

  def per_pupil_allocation_fy2011
    total_allocation_fy2010 / total_funded_pupils_fy2010
  end

end
