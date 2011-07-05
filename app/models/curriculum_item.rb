class CurriculumItem < ActiveRecord::Base
  acts_as_nested_set :dependent => :destroy
  serialize :cache

  def is_root?
    return ( !self.source_klass_name.nil? and self.source_klass_name == 'Curriculum::Root' )
  end

  def target_item
    klass= self.target_node_klass_name.constantize
    klass.find(self.target_node_object_id)
  end

#############
  def as=(v)
    @as= v
  end

  def as
    @as ||= self.ancestors
    return @as
  end

##############
  def ch=(v)
    @ch= v
  end

  def ch
    @ch ||= self.children
    return @ch
  end

##############
  def ti=(v)
    @ti= v
  end

  def ti
    if @ti.nil?
      @ti= self.target_item
      @ti.ci= self
    end
    return @ti
  end

###############

##############
  def sg=(v)
    @sg= v
  end

  def sg
    @sg ||= self.ti.start_grade
    return @sg
  end

###############

  def self.get_curriculum_root
    curriculum_root = Curriculum::Root.first
    curriculum_root ||= Curriculum::Root.create(
      :name => 'Root',
      :code => 'root',
      :full_code => 'root'
    )
  end

  def self.get_root_node
    curriculum_root = self.get_curriculum_root

    root_node = self.find_by_source_klass_name_and_source_full_code(
      curriculum_root.class.to_s,
      curriculum_root.full_code
    )
    root_node ||= self.create(
      :source_klass_name => curriculum_root.class.to_s,
      :source_full_code => curriculum_root.full_code,
      :target_node_klass_name => curriculum_root.class.to_s,
      :target_node_object_id => curriculum_root.id
    )
  end

  def self.get_root_for_curriculum(curriculum)
    self.find_by_target_node_klass_name_and_source_klass_name("Curriculum::ContentArea",curriculum.to_s)
  end

  def self.get_root_for_content(content)
    self.find_by_target_node_klass_name_and_target_node_object_id(content.class.to_s,content.id)
  end

  def self.node_config_for(curriculum,c_object)
    {
      :source_klass_name => curriculum.to_s,
      :source_full_code => c_object.full_code,
      :target_node_klass_name => c_object.class.to_s,
      :target_node_object_id => c_object.id
    }
  end

  def self.add_nodes_for_curriculum(curriculum_klass)
    current_node= nil
    current_level= nil
    curriculum_klass.get_objects{ |c_object|
      putc('.')
      level = Curriculum::ContentArea.level_of(c_object)
      new_node = if current_level.nil?
        self.get_root_node.children.create(
          self.node_config_for(curriculum_klass,c_object)
        )
      elsif level > current_level
        current_node.children.create(
          self.node_config_for(curriculum_klass,c_object)
        )
      elsif level == current_level
        current_node.parent.children.create(
          self.node_config_for(curriculum_klass,c_object)
        )
      else #level < current_level
        while ( level < current_level ) do
          current_node = current_node.parent
          current_level -= 1
        end
        current_node.parent.children.create(
          self.node_config_for(curriculum_klass,c_object)
        )
      end
      current_node = new_node
      current_level = level
    }
  end

  def self.remove_nodes_for_curriculum(curriculum)
    curriculum_roots = get_root_node.children.select{ |node|
      curriculum.to_s == node.source_klass_name
    }
    return if curriculum_roots.length == 0
    curriculum_roots[0].destroy
  end

########################
# Utility
#########################

  def name_value_for(o)
    r = nil
    r = o.name
    r ||= o.description
    r ||= o.code
    return r
  end

  def terminal
    return (self.children.length == 0)
  end

  def target_name
    name_value_for(self.ti)
  end

  def target_klassname
    self.ti.class.to_s
  end

  def target_id
    self.ti.id
  end

  def target_full_code
    self.ti.full_code
  end

#########################

  def ref
    return {
      :id => Curriculum::Root.first.id,
      :target_name => 'Root',
      :curriculum_name => nil
    } if self.source_klass_name == "Curriculum::Root"

    curriculum_name =  self.source_klass_name if self.target_node_klass_name == "Curriculum::ContentArea"
    return{
      :id => self.parent.id,
      :target_name => name_value_for(self.parent.ti),
      :curriculum_name => curriculum_name
    }
  end

  def parent_ref
    if as.length >= 1
      as[0].ref
    else
      nil
    end
  end

  def grand_parent_ref
    if as.length >= 2
      as[1].ref
    else
      nil
    end
  end

  def great_grand_parent_ref
    if as.length >= 3
      as[2].ref
    else
      nil
    end
  end

  def great_great_grand_parent_ref
    if as.length >= 4
      as[3].ref
    else
      nil
    end
  end

  def curriculum_name
    self.update_cache if self.cache.nil?
    return self.cache[:curriculum_name]
    #curriculum_name_calc
  end

  def curriculum_name_calc
    return self.source_klass_name if self.target_node_klass_name == "Curriculum::ContentArea"
    return [
      self.parent_ref,
      self.grand_parent_ref,
      self.great_grand_parent_ref,
      self.great_great_grand_parent_ref
    ].compact.map{ |pr|
      pr[:curriculum_name]
    }.compact[0]
  end

###############
#
###############

  def update_cache
      self.purge_cache
      self.cache= {}

      self.cache[:curriculum_name]= self.curriculum_name_calc
      self.save
  end

############################

  def purge_cache
    self.cache = nil
    self.save
  end

  def purge_start_grade_cache
    self.min_by_end_of_grade_age= nil
    self.max_by_end_of_grade_age= nil
    self.by_end_of_grade_age= nil
    self.save
  end

  def purge_caches
    purge_cache
    purge_start_grade_cache
  end

  def self.purge_caches
    p "Purging #{self.to_s} Other Caches"
    self.all.each{ |s|
      s.purge_cache; putc('.')
    }
    p ""
    p "Purging #{self.to_s} Start Grade Caches"
    self.all.each{ |s|
      s.purge_start_grade_cache
      putc('.')
    }
    return nil
  end

###################

  def self.update_other_caches
    p "Updating #{self.to_s} Updating Other Caches"
    self.all.each{ |s| s.update_cache; putc('.') }
    return nil
  end

  def self.update_start_grade_caches
    p ""; p "Purging #{self.to_s} Purging Start Grade Caches"
    self.all.each{ |s| 
      s.purge_start_grade_cache
      putc('.') 
    }
    p ""; p "Updating #{self.to_s} Updating Start Grade Caches"
    self.all.each{ |s| s.ti.start_grade; putc('.') }
    return nil
  end

  def self.update_caches
    self.update_other_caches
    self.update_start_grade_caches
    return nil
  end

###############
#
###############

  def sort_term
    r = self.by_end_of_grade_age
    r ||= self.min_by_end_of_grade_age
    r ||= 0
  end

end
