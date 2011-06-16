class EducationalResourcesController < ApplicationController

  def index
    @educational_resources = EducationalResource.all
  end

end
