class IconPhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg)
  end

  def content_type_whitelist
    /image\//
  end
  
  def size_range
    1..20.megabytes
  end
end
