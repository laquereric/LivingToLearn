namespace :ses_comeback do
  namespace :postcard do
    desc "Gateway"
    task :gateway => :environment do
      Communication::SesAlumni::GatewayComeBack.new.produce
    end
    desc "Highland"
    task :highland => :environment do
      Communication::SesAlumni::HighlandComeBack.new.produce
    end
    desc "Woodbury"
    task :woodbury => :environment do
      Communication::SesAlumni::WoodburyComeBack.new.produce
    end
    desc "Winslow"
    task :winslow => :environment do
      Communication::SesAlumni::WinslowComeBack.new.produce
    end
    desc "CamdenCo"
    task :camden_co => :environment do
      Communication::SesAlumni::CamdenCo.new.produce
    end
    desc "Clearview"
    task :gateway => :environment do
      Communication::SesAlumni::ClearviewComeBack.produce
    end

  end

end

