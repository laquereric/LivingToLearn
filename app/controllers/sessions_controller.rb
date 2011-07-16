class SessionsController < Devise::SessionsController
  def new
      respond_to do |format|
        format.html { render :template=>'users/sessions/new'}
        format.iphone { render :template=>'users/sessions/new'}
      end
  end
  def after_sign_in_path_for(resource_or_scope)
     '/'
  end
end

