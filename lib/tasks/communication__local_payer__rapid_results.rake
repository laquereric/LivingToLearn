namespace :communication do
  namespace :local_payer do
    namespace :rapid_results do
      desc "produce"
      task :produce => :environment do
        Communication::LocalPayers::RapidResults.produce_all
      end
    end
  end
end

