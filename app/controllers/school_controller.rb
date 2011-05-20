class SchoolController < ApplicationController
  layout "kvn_page"
  before_filter :never_for_subdomain
  before_filter :authenticate_user!

  def site
    @district = Government::SchoolDistrictKvn.find_by_nickname(params[:district_nickname])
    @school =  @district.schools.select{ |school| 
      school.government_district_id == @district.id
    }.first
  end

end
