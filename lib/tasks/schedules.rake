namespace :schedule do
  namespace :for_day do

    desc "Week"
    task :week => :environment do
      Document::Reports::DailyCalendar.weekly
    end

    desc "SUN"
    task :sun => :environment do
       Document::Reports::DailyCalendar.quick_for('SUN'){|l| p l }
    end

    desc "MON"
    task :mon => :environment do
       Document::Reports::DailyCalendar.quick_for('MON'){|l| p l }
    end

    desc "TU"
    task :tu => :environment do
       Document::Reports::DailyCalendar.quick_for('TU'){|l| p l }
    end

    desc "WED"
    task :wed => :environment do
       Document::Reports::DailyCalendar.quick_for('WED'){|l| p l }
    end

    desc "THUR"
    task :thur => :environment do
       Document::Reports::DailyCalendar.quick_for('THUR'){|l| p l }
    end

    desc "FRI"
    task :fri => :environment do
       Document::Reports::DailyCalendar.quick_for('FRI'){|l| p l }
    end

    desc "SAT"
    task :sat => :environment do
       Document::Reports::DailyCalendar.quick_for('SAT')
    end

  end
end
