class CurriculumController < ApplicationController
 
  def district_character
    @district = Government::SchoolDistrictKvn.find_by_nickname(params[:district_nickname])
    @curriculum_content_areas = [ Curriculum::ContentArea.find_by_code("Character_JI") ]
  end

  def school_character
    @district = Government::SchoolDistrictKvn.find_by_nickname(params[:district_nickname])
    @school =  @district.schools.select{ |school| 
      school.government_district_id == @district.id
    }.first
    @curriculum_content_areas = [ Curriculum::ContentArea.find_by_code("Character_JI") ]
  end

end
