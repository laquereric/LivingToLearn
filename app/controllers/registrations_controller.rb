class RegistrationsController < Devise::RegistrationsController
  def new
    @context = Context.find( params[:context_id] ) if params[:context_id]
    super
  end

  def create
    @user = User.new(params[:user])
    #if 
    @user.save!
p "@user: #{@user.inspect}"
      #flash[:notice] = "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
      #redirect_to root_url
      redirect_to( { :controller => :sessions, :action => :create } )
    #else
    #  render :action => :new
    #end
  end
=begin
  def create
    if params[:context]
      context = Context.find( params['context']['id'] )
      context.user_email = params['user']['email']
      context.at_registration = true
      context.save
    end
    #super
    redirect_to '/'
  end
=end

end

