module CurriculumContent

  def get_deadline_range
     return nil if curriculum and !curriculum.by_grade?
     return cached_deadline_range() if has_cached_deadline_range?
p 'cache_miss'
     r = self.deadline_range
     return r if !has_cache_deadline_range_fields?
     self.cache_deadline_range(r)
     return r
  end

  def deadline_relative_to(grade)
     range = get_deadline_range()
     age = grade.age

     return nil if range.nil? or range[:min].nil? or range[:max].nil?

     r = if age and range and range[:min] and range[:min].age and age < range[:min].age then
       age - range[:min].age
     elsif  age and range and range[:max] and range[:max].age and age > range[:max].age then
       age - range[:max].age
     else
       0
     end

     return r
   end

   def has_cache_deadline_range_fields?
     ( self.respond_to? "min_by_end_of_grade_age" and self.respond_to? "max_by_end_of_grade_age" )
   end

   def has_cached_deadline_range?
     ( self.has_cache_deadline_range_fields? and !self.min_by_end_of_grade_age.nil? and !self.max_by_end_of_grade_age.nil? )
   end

   def cache_deadline_range(range)
      self.min_by_end_of_grade_age = if range and range[:min] and range[:min].age then
p 'cached'
       range[:min].age
     else
       -1
     end

     self.max_by_end_of_grade_age = if range and range[:max] and range[:max].age then
       range[:max].age
     else
       -1
     end

     self.save
   end

   def  has_deadlines?
     return true if !self.has_cache_deadline_range_fields?
     return !(self.min_by_end_of_grade_age == -1)
   end

   def clear_cached_deadline_range
     self.min_by_end_of_grade_age = nil
     self.max_by_end_of_grade_age = nil
     self.save
   end

   def cached_deadline_range
     {:min => Curriculum::Grade.create(:age => self.min_by_end_of_grade_age),
       :max =>  Curriculum::Grade.create(:age => self.max_by_end_of_grade_age)
     }
   end

   def start_grade_age
     if self.has_cache_deadline_range_fields? and self.min_by_end_of_grade_age
       self.min_by_end_of_grade_age.to_i
     elsif self.respond_to? :by_end_of_grade and self.by_end_of_grade
       self.by_end_of_grade.to_i
     else
       -1
     end
  end

  def klassname
     self.class.to_s.split('::')[1]
  end

  def root_node
    CurriculumItem.get_root_for_content(self)
  end

  def complexity
    self.root_node.children.length
  end

  def span
    dlr = self.get_deadline_range
    return ( dlr[:max].age - dlr[:min].age )
  end

  def curriculum
    #(self.respond_to? :curriculum_classname ? self.curriculum_classname.constantize : nil )
    if self.respond_to? :curriculum_classname then self.curriculum_classname.constantize else nil end
  end



end

