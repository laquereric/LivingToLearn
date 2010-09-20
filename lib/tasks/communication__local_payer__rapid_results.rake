namespace :communication do
  namespace :local_payer do
    namespace :rapid_results do
      desc "t0"
      task :r0_r99 => :environment do
        rr= Communication::LocalPayers::RapidResults.new({:first=>0,:last=>99})
        rr.produce
      end
    end
  end
end

