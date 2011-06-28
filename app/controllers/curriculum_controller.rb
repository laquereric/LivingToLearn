class CurriculumController < ApplicationController

  def root
    params[:name] = 'root'
    self.index
    render :action => :index
  end

  def complete(h)
    h[:terminal]= h[:node].children.length == 0 ? true : false

    #TODO why not? h[:target] ||= h[:node].target

    klass = h[:node].target_node_klass_name.constantize
    h[:target] = klass.find(h[:node].target_node_object_id)

    h[:name] = h[:target].name
    h[:name] ||= h[:target].description
    h[:name] ||= h[:target].code

    h[:name] = 'Curricula' if  h[:name] == 'Root'

    return h
  end

  def index

    @center = if params[:name] == 'root'
      node = CurriculumItem.root
      { :node => node, :target => Curriculum::Root.first }
    elsif params[:node_id] == 'root'
      curriculum_klass = "Curriculum::#{params[:name]}".constantize
      node = curriculum_klass.root_node
      { :node => node }
    else
      node = CurriculumItem.find_by_id(params[:node_id])
      { :node => node }
    end

    self.complete(@center)

    @children = @center[:node].children.map{ |node|
      self.complete( { :node => node } )
    }.select{ |t|
      t[:target].has_deadlines?
    }.sort{ |x,y|
      x[:target].start_grade_age*100 + x[:target].span <=> y[:target].start_grade_age*100 + y[:target].span
    }.each{|h|
      h[:name] = h[:target].name
      h[:name] ||= h[:target].description
      h[:name] ||= h[:target].code
    }

   @parent= complete ( {:node => @center[:node].parent } )  if !(@center[:node].is_root?)
   @grand_parent= complete ( {:node => @parent[:node].parent } ) if @parent and !(@parent[:node].is_root?)


    @great_grand_parent = if @grand_parent and !(@grand_parent[:node].is_root?)
      complete ( {:node => @grand_parent[:node].parent } )
    end

    @great_great_grand_parent = if @great_grand_parent and !(@great_grand_parent[:node].is_root?)
      complete ( {:node => @great_grand_parent[:node].parent } )
    end

    @all_grades = Curriculum::Grade.all

    #render :text => @parent.inspect
    #render :text => @center[:target].deadline_relative_to(Curriculum::Grade.create(:cc_grade=>'1'))
    #render :text => @children[0][:target].deadline_relative_to(Curriculum::Grade.create(:cc_grade=>'K'))
    #render :text => @center.inspect
    #render :layout => false
  end
end