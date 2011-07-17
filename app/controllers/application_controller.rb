class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :set_host_with_port

  before_filter :subdomains_parse
  before_filter :subdomain_parse

  before_filter :site_parse

  before_filter :allow_logins

  before_filter :set_timezone

  before_filter :set_iphone_format

  before_filter :set_screen

  def set_screen
    Screen.default= Screen.new
  end

  def is_iphone_request?
    request.user_agent =~ /(Mobile\/.+Safari)/
  end

  def set_iphone_format
    if is_iphone_request?
      request.format.instance_variable_set( '@symbol', :iphone )
    end
    @iphone_component = Touch::Layouts::Application
  end

  def default_url_options(options={})
    { :format => request.format.symbol }
  end

  def set_timezone
    Time.zone = "Eastern Time (US & Canada)"
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def set_host_with_port
    m= /localhost:(.*)/.match(request.raw_host_with_port)
    @host_with_port = if m
      @redirect_host= true
      "lvh.me:#{m[1]}"
    else
      if request.subdomain.present?
        subdomain_length = request.subdomain.length
        request.raw_host_with_port[ (subdomain_length+1)..-1]
      else
        request.raw_host_with_port
      end
    end
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
    #TODO revisit locked_subdomain
    # @subdomains = if user_signed_in? and current_user.locked_in_subdomain?
      #[ current_user.locked_subdomain ]
    #els
    @subdomains = if request.subdomain.present?
      rs = if User.is_mnemonic?( request.subdomain )
        [
          User.find_by_mnemonic( request.subdomain )
        ]
      else
        Subdomain.find_by_path( request.subdomain )
      end
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
      :subdomain_path => if @subdomain then  @subdomain.path else nil end,
      :marketing => if @marketing_context_type then @marketing_context_type.name else nil end,
      :service =>  @goto_service_symbol
    )
  end

end
