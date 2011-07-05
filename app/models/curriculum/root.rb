class Curriculum::Root < ActiveRecord::Base
  include CurriculumContent

  set_table_name :curriculum_roots

  def curriculum_class
    nil
  end

  def is_root?
    true
  end

  def name
    "Root"
  end

  def start_grade
    nil
  end
#########################
# utility
##########################

  def self.curriculum_content_names

    content= [
      'ContentArea',
      'Standard',
      'Strand',
      'ContentStatement',
      'CumulativeProgressIndicator'
    ].map{ |n|
      "Curriculum::#{n}"
    }
    return content
  end

  def self.curriculum_content_classes
    return curriculum_content_names.map{ |cn|
      cn.constantize
    }
  end

##################

  def self.curricula_names
    return [
      'CharacterJi',
      'CcMath',
      'CcReading',
      'NjS21clc'
    ].map{ |n|
      "Curriculum::#{n}"
    }
  end

  def self.curricula_classes
    return curricula_names.map{ |cn|
      cn.constantize
    }
  end

###############
  def self.total_record_count()
    sum = 0
    curriculum_classes.each{ |klass|
      sum += klass.count
    }
    return sum
  end

  def self.purge
    self.curriculum_content_classes.each{ |klass|
      klass.delete_all
    }
  end

  def self.load_database_from_csvs
    Curriculum::Root.purge
    self.curricula_classes.each{ |klass|
      p "Loading #{klass.to_s} from csv"
      klass.load_database_from_csv
    }
    CurriculumItem.update_caches
  end

  def self.all_curricula_classes
    return [self.curricula_classes , self.curriculum_content_classes, 'CurriculumItem'.constantize].flatten
  end

#############
  def self.find_by_full_code(code)
    r= nil
    curriculum_content_classes.map{ |klass|
      break if !r.nil?
      r= klass.find_by_full_code(code)
    }
    return r
  end
end
