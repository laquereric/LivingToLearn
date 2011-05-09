class CareerController < CurriculumControllerBase
  layout "kvn_page"

#############
#
##############

  def lookup_curriculum_content_areas
    @curriculum_content_areas = [Curriculum::CareersAdhoc.get_content_area]
  end

  def district
  end

  def school
  end

  def standard
  end

  def strand
  end

end
