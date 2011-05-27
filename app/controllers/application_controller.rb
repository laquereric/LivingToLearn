class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :subdomains_parse
  before_filter :subdomain_parse
  before_filter :site_parse

  before_filter :allow_logins

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def allow_logins
    @user_screen = ( ["devise/registrations","devise/sessions"].include?( params[:controller] ) )
    @allow_logins = true
    @allow_multi_contexts = false
  end

  layout :choose_layout

  def choose_layout()
    Style.choose_layout(@for_site,@subdomain)
  end

  def only_for_subdomain
    if @subdomain.nil?
      redirect_to root_url(:host=> [request.domain, request.port_string].join )
    end
  end

  def never_for_subdomain
    if !@subdomain.nil?
      redirect_to root_url(:host=> [request.domain, request.port_string].join )
    end
  end

####################
#
####################

  def subdomains_parse
    @subdomains = if user_signed_in? and current_user.locked_in_subdomain?
      current_user.locked_subdomain
    elsif request.subdomain.present?
      rs = Subdomain.find_by_path(request.subdomain)
    else
      []
    end
  end

  def subdomain_parse
    @subdomain = if @subdomains.length >= 1 then @subdomains[0] else nil end
  end

  def site_parse
    @for_site = Subdomain.is_request_for_site?(request)
  end

  def store_context
    @context = Context.create(
      :user_email => if current_user then current_user.email.to_s else nil end,
      :topic => @goto_topic_symbol,
      :marketing => @marketing_context_type,
      :service =>  @goto_service_symbol
    )
  end
###############
#
###############

end
