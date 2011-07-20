class Configurator

  def initialize( config, view )
    @_content_for= config
    @view= view
  end

  def content_push(name,content)
    @_content_for[name] ||= ""
    @_content_for[name] << content if content
    @_content_for[name] unless content
  end

  def content_for(name,&block)
    content = @view.capture(&block) if block_given?
    content_push(name,content)
  end

  def content_hash(&block)
    hash = yield if block_given?
    hash.each_pair{ |name,content| 
      content_push(name,content)
    }
  end

  def erb(erb_template)
    ERB.new( erb_template ).result(binding)
  end

  def render(erb_template)
    erb(erb_template){ |key|
      @_content_for[key]
    }
  end

  def contents
    @_content_for
  end

end

