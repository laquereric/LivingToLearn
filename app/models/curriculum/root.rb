class Curriculum::Root < ActiveRecord::Base
  set_table_name :curriculum_roots

  def curriculum
    nil
  end

  def is_root?
    true
  end

  def name
    "Root"
  end

end
