class Outbox

  def self.push(fn)
    file_split = File.split(fn)
    burst_page = !file_split[-1].match(/^pg_/).nil?
    new_fn_base = if burst_page
      [ file_split[0].split('/')[-1] , file_split[-1] ].join('_')
    else
      file_split[-1]
    end

    new_fn = File.join(self.dir,new_fn_base)

    p new_fn

    %x{mv #{fn} #{new_fn} }

    #create_thumbnail_for(new_fn)

  end

  def self.dir
    return File.join(RAILS_ROOT,'outbox')
  end

=begin
  def self.create_thumbnail_for(fn)
    gs_cmds << '-dTextAlphaBits=4'
    gs_cmds << '-dGraphicsAlphaBits=4'
    gs_cmds << '-dNOPAUSE'
    gs_cmds << '-dBATCH'
    gs_cmds << '-sDEVICE=png16m'
    gs_cmds << '-r9.06531732174037'
    gs_cmds << "-sOutputFile=#{fn}_thumbnail.png"
    gs_cmds << <<eos
-c "save pop currentglobal true setglobal false/product where{pop product(Ghostscript)search{pop pop pop revision 600 ge{pop true}if}{pop}ifelse}if{/pdfdict where{pop pdfdict begin/pdfshowpage_setpage[pdfdict/pdfshowpage_setpage get{dup type/nametype eq{dup/OutputFile eq{pop/AntiRotationHack}{dup/MediaBox eq revision 650 ge and{/THB.CropHack{1 index/CropBox pget{2 index exch/MediaBox exch put}if}def/THB.CropHack cvx}if}ifelse}if}forall]cvx def end}if}if setglobal
eos
    gs_cmds << "-f #{fn}.pdf"
    gs_cmds = []
    %x{ gs gc_cmds.join(' ')}
  end
=end

end

=begin

# gs -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dNOPAUSE -dBATCH -sDEVICE=png16m -r9.06531732174037 -sOutputFile=thb%d.png -c "save pop currentglobal true setglobal false/product where{pop product(Ghostscript)search{pop pop pop revision 600 ge{pop true}if}{pop}ifelse}if{/pdfdict where{pop pdfdict begin/pdfshowpage_setpage[pdfdict/pdfshowpage_setpage get{dup type/nametype eq{dup/OutputFile eq{pop/AntiRotationHack}{dup/MediaBox eq revision 650 ge and{/THB.CropHack{1 index/CropBox pget{2 index exch/MediaBox exch put}if}def/THB.CropHack cvx}if}ifelse}if}forall]cvx def end}if}if setglobal" -f document.pdf

=end
