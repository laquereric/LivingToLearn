class CurriculumController < ApplicationController
  layout 'curriculum_navigator'

  def index
    @curriculum_item_root = Curriculum::CcMath.root_node

    #@curriculum_item_root = if params[:node_id] == 'root'
    #  "Curriculum::#{params[:name]}".constantize.root_node
    #else
    #  CurriculumItem.find_by_id(params[:node_id])
    #end

    @target = @curriculum_item_root.target
    @child_targets = @curriculum_item_root.children.map{ |n|
      n.target
    }.select{ |t|
      t.calc_by_end_of_grade != -2
    }.sort{ |x,y|
      x.calc_by_end_of_grade <=> y.calc_by_end_of_grade
    }
    #render :text => @child_targets.map{ |t| t.calc_by_end_of_grade }
    #render :layout => false
  end
end
