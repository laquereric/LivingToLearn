class Curriculum::ParseCsv < Curriculum::Base

  require 'csv'

  cattr_accessor :raw_csv_headers
  cattr_accessor :field_csv_headers

  cattr_accessor :records
  cattr_accessor :content_areas
  cattr_accessor :standards
  cattr_accessor :strands

  attr_accessor :content_area
  attr_accessor :standard
  attr_accessor :strand
  attr_accessor :split
  attr_accessor :by_end_of_grade
  attr_accessor :content_statement
  attr_accessor :cpi_num
  attr_accessor :cumulative_progress_indicator

###############
# Lower Level
###############
  def self.filename
    p "Must Overide self.filename"
    1/0
  end

  def self.clean_row(row)
    [0..10].each{ |col_num|
      row[col_num] = nil if !row[col_num].nil? and row[col_num].to_s.gsub(' ','').length == 0
    }
    return row
  end

  def self.each_csv_row
    line_number = 0
    CSV::Reader.parse(File.open(self.filename, 'rb')) do |row|
      yield(line_number,self.clean_row(row) )
      line_number +=1
    end
  end

#########################
# CSV Import methods
##########################

  def self.to_key_pair(raw_value)
    return nil if raw_value.nil? or raw_value.gsub(' ','').length == 0
    if ( srw = raw_value.split('__') ).length == 2
      return srw[0], srw[1]
    else
      return nil
    end
  end

  def self.clean(raw_cell)
    #return nil if raw.nil?
#p raw_cell.class
    raw = raw_cell.to_s
    raw.gsub!("\""," ")
    raw.gsub!("#{[160].pack('U')}"," ")
    raw.strip!
    return raw
  end

  def self.show_csv_data
    self.each_csv_row{ |line_number,row|
      p row
    }
  end

  def self.get_csv_data
    content_area = nil
    standard = nil
    strand = nil
    content_statement = nil
    cumulative_progress_indicator = nil

    by_end_of_grade_column = nil

    self.each_csv_row{ |line_number,raw_row|

      row = self.clean_row(raw_row)

      if line_number != 0
        content_area_column = to_key_pair( row[0] )
        if content_area_column and content_area_column.length>0
          content_area = Curriculum::ContentArea.create({
            :code => content_area_column[0],
            :name => content_area_column[1]
          })
        end

        standard_column = to_key_pair( row[1] )
        if standard_column and standard_column[1] and standard_column[1].length>0
          standard = content_area.find_or_create_standard({
            :code => standard_column[0],
            :name => standard_column[1],
            :curriculum_content_area_id => content_area.id
          })
        end

        strand_column = to_key_pair( row[2] )
        if strand_column and strand_column[0] and strand_column[0].length > 0
          strand = standard.find_or_create_strand({
            :code => strand_column[0],
            :name => strand_column[1],
            :curriculum_standard_id => standard.id
          })
        end

        split_column = row[3]
        by_end_of_grade_column = row[4] if !row[4].nil? and row[4].length>0

        content_statement_column = row[5]
        content_statement_column.strip! if content_statement_column
        if content_statement_column and content_statement_column.length>0
          content_statement = strand.find_or_create_content_statement({
            #:by_end_of_grade => by_end_of_grade_column,
            :description => content_statement_column,
            :curriculum_strand_id => strand.id
          })
        end

        cpi_num_column = row[6]
        cumulative_progress_indicator_column = row[7]
        if cpi_num_column and cpi_num_column.length>0 then
          cumulative_progress_indicator = content_statement.find_or_create_cumulative_progress_indicator({
            :by_end_of_grade => by_end_of_grade_column,
            :code => cpi_num_column,
            :description => cumulative_progress_indicator_column,
            :curriculum_content_statement_id => content_statement.id
          })
        end

      end
    }
    return
  end

#########################
# utility
##########################

  def self.destroy_records(keys)
    keys.each{ |content_area_key|
      content_area = Curriculum::ContentArea.find_by_code(content_area_key)
      content_area.destroy if content_area
    }
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
        strand.curriculum_content_statements_sorted_by_grade_and_code.each{ |content_statement|
          yield( content_statement )
          content_statement.cumulative_progress_indicators.each{ |cumulative_progress_indicator|
            yield( cumulative_progress_indicator )
          }
        }
      }
    }
  end

###########
# Root Node
############

###########
# Load database from csv
############

  def self.load_database_from_csv
    CurriculumItem.remove_nodes_for_curriculum(self)

    p "Before destroy : #{self.total_record_count()}"
    self.destroy_records(self.content_area_key)
    p "After destroy : #{self.total_record_count()}"

    self.get_csv_data

    p "After Add : #{self.total_record_count()}"

    CurriculumItem.add_nodes_for_curriculum(self)

    return
  end

end

