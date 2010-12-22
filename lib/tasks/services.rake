namespace :services do

  desc "TC fax"
  task :tc_fax  => :environment do
    p "Tutoring Club Faxes"
    Service::AccessLine.browse_frame(
       ENV['TUTORING_CLUB_FAX_DID'],
       ENV['ACCESS_LINE_PIN']
    )
  end

  desc "TC VM"
  task :tc_vm  => :environment do
    p "Tutoring Club VM - #{ENV['TUTORING_CLUB_VM_DID']}"
    Service::AccessLine.browse_frame(
      ENV['TUTORING_CLUB_VM_DID'],
      ENV['ACCESS_LINE_PIN']
    )
  end

  desc "Axis VM"
  task :aa_vm  => :environment do
    p "Axis Achievement VM - #{ENV['AXIS_ACHIEVEMENT_VM_DID']}"
    Service::AccessLine.browse_frame(
      ENV['AXIS_ACHIEVEMENT_VM_DID'],
      ENV['ACCESS_LINE_PIN']
    )
  end

  desc "L2L VM"
  task :l2l_vm  => :environment do
    p "Axis Achievement VM - #{ENV['LIVING_TO_LEARN_VM_DID']}"
    Service::AccessLine.browse_frame(
      ENV['LIVING_TO_LEARN_VM_DID'],
      ENV['ACCESS_LINE_PIN']
    )
  end

end

