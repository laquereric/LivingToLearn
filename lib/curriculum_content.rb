module CurriculumContent

  def ci=(v)
  end

  def ci
    self.curriculum_item
  end

  def parent
    return ci.parent.ti
  end

  def curriculum_class
    if ci.curriculum_name
      ci.curriculum_name.constantize
    else
      nil
    end
  end

  def children
    return ci.children.map{|child| child.ti}
  end

   def reduce_start_grades(start_grades)
p "reduce #{start_grades.inspect}"
     age_max = -1
     age_min = 1000
     start_grades.each{ |start_grade|
       if start_grade.is_a? Hash
         age_min= start_grade[:min].age if start_grade[:min].age > 0 and start_grade[:min].age < age_min
         age_max= start_grade[:max].age if start_grade[:max].age > age_max
       else
         age_min= start_grade.age if start_grade.age > 0 and start_grade.age < age_min
         age_max= start_grade.age if start_grade.age > age_max
       end
     }
     r= self.age_min_max_to_range( age_min, age_max )
     return r
   end

   def start_grade_search( depth = 0 )
     result= if self.ci.terminal
       -1
     else
       start_grades= self.children.map{ |child|
         child.start_grade
       }.compact
       self.reduce_start_grades(start_grades)
     end
     return result
   end

   def start_grade( depth = 0 )
     return nil if !self.curriculum_class or !self.curriculum_class.by_grade?

# Respond frm Cache
     result = if has_stored_start_grade?
       stored_start_grade
     elsif has_start_grade_stored_range?
       start_grade_stored_range

# Load Cache Immediately
     elsif self.respond_to?(:by_end_of_grade) and !self.by_end_of_grade.nil?
       store_start_grade_age(self.by_end_of_grade)

# Load Cache from iteration
     else
       store_start_grade_range( start_grade_search(depth+1) )
     end
  end

#########

  def has_start_grade_stored_range?
    return (!ci.min_by_end_of_grade_age.nil? and !ci.max_by_end_of_grade_age.nil?)
  end

  def age_min_max_to_range(min_age,max_age)
    return {
      :min => Curriculum::Grade.create(:age => min_age),
      :max => Curriculum::Grade.create(:age => max_age)
    }
  end

  def start_grade_stored_range
    return age_min_max_to_range(
      ci.min_by_end_of_grade_age,
      ci.max_by_end_of_grade_age
    )
  end

  def store_start_age_range( min_age, max_age )
    ci.min_by_end_of_grade_age= min_age
    ci.max_by_end_of_grade_age= max_age
    ci.save
    return start_grade_stored_range
  end

  def store_start_cc_grade_range( min_cc_grade, max_cc_grade )
    store_start_age_range(
      Curriculum::Grade.cc_grade_to_int(min_cc_grade),
      Curriculum::Grade.cc_grade_to_int(max_cc_grade)
    )
    return start_grade_stored_range
  end

  def store_start_grade_range( range )
    return self.store_start_age_range( range[:min].age, range[:max].age )
  end

#######

  def has_stored_start_grade?
    return !ci.by_end_of_grade_age.nil?
  end

  def stored_start_grade
    Curriculum::Grade.create(:age => ci.by_end_of_grade_age.to_i)
  end

  def store_start_grade_age(cc_grade)
    ci.by_end_of_grade_age= Curriculum::Grade.cc_grade_to_int(cc_grade)
    ci.save
    return stored_start_grade
  end

#################################

  def klassname
     self.class.to_s.split('::')[1]
  end

  def complexity
    self.root_ci.children.length
  end

  def span
    dlr = self.get_deadline_range
    return ( dlr[:max].age - dlr[:min].age )
  end

  def deadlines_relative_to( all_grades )
    all_grades.each.map { |grade|
      [ grade, Curriculum::Grade.deadline_relative_to( self.ci.sg , grade ) ]
    }
  end

end

