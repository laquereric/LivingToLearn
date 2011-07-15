class Configurator

  def initialize( config, view )
    @_content_for= config
    @view= view
  end

  def content_for(name,&block)
    content = @view.capture(&block) if block_given?
    @_content_for[name] ||= ""
    @_content_for[name] << content if content
    @_content_for[name] unless content
  end

  def contents
    @_content_for
  end
end

