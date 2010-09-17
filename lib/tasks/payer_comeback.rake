namespace :payer_comeback do
  namespace :postcard do
    desc "All"
    task :all => :environment do
      Communication::PayerAlumni::ComeBack.new.produce
    end
  end
end

