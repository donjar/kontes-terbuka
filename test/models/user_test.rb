# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  hashed_password :string           not null
#  fullname        :string           not null
#  school          :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  salt            :string           not null
#  auth_token      :string           not null
#  province_id     :integer
#  status_id       :integer
#  color_id        :integer          default(1), not null
#  timezone        :string           default("WIB"), not null
#  verification    :string
#  enabled         :boolean          default(FALSE), not null
#  tries           :integer          default(0), not null
#  referrer_id     :integer
#
# Indexes
#
#  index_users_on_auth_token    (auth_token) UNIQUE
#  index_users_on_color_id      (color_id)
#  index_users_on_email         (email) UNIQUE
#  index_users_on_province_id   (province_id)
#  index_users_on_referrer_id   (referrer_id)
#  index_users_on_status_id     (status_id)
#  index_users_on_username      (username) UNIQUE
#  index_users_on_username_gin  (username) USING gin
#  index_users_on_verification  (verification) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (color_id => colors.id) ON DELETE => nullify
#  fk_rails_...  (province_id => provinces.id) ON DELETE => nullify
#  fk_rails_...  (status_id => statuses.id) ON DELETE => nullify
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user that fulfills all criteria is OK' do
    assert build(:user).save, 'User is not saved'
  end

  test 'username exists' do
    assert_not build(:user, username: nil).save,
               'User without username is saved'
  end

  test 'username is unique' do
    create(:user, username: 'asdfasdf')
    assert_not build(:user, username: 'asdfasdf', email: 'other@a.com').save,
               'User with duplicate usernames can be saved'
  end

  test 'username should have 6 to 20 characters' do
    25.times.each do |i|
      unless i >= 6 && i <= 20
        assert_not build(:user, username: 'a' * i).save,
                   "User with #{i} chars can be saved"
      end
    end
  end

  test 'username should be alphanumeric' do
    assert_not build(:user, username: 'asdfg ').save,
               'User with a space can be saved'
    assert_not build(:user, username: ' halo halo').save,
               'User with a space can be saved'
    assert_not build(:user, username: '        ').save,
               'User with a space can be saved'
    assert_not build(:user, username: 'aw\#@#').save,
               'Usernames with a symbol can be saved'
    assert_not build(:user, username: '234234_cd7').save,
               'Usernames with a symbol can be saved'
    assert_not build(:user, username: '-_--_-').save,
               'Usernames with a symbol can be saved'
  end

  test 'email should exist' do
    assert_not build(:user, email: nil).save,
               'User without email is able to be saved'
  end

  test 'email should be unique' do
    create(:user, email: 'a@b.com')
    assert_not build(:user, username: 'hahahaha', email: 'a@b.com').save,
               'User with duplicate email can be saved'
  end

  test 'email should have one @' do
    assert build(:user, username: 'asdfgh', email: 'a@b.com').save,
           'a@b.com cannot be saved.'
    assert build(:user, username: 'ghasdf', email: 'a@u.nus.edu').save,
           'a@u.nus.edu cannot be saved.'
    assert build(:user, username: 'asdfqw', email: 'ab_cd_ef.gh@a.b.c.d').save,
           'ab_cd_ef.gh@a.b.c.d cannot be saved.'

    assert_not build(:user, email: 'a@b@c.com').save, 'a@b@c.com can be saved.'
    assert_not build(:user, email: 'abc.com').save, 'abc.com can be saved.'
  end

  test 'full name should exist' do
    assert_not build(:user, fullname: nil).save,
               'User with no full name can be saved.'
  end

  test 'school should exist' do
    assert_not build(:user, school: nil).save,
               'User with no school can be saved.'
  end

  test 'timezone follows province' do
    prov = create(:province, timezone: 'WIT')
    assert_equal create(:user, province: prov).timezone, 'WIT',
                 'User timezone is not defaulted to the province.'
  end

  test 'user is not enabled by default' do
    assert_not create(:user).enabled, 'User is enabled on creation.'
  end

  test 'user tries start with 0' do
    assert create(:user).tries.zero?, 'User does not start with zero tries.'
  end

  test 'nullify attributes on delete' do
    u = create(:user)
    u.province.destroy
    assert_nil u.reload.province, 'Province is not nullified on delete.'
    u.color.destroy
    assert_equal u.reload.color_id, 1, 'Color is not default on delete.'
    u.status.destroy
    assert_nil u.reload.status, 'Status is not nullified on delete.'
  end

  test 'user associations' do
    assert_equal User.reflect_on_association(:province).macro, :belongs_to,
                 'User does not belong to province.'
    assert_equal User.reflect_on_association(:color).macro, :belongs_to,
                 'User does not belong to color.'
    assert_equal User.reflect_on_association(:status).macro, :belongs_to,
                 'User does not belong to status.'
    assert_equal User.reflect_on_association(:referrer).macro, :belongs_to,
                 'User does not belong to referrer.'
    assert_equal User.reflect_on_association(:user_contests).macro, :has_many,
                 'User has many user contests is false.'
    assert_equal User.reflect_on_association(:user_awards).macro, :has_many,
                 'User has many user awards is false.'
    assert_equal User.reflect_on_association(:temporary_markings).macro,
                 :has_many,
                 'User has many temporary markings contests is false.'
    assert_equal User.reflect_on_association(:user_notifications).macro,
                 :has_many,
                 'User has many user notifications contests is false.'
    assert_equal User.reflect_on_association(:point_transactions).macro,
                 :has_many,
                 'User has many point transactions contests is false.'
  end

  test 'tries need to be >= 0' do
    assert_not build(:user, tries: -2).save,
               'User with negative tries can be saved.'
  end

  test 'terms of service needs to be accepted' do
    assert_not build(:user, terms_of_service: '0').save,
               'User that does not accept terms of service can be registered.'
  end

  test 'user is displayed by its username' do
    assert_equal create(:user, username: 'qwerty').to_s, 'qwerty'
  end

  test 'in params, user is shown as its ID followed by its username' do
    u1 = create(:user, username: 'qwerty')
    u2 = create(:user, username: 'ASDFGH')
    u3 = create(:user, username: 'ZxCvBnM123')

    assert_equal u1.to_param, "#{u1.id}-qwerty"
    assert_equal u2.to_param, "#{u2.id}-asdfgh"
    assert_equal u3.to_param, "#{u3.id}-zxcvbnm123"
  end

  test 'user becomes veteran if osn is checked' do
    assert create(:user, osn: '1').has_role?(:veteran)
  end

  test 'non-panitia user cannot be added admin' do
    u = create(:user)
    assert_raises(Exception) { u.add_role(:problem_admin) }
    assert_raises(Exception) { u.add_role(:admin) }
  end

  test 'points are sum of pointtransactions' do
    u = create(:user)
    (-9..10).each { |p| create(:point_transaction, user: u, point: p) }
    assert_equal u.point, 10
  end

  test 'reset password' do
    u = create(:user)
    u.enable
    u.reset_password

    assert_not u.verification.nil?, 'On forgot password process,
    user verification is nil'
    assert u.enabled, 'On forgot password process, user is disabled'
  end

  test 'status cannot be nil when saved' do
    assert_not build(:user, status_id: nil).save,
               'User with nil status can be saved.'
  end

  test 'province cannot be nil when saved' do
    assert_not build(:user, province_id: nil).save,
               'User with nil province can be saved.'
  end

  test 'user is saved lowercase' do
    u = create(:user, username: 'ASDFGH')
    assert_equal u.username, 'asdfgh', 'User is not saved lowercase.'
  end
end
