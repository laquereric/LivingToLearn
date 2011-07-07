class Curriculum::Grade

  attr_accessor :age

  MinAge = 0
  MaxAge = 25

  def self.age_to_initials(age)
     self.create({
        :age => age
      }).initials
  end

  def cc_grade()
    if self.age < 4 then
      "#{age}yo"
    elsif self.age == 4 then
      "PreK"
    elsif self.age == 5 then
      "K"
    elsif self.age >= 6 and self.age <= 17 then
      "#{age-5}"
    elsif self.age >= 18 and self.age <= 21 then
      ['Fm','Sm','Jr','Sr'][self.age-18]
    elsif self.age >= 22 and self.age <= 25 then
      ['g1','g2','g3','g4'][self.age-22]
    else
      'Ad'
    end
  end

  def self.create(config)
    g = Curriculum::Grade.new
    g.age =  if config[:cc_grade]
      cc_grade_to_int(config[:cc_grade])
    else
      config[:age]
    end
    return g
  end

  def self.cc_grade_to_int(cc_grade)
    if ['A','F','G','N','S'].include?(cc_grade)
      return 17
    elsif ['K'].include?(cc_grade)
      return 5
    elsif ['PreK'].include?(cc_grade)
      return 4
    else
      cc_grade.to_i + 5
    end
  end

  def self.age_range(min,max)
    (min..max).map{ |age|
      self.create({
        :age => age
      })
    }
  end

  def self.all()
    (MinAge..MaxAge).map{ |age|
      self.create({
        :age => age
      })
    }
  end

  def self.deadline_range(curriculum_objects,previous_result=nil)
    r = previous_result
    r ||= { :min => nil , :max => nil}
    if curriculum_objects.is_a? Array and curriculum_objects.length > 1
      result = self.deadline_range(curriculum_objects[0],r)
      return self.deadline_range(curriculum_objects[1..-1],result)
    else
      curriculum_object = if curriculum_objects.is_a? Array then
        curriculum_objects[0]
      else
        curriculum_objects
      end

      result = if !curriculum_object.is_a? Hash and curriculum_object.respond_to?(:by_end_of_grade)
        grade = self.create(:cc_grade=>curriculum_object.by_end_of_grade)
        curriculum_object.by_end_of_grade
        { :min => grade , :max => grade }
      elsif curriculum_object.is_a? Hash
        curriculum_object
      else
        nil
      end

      if result
        r[:min] = if r[:min].nil? or
          ( !r[:min].nil? and     !result[:min].nil? and
            !r[:min].age.nil? and !result[:min].age.nil? and
            result[:min].age < r[:min].age
          )
          result[:min]
        else
          r[:min]
        end
        r[:max] = if r[:max].nil? or
          ( !r[:max].nil? and     !result[:max].nil? and
            !r[:max].age.nil? and !result[:max].age.nil? and
            result[:max].age > r[:max].age
          )
          result[:max]
        else
          r[:max]
        end
      end
    end
    return r
  end

  def self.deadline_relative_to(child_start_grade,grade)
    r= if child_start_grade.nil? or child_start_grade == -1
      nil
    elsif child_start_grade.is_a? Hash
      range= child_start_grade
      r2= if range[:min] and range[:min].age and grade.age < range[:min].age then
        grade.age - range[:min].age
      elsif range[:max] and range[:max].age and grade.age > range[:max].age then
        grade.age - range[:max].age
      else
        0
      end
    else
      (grade.age - child_start_grade.age)
    end
    return r
  end

end
