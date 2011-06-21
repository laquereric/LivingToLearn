class Document::Reports::CharacterJiOverview < Document::Reports::CcOverview

  def self.public_report_filename()
    File.join(self.public_directory, self.report_filename() )
  end

  def self.curriculum_class
    Curriculum::CharacterJi
  end

  def self.filename_base
    'CharacterJiOverview'
  end

  def self.get_objects(content_area_class,&block)
    code = content_area_class.content_area_key
    content_area = Curriculum::ContentArea.find_by_code(code)
    return nil if content_area.nil?
    yield( content_area )
    content_area = Curriculum::ContentArea.find_by_code(code)
    content_area.curriculum_standards_sorted_by_code.each{ |standard|
      yield( standard )
      # By Code
      standard.curriculum_strands_sorted_by_code.each{ |strand|
        yield( strand )
        strand.curriculum_content_statements_sorted_by_grade_and_code.each{ |content_statement|
          yield( content_statement )
          content_statement.cumulative_progress_indicators.each{ |cumulative_progress_indicator|
            yield( cumulative_progress_indicator )
          }
        }
      }
    }
  end

end

