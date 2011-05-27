class Context < ActiveRecord::Base
  scope :for_user_email , lambda { |email| where('user_email IS NOT NULL AND user_email = ?', email) }
  scope :at_registration, :conditions => ["at_registration = ?", true]
  scope :user_registrations, lambda { |email| at_registration.for_user_email(email) }

  def message_lines
    m = []
      m << "topic #{self.topic}" if self.topic
      m << "servic #{self.service}"  if self.service
      if self.marketing
        m << "marketing #{self.marketing}"
      end
      m << "subdomain_path #{self.subdomain_path}" if self.subdomain_path

      m << "ref_type #{self.ref_type}" if self.ref_type
      m << "ref_field #{self.ref_field}" if self.ref_field
      m << "ref_value #{self.ref_value}" if self.ref_value

    return m
  end

end

