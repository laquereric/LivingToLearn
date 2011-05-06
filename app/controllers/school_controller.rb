class SchoolController < ApplicationController

  def site
    @district = Government::SchoolDistrictKvn.find_by_nickname(params[:district_nickname])
    @school =  @district.schools.select{ |school| 
      school.government_district_id == @district.id
    }.first
  end

end
