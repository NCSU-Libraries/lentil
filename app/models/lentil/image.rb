# == Schema Information
#
# Table name: lentil_images
#
#  id                             :integer          not null, primary key
#  description                    :text
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  like_votes_count               :integer          default(0)
#  url                            :string(255)
#  user_id                        :integer
#  state                          :integer          default(0)
#  external_identifier            :string(255)
#  long_url                       :string(255)
#  original_metadata              :text
#  original_datetime              :datetime
#  staff_like                     :boolean          default(FALSE)
#  moderator_id                   :integer
#  moderated_at                   :datetime
#  second_moderation              :boolean          default(FALSE)
#  wins_count                     :integer          default(0)
#  losses_count                   :integer          default(0)
#  win_pct                        :float
#  popular_score                  :integer          default(0)
#  file_harvested_date            :datetime
#  file_harvest_failed            :integer          default(0)
#  donor_agreement_submitted_date :datetime
#  donor_agreement_failed         :integer          default(0)
#  failed_file_checks             :integer          default(0)
#  file_last_checked              :datetime
#  donor_agreement_rejected       :datetime
#  do_not_request_donation        :boolean
#

class Lentil::Image < ActiveRecord::Base
  attr_accessible :description, :title, :user_id, :state, :staff_like, :url, :long_url, :external_identifier,
                  :original_datetime, :popular_score, :taggings, :tag_id, :moderator, :moderated_at, :second_moderation,
                  :do_not_request_donation, :donor_agreement_rejected

  has_many :won_battles, :class_name => "Battle"
  has_many :losers, :through => :battles
  has_many :lost_battles, :class_name => "Battle", :foreign_key => "loser_id"
  has_many :winners, :through => :lost_battles, :source => :image

  has_many :like_votes
  has_many :flags

  belongs_to :user, counter_cache: true
  has_one :service, :through => :user

  has_many :taggings
  has_many :tags, :through=>:taggings

  has_many :licensings
  has_many :licenses, :through=>:licensings

  serialize :original_metadata, Hash

  belongs_to :moderator, :class_name => Lentil::AdminUser

  default_scope where("failed_file_checks < 3")

  validates_uniqueness_of :external_identifier, :scope => :user_id
  validates :url, :format => URI::regexp(%w(http https))

  def self.search(page, number_to_show = nil)
    unless number_to_show.nil?
      paginate :per_page => 20, :page => page, :total_entries => number_to_show
    else
      paginate :per_page => 20, :page => page
    end
  end

  def self.recent
    order("original_datetime DESC")
  end

  def self.staff_picks
    where(:staff_like => true).order("original_datetime DESC")
  end

  def self.popular
    order("popular_score DESC").order("like_votes_count DESC")
  end

  def self.approved
    where(state: self::States[:approved])
  end

  def self.blend
    (popular.limit(50) + recent.limit(100) + staff_picks.limit(150)).uniq.shuffle
  end

  def service_tags
    begin
      tag_ids = self.taggings.where(:staff_tag => false).pluck(:tag_id)
      tags = Lentil::Tag.find(tag_ids).sort_by(&:name)
    rescue
      Rails.logger.error "Error retrieving service_tags"
      tags = []
    end
  end

  def staff_tags
    begin
      tag_ids = self.taggings.where(:staff_tag => true).pluck(:tag_id)
      tags = Lentil::Tag.find(tag_ids).sort_by(&:name)
    rescue
      Rails.logger.error "Error retrieving staff_tags"
      tags = []
    end
  end

  def available_staff_tags
    begin
      system_tag_ids = self.taggings.where(:staff_tag => false).pluck(:tag_id)
    rescue
      Rails.logger.error "Error retrieving staff_tags"
      tags = []
    else
      tags = []
      Lentil::Tag.all.each do |tag|
        unless system_tag_ids.include? tag.id
          tags.push(tag)
        end
      end

      if tags.length > 0
        tags = tags.sort_by(&:name)
      end
    end
  end

  def battles
    self.won_battles + self.lost_battles
  end

  def battles_count
    self.wins_count + self.losses_count
  end

  # legacy
  def image_url
    large_url
  end

  # legacy
  def jpeg
    large_url
  end

  def protocol_relative_url
    # instagr.am returns 301 to instagram.com and invalid SSL certificate
    url.sub(/^http:/, '').sub(/\/\/instagr\.am/, '//instagram.com')
  end

  def large_url(protocol_relative = true)
    if protocol_relative
      protocol_relative_url + 'media/?size=l'
    else
      url + 'media/?size=l'
    end
  end

  def medium_url(protocol_relative = true)
    if protocol_relative
      protocol_relative_url + 'media/?size=m'
    else
      url + 'media/?size=m'
    end
  end

  def thumbnail_url(protocol_relative = true)
    if protocol_relative
      protocol_relative_url + 'media/?size=t'
    else
      url + 'media/?size=t'
    end
  end

  States = {
   :pending => 0,
   :approved => 1,
   :rejected => 2,
  }

  state_machine :state, :initial => :pending do

    States.each do |name, value|
      state name, :value => value
    end

    event :approve do
      transition all => :approved
    end

    event :reject do
      transition all => :rejected
    end

  end
end
