class DocumentUploader < CarrierWave::Uploader::Base
  storage :grid_fs

  # ფაილის ზომის წარმოჩენა.
  def size
    size = self.file.size
    if size > 1024 * 1024
      "#{size / 1024 / 1024} MB"
    elsif size > 1024
      "#{size / 1024} KB"
    else
      "#{size} B"
    end
  end
end