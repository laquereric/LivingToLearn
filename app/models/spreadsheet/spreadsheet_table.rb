class Spreadsheet::SpreadsheetTable < ActiveRecord::Base

  def self.name_array
    na = self.to_s.split('::')[1..-1]
    return [ na[0..-2] , na[-1].pluralize ].flatten
  end

  def self.get_records_from_google_spreadsheet()
    Spreadsheet::Spreadsheet.get_records_from_google_spreadsheet(self)
  end

end
