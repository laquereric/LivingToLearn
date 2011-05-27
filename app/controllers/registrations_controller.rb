class RegistrationsController < Devise::RegistrationsController
  def new
p "RegistrationsController got it! #{params.inspect}"
    @context = Context.find( params[:context_id] ) if params[:context_id]
    super
  end
end

