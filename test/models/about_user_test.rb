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

require 'test_helper'

class AboutUserTest < ActiveSupport::TestCase
  test 'about user should save' do
    assert build(:about_user).save, 'about user cannot be saved'
  end

  test 'about user associations' do 
    assert_equal AboutUser.reflect_on_association(:user).macro, :belongs_to,
      'about user relation is not belongs to user.'
  end

  test 'attachments' do 
    about_user = build(:about_user, image: PNG)
    assert about_user.save, 'About user image cannot be saved'
  end
end
