class DistrictController < ApplicationController
  def site
    @district = Government::SchoolDistrictKvn.find_by_nickname(params[:district_nickname])
    #render :text => @district.name
  end

end
