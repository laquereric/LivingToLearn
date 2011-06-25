class Curriculum::Root < ActiveRecord::Base
  set_table_name :curriculum_roots

  def is_root?
    true
  end

  def name
    "Root"
  end

  def calc_by_end_of_grade
  end

end
