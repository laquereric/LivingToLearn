class Spreadsheet::LivingToLearn::OrganizationType < Spreadsheet::SpreadsheetTable

  set_table_name ('spreadsheet__living_to_learn__organization_types')

  def get_objectives_benefits_features
    obfs = [:obf_1,:obf_2,:obf_3].map{ |name|
      obf_name = self.send(name)
      r = if obf_name and obf_name.length > 0
        obf = Spreadsheet::LivingToLearn::ObjectivesBenefitsFeature.find_by_name( obf_name )
        p "Obf record named #{obf_name} not found!" if obf.nil?
        obf
      else
        nil
      end
      r
    }.compact
    return obfs
  end

end

