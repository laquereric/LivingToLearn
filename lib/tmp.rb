class Tmp

  def self.basename(filename)
    entry_name_split = filename.split('.')
    return entry_name_split[0].gsub('/','_')
  end

  def self.exts(filename)
    entry_name_split = filename.split('.')
    return entry_name_split[1..-1]
  end

  def self.name(basename)
    random_number = (Kernel.rand*10_000_000_000_000).to_i
    sprintf('%s%s-%d-%d',  Dir::tmpdir,basename, $$ , random_number)
  end

  def self.dir(basename)
    dir_name = self.name(basename)
    %x[mkdir #{dir_name}]
    return dir_name
  end

end
