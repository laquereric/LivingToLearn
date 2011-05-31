class CurriculumContentAreasGrid < Netzke::Basepack::GridPanel

  def configuration
    c = super.merge({
      :class_name => "Basepack::GridPanel",
      :model => "Curriculum::ContentArea",
      :columns => [
        {:name => :code,:width => 100 },{ :name => :name, :width => 300 },{ :name => :description, :width => 300}
      ]
    })
  end

end

