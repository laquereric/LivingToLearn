class RegistrationsController < Devise::RegistrationsController
  def new
    @context = Context.find( params[:context_id] ) if params[:context_id]
    super
  end

  def create
    if params[:context]
      context = Context.find( params['context']['id'] )
      context.user_email = params['user']['email']
      context.save
    end
    super
  end
end

