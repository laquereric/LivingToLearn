class CurriculumStrandForm < Netzke::Basepack::FormPanel

  def configuration
    c = super.merge({
      :model => 'Curriculum::Strand',
      :record_id =>  ::Netzke::Core.controller.params[:id]
    })
  end

end

