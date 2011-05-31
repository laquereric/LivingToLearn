class CurriculumContentStatementForm < Netzke::Basepack::FormPanel

  def configuration
    c = super.merge({
      :model => 'Curriculum::ContentStatement',
      :record_id =>  ::Netzke::Core.controller.params[:id]
    })
  end

end

