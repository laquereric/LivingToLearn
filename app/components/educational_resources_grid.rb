class EducationalResourcesGrid < Netzke::Basepack::GridPanel

  def configuration
    config = {
      :model => 'EducationalResource',
      :columns => [
        {:name => :record_id,:width=>40},
        {:name => :kind,:width=>40},
        {:name => :source,:width=>40},
        {:name => :filepath,:width=>300},
        {:name => :primary_curriculum_code,:width=>300}
      ]
    }
    c = super.merge(config)
  end

end

