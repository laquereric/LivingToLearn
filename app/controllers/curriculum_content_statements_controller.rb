class CurriculumContentStatementsController < ApplicationController

  def index
  end

  def show
    render :action => :index
  end

  def for_strand
    render :action => :index
  end

end
