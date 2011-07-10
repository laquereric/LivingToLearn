class TimeLogsController < ApplicationController

  before_filter :get_activity
  def get_activity
    @activity = Activity.find(params[:activity_id])
  end

  def index
    @time_logs= @activity.time_logs
  end

  def show
    @time_log = TimeLog.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    Time.zone = "Eastern Time (US & Canada)"
    @time_log = TimeLog.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @time_log = @activity.time_logs.create( params[:time_log] )
    respond_to do |format|
      if @time_log.save
        format.html { 
          redirect_to(
            activity_time_log_path(
              @activity.id,@time_log.id
            ),
            :notice => 'TimeLog was successfully created.'
          )
        }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    Time.zone = "Eastern Time (US & Canada)"
    @time_log = TimeLog.find( params[:id] )
  end

  def destroy
    @time_log = TimeLog.find( params[:id] )
    @time_log.destroy
    respond_to do |format|
      format.html { redirect_to(
        activity_time_logs_path( @activity.id )
      ) }
    end
  end

  def update
    @time_log = TimeLog.find(params[:id])
    respond_to do |format|
      if @time_log.update_attributes(params[:time_log])
        format.html { redirect_to( 
          activity_time_log_path(
            @activity.id,
            @time_log.id
          ),
          :notice => 'TimeLog was successfully updated.')
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end