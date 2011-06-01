class CurriculumStandardsController < ApplicationController

  def index
  end

  def for_content_area
    render :action => :index
  end

  def show
    render :action => :index
  end

end
