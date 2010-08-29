namespace :merge do

  desc "edit document at cursor"
  task :doc => :environment do
     Merge::Merge.type_symbol= Merge::Merge.get_name_cursor
     name_symbol= Merge::Merge.get_name_cursor
     p "Editing Doc #{name_symbol}"
     Merge::Merge.get_document(name_symbol)
     Merge::Merge.swriter(name_symbol)
  end

  namespace :type_cursor do
    desc "letter"
    task :letter => :environment do
      Merge::Merge.set_type_cursor(:letter)
    end
    desc "postcard"
    task :letter => :environment do
      Merge::Merge.set_type_cursor(:postcard)
    end
    desc "postcard_3x"
    task :postcard_3x => :environment do
      Merge::Merge.set_type_cursor(:postcard_3x)
    end
    desc "pos"
    task :pos_3x => :environment do
      Merge::Merge.set_type_cursor(:pos)
    end
  end

  namespace :doc_cursor do
    desc "ses_come_back"
    task :ses_come_back => :environment do
      Merge::Merge.set_doc_cursor(:ses_come_back)
    end
    desc "church_leader_intro"
    task :church_leader_intro => :environment do
      Merge::Merge.set_doc_cursor(:church_leader_intro)
    end
    desc "ses_administrators_intro"
    task :ses_administrators_intro => :environment do
      Merge::Merge.set_doc_cursor(:ses_administrators_intro)
    end
  end

end

