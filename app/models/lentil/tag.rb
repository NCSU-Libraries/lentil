# == Schema Information
#
# Table name: lentil_tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lentil::Tag < ActiveRecord::Base
  attr_accessible :name, :staff_tag

  has_many :tagset_assignments
  has_many :tagsets, :through=>:tagset_assignments

  has_many :taggings
  has_many :images, :through=>:taggings

  validates_presence_of :name

  scope :harvestable, where(:lentil_tagsets => {:harvest => true}).includes(:tagsets)
  scope :not_harvestable, where(:lentil_tagsets => {:harvest => false}).includes(:tagsets)
  scope :no_tagsets, where(:lentil_tagset_assignments => {:tag_id => nil}).includes(:tagset_assignments)

  #Stripping tags on write
  def name=(new_name)
    write_attribute(:name, new_name.sub(/^#/, ''))
  end
end
