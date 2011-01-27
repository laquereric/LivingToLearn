class Spreadsheet::LivingToLearn::OrganizationMember < Spreadsheet::SpreadsheetTable

  set_table_name ('spreadsheet__living_to_learn__organization_members')

  def self.load_from_google
  end

  def get_objectives_benefits_features
    organization_type = Spreadsheet::LivingToLearn::OrganizationType.find_by_name(self.organization_type)
    if organization_type.nil?
      p "Organization type named #{self.organization_type} not found!"
      return nil
    else
      return organization_type.get_objectives_benefits_features
    end
  end

end

