class Curriculum::ParseCsv

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

  def self.to_key(raw_value)
    return nil if raw_value.nil? or raw_value.gsub(' ','').length == 0
    if ( srw = raw_value.split('__') ).length == 2
      return srw[0]
    else
      return raw_value
    end
  end

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
    last_r = nil
    self.records = []
    self.content_areas = {}
    self.standards = {}
    self.strands = {}
    new_r = false

    self.each_csv_row{ |line_number,raw_row|

      row = self.clean_row(raw_row)

      if line_number != 0
        r = self.new

        r.content_area = to_key( row[0] )
        if last_r and r.content_area != last_r.content_area
        end
        r.content_area ||= last_r.content_area  if last_r

        content_area_key , value = to_key_pair( row[0] )
        if content_area_key
          self.content_areas[content_area_key]  = value
          self.standards[content_area_key] = {} if standards[content_area_key].nil?
          self.strands[content_area_key] = {} if strands[content_area_key].nil?
        end

        r.standard = to_key( row[1] )
        if last_r and r.standard != last_r.standard
          new_r = true
        end
        r.standard ||= last_r.standard if last_r

        standard_key , value = to_key_pair( row[1] )
        if standard_key
          content_area_key = r.content_area
          self.standards[content_area_key][standard_key]  = value
          self.strands[content_area_key][standard_key] = {} if strands[content_area_key][standard_key].nil?
        end
        r.strand = to_key( row[2] )
        r.strand ||= last_r.strand if last_r
        if last_r and r.strand != last_r.strand
          new_r = true
        end
        strand_key , value = to_key_pair( row[2] )
        if strand_key
          content_area_key = r.content_area
          standard_key = r.standard
          self.strands[content_area_key][standard_key][strand_key] = value
        end

        r.split = row[3]
        r.split ||= last_r.split if last_r

        r.by_end_of_grade = row[4]
        r.by_end_of_grade ||= last_r.by_end_of_grade if last_r
        if last_r and r.by_end_of_grade != last_r.by_end_of_grade
          new_r = true
        end

        r.content_statement = row[5]
        r.content_statement.strip! if r.content_statement
        r.content_statement ||= last_r.content_statement if last_r
        if last_r and r.content_statement != last_r.content_statement
          new_r = true
        end

        r.cpi_num = row[6]
        r.cumulative_progress_indicator = row[7]
        if last_r and r.cpi_num != last_r.cpi_num
          new_r = true
        end

        records << r if new_r

        last_r = r
        new_r = false

      end
    }
    return
  end

###############
#
###############

  def self.process_standards( standards )
    standards.each_pair{ |code,content_area_hash|
      content_area = Curriculum::ContentArea.create({
        :code => code #,
      })
p content_area_hash
      content_area_hash.each_pair{ |code,name|
        Curriculum::Standard.create({
          :code => code,
          :name => name,
          :curriculum_content_area_id => content_area.id
        })
      }
    }
    return
  end

  def self.get_content_area
    Curriculum::ContentArea.find_by_code(self.content_area_key)
  end

  def self.process_records( records )
    rs = []
    records.each{ |record|
      content_area = Curriculum::ContentArea.find_by_code(record.content_area)
      standard = content_area.find_or_create_standard({
        :code => record.standard
      })
      strand_name = self.strands[content_area.code][standard.code][record.strand]
      next if strand_name.nil?
      strand = standard.find_or_create_strand({
        :code => record.strand,
        :name => strand_name,
        :curriculum_standard_id => standard.id
      })
      content_statement = strand.find_or_create_content_statement({
        :curriculum_strand_id => strand.id,
        :by_end_of_grade => record.by_end_of_grade,
        :description => record.content_statement
      })
      if record.cpi_num
        cumulative_progress_indicator = content_statement.find_or_create_cumulative_progress_indicator({
          :by_end_of_grade => record.by_end_of_grade,
          :code => record.cpi_num,
          :description => record.cumulative_progress_indicator,
          :curriculum_content_statement_id => content_statement.id
        })
      end
    }
    return
  end

  def self.get_csv_hash
    self.get_csv_data
    return {
      :content_areas => self.content_areas,
      :standards => self.standards,
      :strands => self.strands,
      :records => self.records
    }
  end

#########################
# utility
##########################

  def self.purge
    Curriculum::ContentArea.delete_all
    Curriculum::Standard.delete_all
    Curriculum::Strand.delete_all
    Curriculum::ContentStatement.delete_all
    Curriculum::CumulativeProgressIndicator.delete_all
  end

  def self.total_record_count()
    sum = 0
    sum += Curriculum::ContentArea.count
    sum += Curriculum::Standard.count
    sum += Curriculum::Strand.count
    sum += Curriculum::ContentStatement.count
    sum += Curriculum::CumulativeProgressIndicator.count
    return sum
  end

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
    raw_hash = self.get_csv_hash

    CurriculumItem.remove_nodes_for_curriculum(self)

    p "Before destroy : #{self.total_record_count()}"
    self.destroy_records(self.content_area_key)
    p "After destroy : #{self.total_record_count()}"

    process_standards( raw_hash[:standards] )
    process_records( raw_hash[:records] )

    records_hash = {
      :content_areas => Curriculum::ContentArea.all,
      :standards => Curriculum::Standard.all,
      :strands => Curriculum::Strand.all,
      :cumulative_progress_indicators => Curriculum::CumulativeProgressIndicator.all
    }
    p "After Add : #{self.total_record_count()}"

    CurriculumItem.add_nodes_for_curriculum(self)

    return records_hash
  end

end

