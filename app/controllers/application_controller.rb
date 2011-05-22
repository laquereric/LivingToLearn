class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :subdomain_parse

  def only_for_site
    if !Subdomain::Base.is_request_for_site?(request)
      redirect_to root_url()
    end
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

  def subdomain_parse
    @subdomains = if user_signed_in? and current_user.locked_in_subdomain?
      current_user.locked_subdomain
    elsif request.subdomain.present?
      r = Subdomain::Base.find_by_path(request.subdomain)
    else
      []
    end
    @subdomain = if @subdomains.length == 1 then @subdomains[0] else nil end
  end

###############
#
###############

end
