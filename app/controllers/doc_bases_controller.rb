class DocBasesController < ApplicationController
  # GET /doc_bases
  # GET /doc_bases.xml
  def index
    @doc_bases = DocBase.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @doc_bases }
    end
  end

  # GET /doc_bases/1
  # GET /doc_bases/1.xml
  def show
    @doc_basis = DocBase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @doc_basis }
    end
  end

  # GET /doc_bases/new
  # GET /doc_bases/new.xml
  def new
    @doc_basis = DocBase.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @doc_basis }
    end
  end

  # GET /doc_bases/1/edit
  def edit
    @doc_basis = DocBase.find(params[:id])
  end

  # POST /doc_bases
  # POST /doc_bases.xml
  def create
    @doc_basis = DocBase.new(params[:doc_basis])

    respond_to do |format|
      if @doc_basis.save
        format.html { redirect_to(@doc_basis, :notice => 'Doc base was successfully created.') }
        format.xml  { render :xml => @doc_basis, :status => :created, :location => @doc_basis }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @doc_basis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /doc_bases/1
  # PUT /doc_bases/1.xml
  def update
    @doc_basis = DocBase.find(params[:id])

    respond_to do |format|
      if @doc_basis.update_attributes(params[:doc_basis])
        format.html { redirect_to(@doc_basis, :notice => 'Doc base was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @doc_basis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /doc_bases/1
  # DELETE /doc_bases/1.xml
  def destroy
    @doc_basis = DocBase.find(params[:id])
    @doc_basis.destroy

    respond_to do |format|
      format.html { redirect_to(doc_bases_url) }
      format.xml  { head :ok }
    end
  end
end
