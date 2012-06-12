# -*- encoding : utf-8 -*-
require 'mongoid_paperclip'

module Telasi::StandardPhoto
  # აბრუნებს 100x100 ფოტოსურათს.
  def normal_photo
    if self.photo.file?
      photo.url(:normal)
    elsif self.class == User
      '/assets/profile100.png'
    else
      '/assets/no-image100.png'
    end
  end

  # აბრუნებს 45x45 ფოტოსურათს.
  def small_photo
    if  self.photo.file?
      photo.url(:small)
    elsif self.class == User
      '/assets/profile45.png'
    else
      '/assets/no-image45.png'
    end
  end

  def self.included(base)
    base.send :include, Mongoid::Paperclip
    base.has_mongoid_attached_file :photo, :styles => { :normal => "100x100#", :small => "45x45#"},
      :url  => "/photos/#{base.name.downcase}/:id/:style/:basename.:extension",
      :path => ":rails_root/public/photos/#{base.name.downcase}/:id/:style/:basename.:extension"
  end
end
