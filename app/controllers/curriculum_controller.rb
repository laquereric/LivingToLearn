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

  def get_grades
    filtered_by_grade = false
    max_age = Curriculum::Grade::MaxAge
    min_age = 0
    if !params[:age].nil? and ( params[:age].to_i != Curriculum::Grade::MaxAge )
      filtered_by_grade= true
      target_age= params[:age].to_i
      max_age= target_age + 1
      min_age= target_age - 1
      min_age= 0 if min_age < 0
    end
    all_grades= Curriculum::Grade.age_range(min_age,max_age)
    return filtered_by_grade, all_grades,  Curriculum::Grade.create({:age=>target_age})
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
          r=(ref_to_deadline >= -1 and ref_to_deadline <= 1 )
          r
        end
      return r
  end

  def index()
    @curriculum_item = get_curriculum_item
    @filtered_by_grade, @all_grades, @target_grade= get_grades
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
  end

end
