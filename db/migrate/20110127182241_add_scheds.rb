class AddScheds < ActiveRecord::Migration
  def self.up
    add_column "person_employees","sched_a",:string
    add_column "person_employees","sched_b",:string
    add_column "person_employees","sched_c",:string
    add_column "person_employees","sched_d",:string
    add_column "person_employees","sched_e",:string
    add_column "person_employees","sched_f",:string
    add_column "person_employees","sched_g",:string
    
    add_column "person_employees","dur_a",:string
    add_column "person_employees","dur_b",:string
    add_column "person_employees","dur_c",:string
    add_column "person_employees","dur_d",:string
    add_column "person_employees","dur_e",:string
    add_column "person_employees","dur_f",:string
    add_column "person_employees","dur_g",:string

    add_column "person_clients","dur_a",:string
    add_column "person_clients","dur_b",:string
    add_column "person_clients","dur_c",:string
    add_column "person_clients","dur_d",:string
    add_column "person_clients","dur_e",:string
    add_column "person_clients","dur_f",:string
    add_column "person_clients","dur_g",:string

    add_column "appointments","duration",:string

  end

  def self.down
    remove_column "person_employees","sched_a"
    remove_column "person_employees","sched_b"
    remove_column "person_employees","sched_c"
    remove_column "person_employees","sched_d"
    remove_column "person_employees","sched_e"
    remove_column "person_employees","sched_f"
    remove_column "person_employees","sched_g"

    remove_column "person_employees","dur_a"
    remove_column "person_employees","dur_b"
    remove_column "person_employees","dur_c"
    remove_column "person_employees","dur_d"
    remove_column "person_employees","dur_e"
    remove_column "person_employees","dur_f"
    remove_column "person_employees","dur_g"
 
    remove_column "person_clients","dur_a"
    remove_column "person_clients","dur_b"
    remove_column "person_clients","dur_c"
    remove_column "person_clients","dur_d"
    remove_column "person_clients","dur_e"
    remove_column "person_clients","dur_f"
    remove_column "person_clients","dur_g"

    remove_column "appointments","duration"

  end
end
