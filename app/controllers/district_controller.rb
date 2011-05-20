class DistrictController < ApplicationController
  layout "kvn_page"
  before_filter :never_for_subdomain
  before_filter :authenticate_user!

  def character_book_pages
    @districts = Government::SchoolDistrictKvn.all
  end

  def site
    @district = Government::SchoolDistrictKvn.find_by_nickname(params[:district_nickname])
  end

end
