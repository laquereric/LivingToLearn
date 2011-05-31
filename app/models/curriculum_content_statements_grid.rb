class CurriculumContentStatementsGrid < Netzke::Basepack::GridPanel

  def configuration
    c = super.merge({
      :model => 'Curriculum::ContentStatement',
      :columns => [
        :id,
        {:name => :code, :width=>30},
        :name,
        {:name => :description,:width=>300},
        {:name => :by_end_of_grade,:header => "Grade"},
        {:name => :curriculum_strand__link_to,
          :header => "Strand",
          :getter => lambda { |r|
            r.link_to_strand
          }
        }
      ]
    })
  end

end

