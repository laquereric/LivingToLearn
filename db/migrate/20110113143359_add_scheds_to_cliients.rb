class AddSchedsToCliients < ActiveRecord::Migration
  def self.up
     add_column "person_clients", "sched_a",:string
     add_column "person_clients", "sched_b",:string
     add_column "person_clients", "sched_c",:string
     add_column "person_clients", "sched_d",:string
     add_column "person_clients", "sched_e",:string
     add_column "person_clients", "sched_f",:string
     add_column "person_clients", "sched_g",:string
  end

  def self.down
      remove_column "person_clients", "sched_a"
      remove_column "person_clients", "sched_b"
      remove_column "person_clients", "sched_c"
      remove_column "person_clients", "sched_d"
      remove_column "person_clients", "sched_e"
      remove_column "person_clients", "sched_f"
      remove_column "person_clients", "sched_g"
  end
end
