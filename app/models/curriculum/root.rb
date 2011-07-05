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

  def self.curriculum_class_names
    return [
      'ContentArea',
      'Standard',
      'Strand',
      'ContentStatement',
      'CumulativeProgressIndicator'
    ].map{ |n|
      "Curriculum::#{n}"
    }
  end

  def self.curriculum_classes
    return curriculum_class_names.map{ |cn|
      cn.constantize
    }
  end

  def self.purge
    curriculum_classes.each{ |klass|
      klass.delete_all
    }
  end

  def self.total_record_count()
    sum = 0
    curriculum_classes.each{ |klass|
      sum += klass.count
    }
    return sum
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
    return curriculum_class_names.map{ |cn|
      cn.constantize
    }
  end

  def self.load_database_from_csvs
    Curriculum::Root.purge
    curricula_classes.each{ |klass|
      klass.load_database_from_csv
    }
    CurriculumItem.update_caches
  end

#############

end
