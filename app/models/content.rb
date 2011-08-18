require 'erb'

class Content
  cattr_accessor :view_binding
  cattr_accessor :target

  def self.template_result( t )
    template = ERB.new( t )
    return template.result self.view_binding
  end

  def self.get_template( filename )
    return File.new( filename, 'r' ).read
  end

  def self.get_html( target, config )
    self.target =  target
    class_name = if target.class == Class
      target.to_s
    else
      target.class.to_s
    end
p "class_name #{class_name}"
    class_name_parsed = class_name.split('::').map { |n| n.downcase.to_sym }
p "class_name_parsed #{class_name_parsed.inspect}"

    if class_name_parsed[1] == :tab
      if config[:tab].nil?
        config[:tab] = class_name_parsed[2]
      end
    end

    if class_name_parsed[1] == :card
      config[:tab] = class_name_parsed[3]  if config[:tab].nil?
      config[:card] = class_name_parsed[4]  if config[:card].nil?
    end

p "config #{config.inspect}"

    filename =  if config[:filename]
      config[:filename]
    elsif config[:access] and config[:tab] and config[:card]
      File.join(Rails.root,'app','views','touch',config[:access].to_s,"tab_#{config[:tab].to_s}","card_#{config[:card].to_s}.html.erb")
    elsif config[:access] and config[:tab]
      File.join(Rails.root,'app','views','touch',config[:access].to_s,"tab_#{config[:tab].to_s}.html.erb")
    end

    template = self.get_template( filename )
    result = self.template_result( template )

    return result
  end

end

