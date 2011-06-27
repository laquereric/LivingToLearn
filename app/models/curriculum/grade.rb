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
      "preK"
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
      return nil
    elsif ['K'].include?(cc_grade)
      return 5
    else
      cc_grade.to_i + 5
    end
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
#begin
#  p "N r min:#{r[:min].age} r max:#{r[:max].age} co: #{curriculum_objects.inspect}"
#rescue
#end
    if curriculum_objects.is_a? Array and curriculum_objects.length > 1
#p "2 #{r.inspect}"
      result = self.deadline_range(curriculum_objects[0],r)
#p "1 result min:#{result[:min].age} r max:#{result[:max].age} co: #{curriculum_objects.inspect}"
      return self.deadline_range(curriculum_objects[1..-1],result)
    else
#p "3 #{r.inspect}"
      curriculum_object = if curriculum_objects.is_a? Array then
        curriculum_objects[0]
      else
        curriculum_objects
      end

      result = if !curriculum_object.is_a? Hash and curriculum_object.respond_to?(:by_end_of_grade)
        grade = self.create(:cc_grade=>curriculum_object.by_end_of_grade)
#p "- #{grade.inspect}"
        curriculum_object.by_end_of_grade
        { :min => grade , :max => grade }
      elsif curriculum_object.is_a? Hash
        curriculum_object
      else
        nil
      end

      if result
#p "4 #{r.inspect}"
        r[:min] = if r[:min].nil? or ( result[:min].age and result[:min].age < r[:min].age )
          result[:min]
        else
          r[:min]
        end
#p "5 #{r.inspect}"
        r[:max] = if r[:max].nil? or ( result[:max].age and result[:max].age > r[:max].age )
          result[:max]
        else
          r[:max]
        end
#p "6 #{r.inspect}"
      end
    end
    return r
  end

end
