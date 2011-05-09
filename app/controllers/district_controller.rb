class DistrictController < ApplicationController
  layout "kvn_page"

  def character_book_pages
    @districts = Government::SchoolDistrictKvn.all
  end

  def site
    @district = Government::SchoolDistrictKvn.find_by_nickname(params[:district_nickname])
  end

end
