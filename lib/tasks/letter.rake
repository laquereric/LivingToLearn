namespace :letter do

  desc "do"
  task :do => :environment do
    Document::Letter::Base.print({
      :first_name => "fn",
      :last_name => "ln",
      :address_line_1 => "al1",
      :address_line_2 => "al2",
      :city => "city",
      :state => "s",
      :zip => "z"
    })
  end

  desc "wbc"
  task :wbc => :environment do
    client = Person::Client.find_by_client_id(218.0)
    Document::Letter::WoodburyContract.print_for(client,'letter.pdf')
  end

  namespace :appointments do

    desc "SES Students"
    task :ses => :environment do
      possible_appointments = 0
      have_appointments = 0
      Government::SchoolDistrict.each_district_with_ses_contract{ |school_district|
        clients = Person::Client.all_under_contract_with_sd( school_district )
        p "Ses contracts from #{ school_district.code_name }  - #{clients.length}"
        possible_appointments += clients.length
        clients.each{ |client|
          filename = Document::Letter::SesAppointment.filename_for( client )
          ok = Document::Letter::SesAppointment.print_for(client,filename)
          have_appointments += 1 if ok
        }
      }
      p "Of #{possible_appointments} possible appointments, #{have_appointments} have been set."
    end

    desc "Woodbury Appointments"
    task :woodbury => :environment do
      client = Person::Client.find_by_client_id(218.0)
      Document::Letter::WoodburyAppointment.print_for(client,'letter.pdf',[])
    end

  end

end
