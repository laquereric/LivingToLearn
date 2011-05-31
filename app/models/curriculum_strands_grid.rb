class CurriculumStrandsGrid < Netzke::Basepack::GridPanel

  def configuration
    c = super.merge({
      :model => 'Curriculum::Strand',
      :columns => [
        :id,
        {:name => :code, :width => 30 },
        {:name => :name, :width => 300 },
        {:name => :curriculum_standard__link_to,
          :header => "Standard",
          :getter => lambda { |r|
            r.link_to_standard
          }
        }
      ]
    })
  end

end

