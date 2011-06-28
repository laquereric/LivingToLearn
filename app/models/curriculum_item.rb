class CurriculumItem < ActiveRecord::Base
  acts_as_nested_set :dependent => :destroy

  def is_root?
    return ( !self.source_klass_name.nil? and self.source_klass_name == 'Curriculum::Root' )
  end

  def target
    klass= self.target_node_klass_name.constantize
    klass.find(self.target_node_object_id)
  end

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
p "add_nodes_for_curriculum #{curriculum_klass.to_s}"
    current_node= nil
    current_level= nil
    curriculum_klass.get_objects{ |c_object|
      putc('.')
      level = Curriculum::ContentArea.level_of(c_object)
#p level
      new_node = if current_level.nil?
        self.get_root_node.children.create(
          self.node_config_for(curriculum_klass,c_object)
        )
      elsif level > current_level
#p ">"
        current_node.children.create(
          self.node_config_for(curriculum_klass,c_object)
        )
      elsif level == current_level
#p "=="
        current_node.parent.children.create(
          self.node_config_for(curriculum_klass,c_object)
        )
      else #level < current_level
#p "<"
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

end
