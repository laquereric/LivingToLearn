class CurriculumController < ApplicationController
  caches_action :index, :root

  def root
    params[:name] = 'root'
    self.index
    render :action => :index
  end

  def complete(h)
    h[:terminal]= h[:node].children.length == 0 ? true : false

    #TODO why not? h[:target] ||= h[:node].target

    klass = h[:node].target_node_klass_name.constantize
    h[:target] = klass.find(h[:node].target_node_object_id)

    h[:name] = h[:target].name
    h[:name] ||= h[:target].description
    h[:name] ||= h[:target].code

    h[:name] = 'Curricula' if  h[:name] == 'Root'

    return h
  end

  def display?(child)
      r = if @curriculum.nil?
        true
      elsif !@curriculum.by_grade?
        true
      elsif !child[:target].has_deadlines?
        false
      elsif @curriculum.by_grade?
        r2 = if !filtered_by_grade
          true
        else
          ref_to_deadline= child[:target].deadline_relative_to(@max_grade)
          (ref_to_deadline > -1 and ref_to_deadline < 1 )
        end
      else
        false
      end
      return r
  end 

  def sort(children_unsorted)
    children_unsorted.sort{ |x,y|
begin
      #if @curriculum and @curriculum.by_grade? and
       #!x[:target].start_grade_age.nil? and !y[:target].start_grade_age.nil? and
       #!x[:target].span.nil? and !y[:target].span.nil? then
         r = x[:target].start_grade_age*100 + x[:target].span <=> y[:target].start_grade_age*100 + y[:target].span
      #else
rescue
p "could not sort #{x[:target].inspect}"
        r = 0 <=> 0
end

    }
  end

  def ancestors(center)
    @parent= complete( {:node => center[:node].parent } )  if !(center[:node].is_root?)

    @grand_parent= complete( {:node => @parent[:node].parent } ) if @parent and !(@parent[:node].is_root?)

    @great_grand_parent = if @grand_parent and !(@grand_parent[:node].is_root?)
      complete( {:node => @grand_parent[:node].parent } )
    end

    @great_great_grand_parent = if @great_grand_parent and !(@great_grand_parent[:node].is_root?)
      complete( {:node => @great_grand_parent[:node].parent } )
    end
  end

  def curriculum
    @curriculum = [@center,@parent,@grand_parent,@great_grand_parent, @great_great_grand_parent].compact.map{ |i|
      i[:target].curriculum 
    }.compact[0]
  end

  def elaborate(h)
    h[:name] = h[:target].name
    h[:name] ||= h[:target].description
    h[:name] ||= h[:target].code
  end

  def index

    @center = if params[:node_id].nil?
      { :node => CurriculumItem.root, :target => Curriculum::Root.first }
    else
      node = CurriculumItem.find_by_id(params[:node_id])
      { :node => node }
    end
    self.complete(@center)

    @max_grade , filtered_by_grade= if params[:age].nil? or ( params[:age].to_i == Curriculum::Grade::MaxAge )
      [Curriculum::Grade.create({:age=>Curriculum::Grade::MaxAge}),false]
    else
      [Curriculum::Grade.create({:age=>params[:age].to_i}),true]
    end
    @all_grades = Curriculum::Grade.all(@max_grade.age)
    
    self.ancestors(@center)

    @children= self.sort( 
      @center[:node].children.map{ |child|
        self.complete( { :node => child } )
      }.select{ |child|
        r = display?(child)
      }.each{ |child|
        self.elaborate(child)
      }
    )

  end

end
