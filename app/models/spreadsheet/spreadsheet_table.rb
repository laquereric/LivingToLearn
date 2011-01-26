class Spreadsheet::SpreadsheetTable < ActiveRecord::Base

  def self.name_array
    self.to_s.split('::')[1..-1]
  end

  def self.get_records_from_google_spreadsheet()
    Spreadsheet::Spreadsheet.get_records_from_google_spreadsheet(self)
  end

end
