class Document::Reports::AllByGrade < Document::Reports::CcOverview
  cattr_accessor :target_grade

  def self.public_report_filename()
    File.join(self.public_directory, self.report_filename() )
  end

  def self.include?(object)
    return false if object.nil?
    return false if object.description == 'none'
    ref_to_deadline = Curriculum::Grade.deadline_relative_to( object.ci.sg , target_grade )
    return( !ref_to_deadline.nil? and ref_to_deadline > -2 and ref_to_deadline < 2 )
  end

  def self.get_data
    harray= []
    Curriculum::Root.curricula_classes.each{|curricula_class|
      curricula_class.get_objects{ |c_object|
      next if !self.include?(c_object)
p c_object
        harray << {
          :object => c_object,
          :level => Curriculum::Root.level_of(c_object)
        }
      }
    }
    return harray
  end

  def self.filename_base
    'CcByGrade'
  end

end

