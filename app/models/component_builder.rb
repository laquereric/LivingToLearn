class ComponentBuilder

  def self.class_defined( parsed )
    r = false
    begin
      parsed[:classname].constantize
      r = true
    rescue
    end
    return r
  end

  def self.flat_tab_classname(parsed)
    tabname = parsed[:parts][2][:file].split('_')[1].capitalize
    "Touch::Tab::#{tabname}"
  end

  def self.hier_tab_classname(parsed)
    tabname = parsed[:parts][2][:directory].split('_')[1].capitalize
    "Touch::Tab::#{parsed[:parts][2].inspect}"
  end

  def self.card_classname(parsed)
    tabname = parsed[:parts][2][:directory].split('_')[1..-1].map{ |n| n.capitalize }.join
    cardname = parsed[:parts][3][:file].split('_')[1..-1].map{ |n| n.capitalize}.join
    "Touch::Card::#{tabname}::#{cardname}"
  end

  def self.classify_name( name )
    name_split = name.split('.')
    r = if name_split.length > 1 then
      { :file => name_split[0] }
    else
      { :directory => name_split[0] }
    end
    return r
  end

  def self.parse_filename_parts(filename,key)
    filename_split = filename.split('/')
    key_pos = nil
    filename_split.each_index{ |i| key_pos = i if filename_split[i] == key }
    return filename_split[key_pos..-1].map{ |name|
      self.classify_name( name )
    }
  end

  def self.parse_filename(filename,key)
    parts = self.parse_filename_parts(filename,key)
    r = { :parts => parts }
    if parts.length == 3 and parts[2][:file] then
      r.merge!( { :type => :tab } )
      r.merge!( { :hier => :flat } )
      r.merge!({ :classname => self.flat_tab_classname(r) })
    elsif parts.length == 3 and parts[2][:directory] then
      r.merge!({ :type => :tab })
      r.merge!({ :hier => :deep })
      r.merge!({ :classname => self.hier_tab_classname(r) })
    else
      r.merge!({ :type => :card })
      r.merge!({ :classname => self.card_classname(r) })
    end
    r.merge!( { :defined => self.class_defined( r ) } )
    return r
  end

  def self.views(key)
    return Dir.glob( File.join( Rails.root,'app', 'views', 'touch', '**', '*.*' ) ).map{ |fn|
      self.parse_filename( fn, key )
    }
  end

  def self.missing_classes(key)
    self.views(key).select{ |h|
      !h[:defined]
    } #.map{ |h|
    #  { :classname => h[:classname], :type => h[:type] }
    #}
  end

  def self.missing_classes_of_type(key,type)
    self.missing_classes(key).select{ |h|
      !h[:type] == type
    }
  end

  def self.generate_flat_tab_class(key,name)
    text = <<-RUBY
      class Touch::Tab::#{name}  < TabBase
      end
    RUBY
    filename = File.join( Rails.root,'app','components',key,'tab',"#{name.downcase}.rb")
    File.open(filename,'w'){ |f|
      f.write(text)
    }
    p "Generated in #{key} for #{name} this object #{text}"
  end

  def self.create_flat_tab_classes(key)
    self.missing_classes(key).select{ |h|
      h[:type] == :tab and h[:hier] == :flat
    }.each{ |h|
      self.generate_flat_tab_class( key, h[:classname] )
    }
  end

end