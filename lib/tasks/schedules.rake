namespace :schedule do
  namespace :for_day do

    desc "SUN"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

    desc "MON"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

    desc "TU"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

    desc "WED"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

    desc "THUR"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

    desc "FRI"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

    desc "SAT"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

  end
end
