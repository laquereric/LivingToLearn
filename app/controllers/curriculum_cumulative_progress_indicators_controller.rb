class CurriculumCumulativeProgressIndicatorsController < ApplicationController
  def index
  end

  def for_content_statement
    render :action => :index
  end


end
