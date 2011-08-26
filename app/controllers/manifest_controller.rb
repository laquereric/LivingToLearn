class ManifestController  < ApplicationController

  def manifest_content
    r = <<-MANIFESTCONTENT
CACHE MANIFEST

404.html

NETWORK:
*

MANIFESTCONTENT
    return r
  end

  def manifest
    response.headers["Content-Type"]= "text/cache-manifest"
    render :inline => self.manifest_content
  end

end

