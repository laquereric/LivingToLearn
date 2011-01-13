namespace :schedule do
  namespace :for_day do

    desc "Week"
    task :week => :environment do
      sum = 0
      ["SUN","MON","TU","WED","THUR","FRI","SAT"].each{ |week_day|
        sum += Document::Reports::DailyCalendar.quick_for(week_day)
      }
      p "Total of #{sum}"
    end

    desc "SUN"
    task :sun => :environment do
       Document::Reports::DailyCalendar.quick_for('SUN')
    end

    desc "MON"
    task :mon => :environment do
       Document::Reports::DailyCalendar.quick_for('MON')
    end

    desc "TU"
    task :tu => :environment do
       Document::Reports::DailyCalendar.quick_for('TU')
    end

    desc "WED"
    task :wed => :environment do
       Document::Reports::DailyCalendar.quick_for('WED')
    end

    desc "THUR"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR')
    end

    desc "FRI"
    task :fri => :environment do
       Document::Reports::DailyCalendar.quick_for('FRI')
    end

    desc "SAT"
    task :sat => :environment do
       Document::Reports::DailyCalendar.quick_for('SAT')
    end

  end
end
