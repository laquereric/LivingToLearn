class MarketingContextTypesController < ApplicationController
  
  def new
    @marketing_context_type = MarketingContextType.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def show
    @marketing_context_type = MarketingContextType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @marketing_context_type = MarketingContextType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def update
    @marketing_context_type = MarketingContextType.find(params[:id])
 
    respond_to do |format|
      if @marketing_context_type.update_attributes(params[:marketing_context_type])
        format.html { redirect_to(@marketing_context_type,
                    :notice => 'MarketingContextType was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def create
    @marketing_context_type = MarketingContextType.new(params[:marketing_context_type])

    respond_to do |format|
      if @marketing_context_type.save
        format.html { redirect_to(@marketing_context_type,
                    :notice => 'MarketingContextType was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @marketing_context_type = MarketingContextType.find(params[:id])
    @marketing_context_type.destroy

    respond_to do |format|
      format.html { redirect_to( :action => :index ) }
    end
  end

  def index
    @marketing_context_types = MarketingContextType.all
  end

end
