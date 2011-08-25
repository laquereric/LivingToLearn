class ManifestController  < ApplicationController

  def manifest_content
    r = <<-MANIFESTCONTENT
CACHE MANIFEST

http://lvh.me:3001/404.html

MANIFESTCONTENT
    return r
  end

  def manifest
    response.headers["Content-Type"]= "text/cache-manifest"
    render :inline => self.manifest_content
  end

end

