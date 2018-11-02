class Product < ApplicationRecord
  belongs_to :user

  has_one_attached :image


# adds validation and sanitization to fields of product form when creating and updating a product
  validates :product_title, presence: true, length: {maximum: 50}
  validates :description, presence: true, length: {minimum: 10}
  validates :price, presence: true, numericality: true
  validates :medium, presence: true, length: {maximum: 25}
  validates :quantity, presence: true, numericality: {only_integer: true}
  validates :creator, presence: true, length: {maximum: 50}

  # validate :image_is_attached

  ## image validation using the activestorage-validator gem
  validates :image, presence: {message: 'required'}, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  # validates if a user has authorisation to make changes
  def can_change?(user)
    self.user == user || user.has_role?(:admin)
  end
  
  private
  # image validation
  def image_is_attached
    if !image.attached?
      errors.add(:image, 'required.') 
    elsif image.attached? && !image.blob.content_type.start_with?('/image')
      errors.add(:image, 'must be a JPEG, or PNG')       
    end
  end
end
