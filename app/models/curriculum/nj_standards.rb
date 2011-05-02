class Curriculum::NjStandards #< ActiveRecord::Base

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
  attr_accessor :by_end_of_grade
  attr_accessor :content_statement
  attr_accessor :cpi_num
  attr_accessor :cumulative_progress_indicator

###############
# Lower Level
###############
  def self.filename
    File.join(Rails.root,'data','nj_standards.csv')
  end

  def self.each_csv_row
    line_number = 0
    CSV::Reader.parse(File.open(self.filename, 'rb')) do |row|
#p row
      yield(line_number,row)
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

  def self.get_csv_data
    last_r = nil
    self.records = []
    self.content_areas = {}
    self.standards = {}
    self.strands = {}

    self.each_csv_row{ |line_number,row|
      if line_number != 0
        r = self.new

        r.content_area = to_key( row[0] )
        r.content_area ||= last_r.content_area  if last_r

        content_area_key , value = to_key_pair( row[0] )
        if content_area_key
          self.content_areas[content_area_key]  = value
          self.standards[content_area_key] = {} if standards[content_area_key].nil?
          self.strands[content_area_key] = {} if strands[content_area_key].nil?
        end

        r.standard = to_key( row[1] )
        r.standard ||= last_r.standard if last_r

        standard_key , value = to_key_pair( row[1] )
        if standard_key
          content_area_key = r.content_area
          self.standards[content_area_key][standard_key]  = value
          self.strands[content_area_key][standard_key] = {} if strands[content_area_key][standard_key].nil?
        end

        r.strand = to_key( row[2] )
        r.strand ||= last_r.strand if last_r

        strand_key , value = to_key_pair( row[2] )
        if strand_key
          content_area_key = r.content_area
          standard_key = r.standard
          self.standards[content_area_key][standard_key]  = value
          self.strands[content_area_key][standard_key][strand_key] = value
        end

        r.by_end_of_grade = row[3]
        r.by_end_of_grade ||= last_r.by_end_of_grade if last_r

        r.content_statement = row[4]
        r.content_statement.strip! if r.content_statement
        r.content_statement ||= last_r.content_statement if last_r

        r.cpi_num = row[5]
        r.cumulative_progress_indicator = clean(row[6])

        records << r if r.cpi_num

        last_r = r
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

  def self.process_records( records )
    rs=[]
    records.each{ |record|
      content_area = Curriculum::ContentArea.find_by_code(record.content_area)
      standard = Curriculum::Standard.find_by_code(record.standard)
      strand = Curriculum::Strand.find_by_code(record.strand)
      strand ||= Curriculum::Strand.create({
          :code => record.strand,
          :description => record.content_statement,
          :curriculum_standard_id => standard.id
      })
      Curriculum::CumulativeProgressIndicator.create({
        :by_end_of_grade => record.by_end_of_grade,
        :code => record.cpi_num,
        :description => record.cumulative_progress_indicator,
        :curriculum_strand_id => strand.id
      })
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

  def self.to_records

    Curriculum::ContentArea.delete_all
    Curriculum::Standard.delete_all
    Curriculum::Strand.delete_all
    Curriculum::CumulativeProgressIndicator.delete_all

    raw_hash = self.get_csv_hash

    process_standards( raw_hash[:standards] )
    process_records( raw_hash[:records] )

    records_hash = {
      :content_areas => Curriculum::ContentArea.all,
      :standards => Curriculum::Standard.all,
      :strands => Curriculum::Strand.all,
      :cumulative_progress_indicators => Curriculum::CumulativeProgressIndicator.all
    }
    return records_hash
  end

end

