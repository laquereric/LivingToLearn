class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :subdomains_parse
  before_filter :subdomain_parse
  before_filter :site_parse

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
      r = Subdomain.find_by_path(request.subdomain)
    else
      []
    end
  end

  def subdomain_parse
    @subdomain = if @subdomains.length == 1 then @subdomains[0] else nil end
  end

  def site_parse
    @for_site = Subdomain.is_request_for_site?(request)
  end


###############
#
###############

end
