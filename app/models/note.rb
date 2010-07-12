class Note < Detail
  set_table_name :notes
  validates_presence_of :note
end
