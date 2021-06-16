# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: about_users
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  name               :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :bigint(8)
#  image_updated_at   :datetime
#  is_alumni          :boolean
#
# rubocop:enable Metrics/LineLength

class AboutUser < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_attached_file :image, styles: { small: '150x150>' }
  
  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates_attachment :image, presence: true
  validates_attachment_content_type :image, content_type: ['image/png', 'image/jpeg', 'image/jpg']
end
