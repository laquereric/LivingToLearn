require 'csv'

class Curriculum::CcParse < Curriculum::Base

#ID => K.RL.2
#Category => Reading Literature
#Sub Category => Key Ideas and Details
#State Standard => With prompting and support, ask and answer questions about key details in a text.

  # :content_area               # CC_Reading
  # :standard                   # Category - Reading Literature
  # :strand                     # SubCategory - Key Ideas and Details
  # :content_statement          # (parsed from id)- by grade K

  # :cpi_num #(parsed from id) 2
  # :cumulative_progress_indicator #State Standard

###########
# Lower Level
###########

  def self.filename
    p "Must override 'self.filename' in subclass"
 end

  def self.clean_row(row)
    [0..3].each{ |col_num|
      row[col_num] = nil if !row[col_num].nil? and row[col_num].to_s.gsub(' ','').length == 0
    }
    return row
  end

  def self.content_area_key
    p "Must override 'content_area_key' in subclass"
  end

  def self.each_csv_row
    line_number = 0
    CSV::Reader.parse(File.open(self.filename, 'rb')) do |row|
      yield(line_number,self.clean_row(row) )
      line_number += 1
    end
  end

  def self.show_csv_data
    self.each_csv_row{ |line_number,row|
      p row
    }
  end

  def self.parse_id(cc_id)
    # ex "11-12.WHST.10"
    ar = cc_id.split('.')
    cpi_num = ar[2]
    cpi_num<< ar[3] if ar.length>3
    return {
      :by_grade => ar[0],
      :standard_code => ar[1],
      :cpi_num => cpi_num
    }
  end

  def self.parse_row(row)
    #ID Category	Sub Category	State Standard
    r = parse_id( row[0] )
    r[:category] = row[1]
    r[:sub_category] = row[2]
    r[:state_standard] = row[3]
    return r
  end

########
#
########

  def self.destroy_existing
    ca_record = Curriculum::ContentArea.find_by_code(self.content_area_key)
    if ca_record
      p "destroying .curriculum_standards for Curriculum::ContentArea #{ca_record.code}"
      ca_record.curriculum_standards.each{ |r|
       p "code = #{r.code}"
       r.destroy_wrapper
      }
      p "destroying Curriculum::ContentArea #{ca_record.code}"
      ca_record.destroy
    end
  end

  def self.get_csv_data
    content_area = Curriculum::ContentArea.create({
      :code => self.content_area_key
    })
    standard = nil
    strand = nil
    last_strand_id = nil
    content_statement = nil
    last_parsed_row =  nil
    parsed_row =  nil
    self.each_csv_row{ |line_number,raw_row|
      break if raw_row[0].nil?

      row = self.clean_row(raw_row)

      if line_number != 0

        last_parsed_row = parsed_row
        parsed_row = self.parse_row(raw_row)
p parsed_row

        standard = content_area.find_or_create_standard({
            :code => parsed_row[:standard_code],
            :name => parsed_row[:category],
            :curriculum_content_area_id => content_area.id
        })

        strand = standard.find_or_create_strand({
              #:code => parsed_row[:cpi_num],
              :name =>  parsed_row[:sub_category],
              :curriculum_standard_id => standard.id
        })

        content_statement = Curriculum::ContentStatement.create({
            :curriculum_strand_id => strand.id,
            :code =>  parsed_row[:cpi_num],
            :by_end_of_grade => parsed_row[:by_grade],
            :description => parsed_row[:state_standard]
        })

      end

    }
    return

  end

########

#####
#
########

  def self.get_objects(&block)
    code = self.content_area_key
    content_area = Curriculum::ContentArea.find_by_code(code)
    return nil if content_area.nil?
    yield( content_area )
    content_area.curriculum_standards_sorted_by_code.each{ |standard|
      yield( standard )
      standard.curriculum_strands_sorted_by_name.each{ |strand|
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
# Load database from csv
############

  def self.load_database_from_csv
    CurriculumItem.remove_nodes_for_curriculum(self)
    self.destroy_existing
    self.get_csv_data
    CurriculumItem.add_nodes_for_curriculum(self)
  end

end

