# == Schema Information
#
# Table name: lentil_tagsets
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  harvest     :boolean          default(FALSE)
#

class Lentil::Tagset < ActiveRecord::Base

  has_many :tagset_assignments, :dependent => :destroy
  has_many :tags, :through => :tagset_assignments

  # validates_presence_of :title
  validates :title, {:presence => true, :uniqueness => {:case_sensitive => false}}
  validates :tags, :presence => true
end
