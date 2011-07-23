class CurriculumController < ApplicationController

  def get_curriculum_item
    ci = if params[:node_id].nil?
      CurriculumItem.root
    else
      CurriculumItem.find(params[:node_id])
    end

    # Get everthing needed here!
    #p 'ci.ti'
    r= ci.ti #; p r.inspect

    #p 'ci.as'
    r= ci.as #; p r.inspect

    #p 'ci.sg'
    r= ci.sg #; p r.inspect

    #p 'ci.ch'
    r= ci.ch #; p r.inspect

    ci.ch.each{ |ach|
      r= ach.sg
      p r.inspect
    }
    return ci
  end

  def display_by_grade?(child)
        start_grade= child.ti.start_grade
        r2 = if !start_grade.is_a? Hash and start_grade.age <= 0
          false
        elsif start_grade.is_a? Hash and start_grade[:min].age == 1000
          false
        elsif !@filtered_by_grade
          true
        else
          ref_to_deadline= Curriculum::Grade.deadline_relative_to( child.sg , @target_grade )
p "#{child.id} #{ref_to_deadline}"
          r=(ref_to_deadline > -3 and ref_to_deadline < 3)
          r
        end
      return r
  end

  def index()
    @curriculum_item = get_curriculum_item
    @filtered_by_grade, @all_grades, @target_grade=
      Curriculum::Grade.get_grades_range( params[:age] )

    all_children = @curriculum_item.ch.sort{ |x,y|
      x.sort_term <=> y.sort_term
    }
    @displayed_children = if @curriculum_item.ti.curriculum_class.nil?
      all_children
    elsif  @curriculum_item.ti.curriculum_class.by_grade? and @filtered_by_grade
      all_children.select{ |child|
        self. display_by_grade?(child)
      }
    else
      all_children
    end
      respond_to do |format|
        format.html
        format.iphone
      end

  end

end
