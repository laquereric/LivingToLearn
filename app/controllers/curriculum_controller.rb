class CurriculumController < ApplicationController
  layout 'curriculum_navigator'

  def index
    @center = if params[:node_id] == 'root'
      curriculum_klass = "Curriculum::#{params[:name]}".constantize
      node = curriculum_klass.root_node
      { :node => node, :target => node.target }
    else
      node = CurriculumItem.find_by_id(params[:node_id])
      { :node => node, :target => node.target }
    end
    @center[:name] = @center[:target].name
    @center[:name] ||= @center[:target].description
    @center[:name] ||= @center[:target].code

    @parent = if (@center[:node].is_root?)
      nil
    else
      node = @center[:node].parent
      #target = node.target
      klass= node.target_node_klass_name.constantize
      target = klass.find(node.target_node_object_id)
      name   = target.name
      name ||= target.description
      name ||= target.code
      {:node => node, :target => target, :name => name }
    end

    @children = @center[:node].children.map{ |n|
      { :node => n, :target => n.target }
    }.select{ |t|
      t[:target].has_deadlines?
    #}.sort{ |x,y|
    #  x[:target].calc_by_end_of_grade <=> y[:target].calc_by_end_of_grade
    }.each{|h|
      h[:name] = h[:target].name
      h[:name] ||= h[:target].description
      h[:name] ||= h[:target].code
    }

    @all_grades = Curriculum::Grade.all

    #render :text => @parent.inspect
    #render :text => @center.inspect
    #render :layout => false
  end
end
