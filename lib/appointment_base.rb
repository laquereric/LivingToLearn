module AppointmentBase

  def appointable
    (self.appointable_type.constantize).find_by_appointable_id(self.appointable_id.to_f)
  end

end

