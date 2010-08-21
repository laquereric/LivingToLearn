class Spreadsheet::SesProviders < Spreadsheet::Spreadsheet

  def self.headers
    [
    'Name','AreasServed','Services','Qualifications',
    'Joined',
    'FirstName','LastName',
    'AddressLine1','AddressLine2','City','State','Zip',
    'Phone','Email'
    ]
  end

  def self.load_records()
    self.column_key = {}
    self.each_header{ |column,content|
      self.column_key[1] = :name if column == 1 and content == "Name"
      self.column_key[2] = :areas_served if column == 2 and content == "AreasServed"
      self.column_key[3] = :services if column == 3 and content == "Services"
#"Content Areas/\nGrade Levels/\nPopulation Served"
      self.column_key[4] = :qualifications if column == 4 and content == "Qualification"
#"Statement of Qualifications & Effectiveness"
    }
    r={}
    name= nil
    end_of_list= false
    self.each_row { |spreadsheet,row|
      if (row-1) % 3 == 1
#p 'title'
        name= spreadsheet.cell(row,1)
        end_of_list= true if name.nil?
      end
      if (row-1) % 3 == 2
#p 'contact'
        r[:contact]=  spreadsheet.cell(row,2)
      end
      if (row-1) % 3 == 0
#p 'detail'
        r[:areas_served]=  spreadsheet.cell(row,2)
        r[:services]=  spreadsheet.cell(row,3)
        r[:qualifications]= spreadsheet.cell(row,4)
        ses_provider_entity, ses_provider_details = Organization::SesProvider.find_or_add_name_details( name,{},r )
        name = nil
      end
      end_of_list
    }
  end

  def self.load_record_file(filename)
    self.spreadsheet = nil
    self.filename = filename
    self.load_records()
    self.spreadsheet
  end

  def self.load_data_records()
    self.load_recordfile( File.join( RAILS_ROOT, "data" , "US_NJ_SES_PROVIDERS.ods") )
  end

end
