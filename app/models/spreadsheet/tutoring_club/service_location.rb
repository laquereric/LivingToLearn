class Spreadsheet::TutoringClub::ServiceLocation < Spreadsheet::SpreadsheetTable
  set_table_name ('spreadsheet__tutoring_club__service_locations')

  def equals(target_service_location)
    return (self.location_id == target_service_location.location_id)
  end

end

