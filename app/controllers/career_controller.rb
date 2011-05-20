class CareerController < CurriculumControllerBase
  layout "kvn_page"
  before_filter :never_for_subdomain
  before_filter :authenticate_user!

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
