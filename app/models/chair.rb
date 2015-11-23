class Chair < ActiveRecord::Base

  # has_many :chairs_administrators;
  # has_many :administrators, :class_name => 'User', through: :chairs_administrators, source: :user;
  # has_many :chairs_wimis;
  # has_many :wimis, :class_name => 'User', through: :chairs_wimis;
  # has_many :chairs_candidates;
  # has_many :candidates, :class_name => 'User', through: :chairs_candidates;
  has_many :projects;
  has_many :chair_admins;
  has_many :admins, :class_name => 'User', through: :chair_admins, :source => :user;

end
