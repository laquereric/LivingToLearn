namespace :living_to_learn do
  namespace :potential_kvn_sponsors do

    desc "Get Migration"
    task :get_migration => :environment do
      p "Get Migration"
      mls = Spreadsheet::Spreadsheet.get_migration_from_google_spreadsheet(["LivingToLearn","PotentialKvnSponsors"])
      mls.each{ |l|  p l}
    end

    desc "get class def"
    task :get_class_def => :environment do
      p "get class def"
      mls = spreadsheet::spreadsheet.get_class_def_from_google_spreadsheet(["livingtolearn","PotentialKvnSponsors"])
      mls.each{ |l|  p l}
    end

    desc "Load Records"
    task :load_records => :environment do
      p "Loading Records"
      mls = Spreadsheet::LivingToLearn::PotentialKvnSponsor.get_records_from_google_spreadsheet
      mls.each{ |l|  p l}
    end

  end

  namespace :municipalities do

    desc "Get Migration"
    task :get_migration => :environment do
      p "Get Migration"
      mls = Spreadsheet::Spreadsheet.get_migration_from_google_spreadsheet(["LivingToLearn","Municipalities"])
      mls.each{ |l|  p l}
    end

    desc "get class def"
    task :get_class_def => :environment do
      p "get class def"
      mls = spreadsheet::spreadsheet.get_class_def_from_google_spreadsheet(["livingtolearn","Municipalities"])
      mls.each{ |l|  p l}
    end

    desc "Load Records"
    task :load_records => :environment do
      p "Loading Records"
      mls = Spreadsheet::LivingToLearn::Municipality.get_records_from_google_spreadsheet
      mls.each{ |l|  p l}
    end

  end

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

  namespace :organization_types do

    desc "Get Migration"
    task :get_migration => :environment do
      p "Get Migration"
      mls = Spreadsheet::Spreadsheet.get_migration_from_google_spreadsheet(["LivingToLearn","OrganizationTypes"])
      mls.each{ |l|  p l}
    end

    desc "Get Class Def"
    task :get_class_def => :environment do
      p "Get Class Def"
      mls = Spreadsheet::Spreadsheet.get_class_def_from_google_spreadsheet(["LivingToLearn","OrganizationTypes"])
      mls.each{ |l|  p l}
    end

    desc "Load Records"
    task :load_records => :environment do
      p "Loading Records"
      mls = Spreadsheet::LivingToLearn::OrganizationType.get_records_from_google_spreadsheet
      mls.each{ |l|  p l}
    end

  end

  namespace :objectives_benefits_features do

    desc "Get Migration"
    task :get_migration => :environment do
      p "Get Migration"
      mls = Spreadsheet::Spreadsheet.get_migration_from_google_spreadsheet(["LivingToLearn","ObjectivesBenefitsFeatures"])
      mls.each{ |l|  p l}
    end

    desc "Get Class Def"
    task :get_class_def => :environment do
      p "Get Class Def"
      mls = Spreadsheet::Spreadsheet.get_class_def_from_google_spreadsheet(["LivingToLearn","ObjectivesBenefitsFeatures"])
      mls.each{ |l|  p l}
    end

    desc "Load Records"
    task :load_records => :environment do
      p "Loading Records"
      mls = Spreadsheet::LivingToLearn::ObjectivesBenefitsFeature.get_records_from_google_spreadsheet
      mls.each{ |l|  p l}
    end

  end

end

