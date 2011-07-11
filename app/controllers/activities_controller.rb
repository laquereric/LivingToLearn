class ActivitiesController < ApplicationController

  before_filter :authenticate_user!

  def index
    if user_signed_in?
      @activities = current_user.activities
      render
    else
      render :text => "ActivitiesController.index user not logged in!"
    end
  end

  def show
    @activity = Activity.find(params[:id])
    authorize! :show,  @activity
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @activity= current_user.activities.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @activity = current_user.activities.new( params[:activity] )
    respond_to do |format|
      if @activity.save
        format.html { redirect_to(@activity,
          :notice => 'Activity was successfully created.')
        }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @activity = Activity.find( params[:id] )
    authorize! :update,  @activity
  end

  def destroy
    @activity = Activity.find( params[:id] )
    authorize! :destroy,  @activity
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to( activities_url ) }
    end
  end

  def update
    @activity = Activity.find(params[:id])
    authorize! :update,  @activity
    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to(@activity,
          :notice => 'Activity was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
