class Curriculum::CharacterJi < Curriculum::ParseCsv

############
# Lower Level
#############

  def self.filename
    File.join(Rails.root,'data','character_ji.csv')
  end

  def self.content_area_key
    'CharacterJi'
  end

  def self.strand__calc_full_code(spec)
    "#{spec[:curriculum_content_area].code} #{spec[:curriculum_standard].code}.#{spec[:curriculum_strand].code}"
  end

  def self.get_objects(&block)
    code = self.content_area_key
    content_area = Curriculum::ContentArea.find_by_code(code)
    return nil if content_area.nil?
    yield( content_area )
    content_area = Curriculum::ContentArea.find_by_code(code)
    content_area.curriculum_standards_sorted_by_code.each{ |standard|
      yield( standard )
      standard.curriculum_strands_sorted_by_code.each{ |strand|
        yield( strand )
        strand.curriculum_content_statements.each{ |content_statement|
          yield( content_statement )
        }
      }
    }
  end

end

