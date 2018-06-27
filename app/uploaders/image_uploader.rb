class ImageUploader < CarrierWave::Uploader::Base

  if Rails.env.production?
    include Cloudinary::CarrierWave
    process :convert => 'png'
    process :tags => ['image']
    # storage :fog

    def public_id
      return "simple_sns/" + Cloudinary::Utils.random_public_id;
    end
  else
    include CarrierWave::RMagick
    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  process :resize_to_limit => [700, 700]

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [50, 50]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_whitelist
     %w(jpg jpeg gif png)
   end

  #ファイルサイズ制限
  def size_range
    1..9.megabytes
  end
end
