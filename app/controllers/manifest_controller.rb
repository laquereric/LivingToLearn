class ManifestController  < ApplicationController
  def manifest_content
manifest_content = <<-MANIFESTCONTENT
CACHE MANIFEST

MANIFESTCONTENT
  end

  def manifest
    render :inline => self.manifest_content
  end

end

