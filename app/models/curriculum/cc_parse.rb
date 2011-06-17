require 'csv'

class Curriculum::CcParse

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
    records = []
    records << ( content_area = Curriculum::ContentArea.create({
      :code => self.content_area_key
    }))
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

        by_grade = parsed_row[:by_grade]
        new_grade = ( last_parsed_row.nil? or ( by_grade != last_parsed_row[:by_grade] ) )

        sub_category = parsed_row[:sub_category]
        new_sub_category = ( last_parsed_row.nil? or ( sub_category != last_parsed_row[:sub_category] ) )

        category = parsed_row[:category]
        new_category = ( last_parsed_row.nil? or ( category != last_parsed_row[:category] ) )

        standard_code = parsed_row[:standard_code]
        if standard.nil? or standard_code != last_parsed_row[:standard_code]
          records << ( standard = Curriculum::Standard.create({
            :code => standard_code,
            :name => category,
            :curriculum_content_area_id => content_area.id
          }))
          p "new standard #{standard_code}"
        end

        strand = Curriculum::Strand.find_by_name(sub_category)
        if strand.nil? or
          new_sub_category
          records << (strand = Curriculum::Strand.create({
              :code => parsed_row[:cpi_num],
              :name => sub_category,
              :curriculum_standard_id => standard.id
          }))
          p "new strand #{sub_category}"
        end

          records << (content_statement = Curriculum::ContentStatement.create({
            :curriculum_strand_id => strand.id,
            :by_end_of_grade => by_grade,
            :description => parsed_row[:state_standard]
          }))

        records << ( Curriculum::CumulativeProgressIndicator.create({
          :by_end_of_grade => by_grade,
          :code =>  parsed_row[:cpi_num],
          :description => 'none',
          :curriculum_content_statement_id => content_statement.id
        }))

      end

    }
    return records

  end

########
#
########

  def self.records_from_file
    self.destroy_existing
    self.get_csv_data
  end

end

