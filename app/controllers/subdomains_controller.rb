class SubdomainsController < ApplicationController
  load_and_authorize_resource

  def index
    @subdomains = Subdomain.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subdomain }
    end
  end

  def new
    @subdomain = Subdomain.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subdomain}
    end
  end

  def create
    @subdomain= Subdomain.new(params[:site_content])

    respond_to do |format|
      if @subdomain.save
        format.html { redirect_to(@site_content,
                    :notice => 'Site Content was successfully created.') }
        format.xml  { render :xml => @site_content,
                    :status => :created, :location => @subdomain}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_content.errors,
                    :status => :unprocessable_entity }
      end
    end
  end

  def show
    @subdomain = Subdomain.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subdomain}
    end
  end

  def destroy
    @subdomain = Subdomain.find(params[:id])
    @subdomain.destroy

    respond_to do |format|
      format.html { redirect_to(subdomains_url) }
      format.xml  { head :ok }
    end
  end

  def edit
    @subdomain= Subdomain.find(params[:id])
  end

  def update
    @subdomain= Subdomain.find(params[:id])

    respond_to do |format|
      if @site_content.update_attributes(params[:site_content])
        format.html { redirect_to(@site_content,
                    :notice => 'Site Content was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_content.errors,
                    :status => :unprocessable_entity }
      end
    end
  end

end
