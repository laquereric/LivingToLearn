class SiteContentsController < ApplicationController
  #before_filter :authenticate_user!

  def index
    @site_contents = SiteContent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def new
    @site_content = SiteContent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_content }
    end
  end

  def create
    @site_content = SiteContent.new(params[:site_content])

    respond_to do |format|
      if @site_content.save
        format.html { redirect_to(@site_content,
                    :notice => 'Site Content was successfully created.') }
        format.xml  { render :xml => @site_content,
                    :status => :created, :location => @site_content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_content.errors,
                    :status => :unprocessable_entity }
      end
    end
  end

  def show
    @site_content = SiteContent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_content }
    end
  end

  def destroy
    @site_content = SiteContent.find(params[:id])
    @site_content.destroy

    respond_to do |format|
      format.html { redirect_to(site_contents_url) }
      format.xml  { head :ok }
    end
  end

  def edit
    @site_content = SiteContent.find(params[:id])
  end

  def update
    @site_content = SiteContent.find(params[:id])

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
