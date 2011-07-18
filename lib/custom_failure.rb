class CustomFailure < Devise::FailureApp
  def redirect(format='html')
p "CustomFailure redirect"
    store_location!
    flash[:alert] = i18n_message unless flash[:notice]

    if i18n_message == I18n.t("devise.failure.unconfirmed")
      redirect_to new_user_confirmation_path  :format => format
    # other specific redirects go here
    else
      redirect_to new_user_session_path :format => format
    end
  end

  def respond
p "CustomFailure respond #{params[:format]}"
    redirect( params[:format] )
  end

end

