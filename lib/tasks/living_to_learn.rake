namespace :living_to_learn do

  namespace :organization_members do

    desc "Get Migration"
    task :get_migration => :environment do
      p "Get Migration"
      mls = Spreadsheet::Spreadsheet.get_migration_from_google_spreadsheet(["LivingToLearn","OrganizationMembers"])
      mls.each{ |l|  p l}
    end

    desc "Get Class Def"
    task :get_class_def => :environment do
      p "Get Class Def"
      mls = Spreadsheet::Spreadsheet.get_class_def_from_google_spreadsheet(["LivingToLearn","OrganizationMembers"])
      mls.each{ |l|  p l}
    end

    desc "Load Records"
    task :load_records => :environment do
      p "Loading Records"
      mls = Spreadsheet::LivingToLearn::OrganizationMember.get_records_from_google_spreadsheet
      mls.each{ |l|  p l}
    end

    desc "Generate Welcome Letters"
    task :generate_welcome_letters => :environment do
      Spreadsheet::LivingToLearn::OrganizationMember.all.each{ |member|
          Document::Letter::LivingToLearnNewMember.print_for(member)
      }
    end

  end

end

