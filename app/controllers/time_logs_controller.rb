class TimeLogsController < ApplicationController

  before_filter :get_activity, :except => :open_index
  before_filter :authenticate_user!, :only => :open_index

  def get_activity
    @activity= Activity.find(params[:activity_id])
p "got activity #{@activity.inspect}"
    authorize! :show,  @activity
  end

  def index
    @time_logs= @activity.time_logs
  end

  def show
    @time_log = TimeLog.find(params[:id])
    @activity ||= @time_log.activity
    authorize! :show,  @time_log
  end

  def new
    @time_log = @activity.time_logs.new
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
    #authorize! :update,  @time_log
    @time_log = TimeLog.find( params[:id] )
  end

  def delete
#p "@activity.id #{@activity.id}"
    @time_log = TimeLog.find( params[:id] )
    #authorize! :destroy,  @time_log
    @time_log.destroy
    redirect_to( :action => :index )
#render :text=> 'tt'
  end

  def update
    @time_log = TimeLog.find(params[:id])
    @time_log.end_time ||= Time.now
    @activity ||= @time_log.activity
    authorize! :update,  @time_log
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


############
#
############

  def open_index
    @time_logs= current_user.open_time_logs
  end

############
#
############

  def start
    @activity= Activity.find(params[:activity_id])
    authorize! :update, @activity
    @time_log= @activity.time_logs.new
    @time_log.user_id= current_user.id
    @time_log.start_time= Time.now.localtime
    @time_log.save

    respond_to do |format|
      format.html { render :action => :doing } # show.html.erb
    end
  end

  def continue
    @time_log = TimeLog.find( params[:time_log_id] )
    @activity = @time_log.activity
    respond_to do |format|
      format.html { render :action => :doing } # show.html.erb
    end
  end

  def stop
    @time_log = TimeLog.find( params[:time_log_id] )
    @time_log.end_time ||= Time.now
    @time_log.save
    respond_to do |format|
      format.html { redirect_to :action= > :index } # show.html.erb
    end
  end

end
