class Movie < ActiveRecord::Base

  has_many :reviews
  mount_uploader :poster_image, PosterImageUploader
  scope :search, -> (search) { where("title LIKE ? or director LIKE ?", "%#{search[:search]}%", "%#{search[:search]}%").where("runtime_in_minutes #{search[:duration]}") }

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  validates :poster_image, presence: true
  validates :release_date, presence: true
  validate :release_date_is_in_the_past

  def review_average
    unless reviews.size == 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    end
  end

  protected

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end
  end


end
