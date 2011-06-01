class CurriculumStrandsController < ApplicationController

  def index
  end

  def for_standard
    render :action => :index
  end

  def show
    render :action => :index
  end

end
