class ActivitiesController < ApplicationController

  before_filter :authenticate_user!

  def list
      @activities = Activity.sort_hier( current_user.activities )
      respond_to do |format|
        format.html
        format.iphone
      end
 end

  def start
    if user_signed_in?
      @activities = Activity.sort_hier( current_user.activities )
      respond_to do |format|
        format.html
        format.iphone
       end
     else
      render :text => "ActivitiesController.index user not logged in!"
    end
 end

  def show
    @activity = Activity.find(params[:id])
    authorize! :show,  @activity
    respond_to do |format|
      format.html
      format.iphone
    end
  end

  def new
    @activity= current_user.activities.new
    respond_to do |format|
      format.html
      format.iphone
    end
  end

  def new_sub
    @parent_activity= Activity.find( params[:parent_activity_id] )
    authorize! :update, @parent_activity
    @activity= current_user.activities.new
    @activity.parent_id= @parent_activity.id

    respond_to do |format|
      format.html { render :action => :new }
      format.iphone { render :action => :new }
    end
  end

  def create
#render :text => params.inspect

    @activity = current_user.activities.new( params[:activity] )
    respond_to do |format|
      if @activity.save
        format.html { redirect_to(:action=>:list,
          :notice => 'Activity was successfully created.')
        }
        format.iphone { redirect_to(:action=>:list,
          :notice => 'Activity was successfully created.')
        }
      else
        format.html { render :action => "new" }
        format.iphone { render :action => "new" }
      end
    end

  end

  def edit
    @activity = Activity.find( params[:id] )
    authorize! :update,  @activity
  end

  def delete
    @activity = Activity.find( params[:id] )
    authorize! :destroy,  @activity
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to( :action => :list ) }
      format.iphone { redirect_to( :action => :list ) }
    end
  end

  def update
    @activity = Activity.find(params[:id])
    authorize! :update,  @activity
    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to(:action => :list ,
          :notice => 'Activity was successfully updated.') }
        format.iphone { redirect_to(:action => :list ,
          :notice => 'Activity was successfully updated.') }
      else
        format.html { render :action => "edit" }
        format.iphone { render :action => "edit" }
      end
    end
  end

end
