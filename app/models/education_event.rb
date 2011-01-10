class EducationEvent < ActiveRecord::Base

  def self.prepare_table_for_stores()
    self.delete_all
  end

  def self.store_row_hash(row_hash)
    self.create(row_hash)
  end

  def self.all_for(client)
    self.all.select{ |education_event|
     #p client.client_id.to_i
      m = (education_event.client_id.to_i == client.client_id.to_i)
      #p "ee cid: #{education_event.client_id.to_i} m: #{m}"
      m
    }
  end

end
