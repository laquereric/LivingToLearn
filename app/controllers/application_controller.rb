class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :subdomain_parse

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
      subdomain_hash = {}
      valid = true
      request.subdomain.split('.').each{ |field|
        field_array = field.split('_')
        if Subdomain::Base.column_names.include?(field_array[0].to_s)
          subdomain_hash[field_array[0].to_sym] = field_array[1]
        else
          valid = false
        end
      }
      r = if valid then Subdomain::Base.find_by_hash(subdomain_hash) else [] end
    else
      []
    end
    @subdomain = if @subdomains.length == 1 then @subdomains[0] else nil end
  end

###############
#
################
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "devise_view"
    else
      "home"
    end
  end


end
