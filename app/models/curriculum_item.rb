class CurriculumItem < ActiveRecord::Base
  acts_as_nested_set :dependent => :destroy

  def self.get_root_node
    root_node = self.find_by_source_klass_name_and_source_full_code('CurriculumItem','root')
    root_node ||= self.create(:source_klass_name=>'CurriculumItem',:source_full_code=>'root')
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
