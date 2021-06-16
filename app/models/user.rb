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

class User < ActiveRecord::Base
  include UserPasswordVerification
  rolify before_add: :before_add_method
  has_paper_trail

  # Callbacks
  after_save { user_contests.each { |uc| uc.contest.refresh } }
  before_validation(on: :create) do
    generate_token(:auth_token)
    generate_token(:verification)
    self.timezone = province.nil? ? 'WIB' : province.timezone
  end

  before_validation do
    encrypt_password unless password.nil?
    if username
      username.downcase!
    else
      false
    end
  end

  before_create do
    # Rollback if province/status is nil.
    # Province/status can only be nil if the corresponding object is deleted
    if province_id.nil? || status_id.nil?
      errors.add(:province, 'cannot be nil on create') if province_id.nil?
      errors.add(:status, 'cannot be nil on create') if status_id.nil?
      false
    end
  end

  before_save do
    add_role(:veteran) if osn == '1'
  end

  after_save :clear_password

  def before_add_method(role)
    return if !Role.admins.include?(role.name) || has_role?(:panitia)
    raise 'User is not panitia! Run `User.find(your_id).add_role :panitia` first.'
  end

  # Associations
  belongs_to :province
  belongs_to :status
  belongs_to :color
  belongs_to :referrer

  has_many :user_contests
  has_many :long_submissions, through: :user_contests
  has_many :long_problems, through: :user_contests
  has_many :submission_pages, through: :user_contests
  has_many :contests, through: :user_contests

  has_many :user_awards
  has_many :awards, through: :user_awards

  has_many :temporary_markings
  has_many :marked_long_submissions, through: :temporary_markings,
                                     class_name: 'LongSubmission'

  has_many :user_notifications
  has_many :notifications, through: :user_notifications

  has_many :point_transactions

  has_one :about_user, dependent: :destroy
  accepts_nested_attributes_for :about_user

  # Validations
  validates :password, presence: true, confirmation: true, on: :create
  validates :username, length: { in: 6..20 },
                       format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :email, format: { with: /\A[^@\s]+@([^@\s]+)\z/ }
  validates :tries, numericality: { greater_than_or_equal_to: 0 }

  validates :password, presence: true, confirmation: true, on: :create
  validates :terms_of_service, acceptance: true

  # NOTE: This needs to come before the validation.
  def self.time_zone_set
    %w[WIB WITA WIT]
  end

  validates :timezone, presence: true,
                       inclusion: {
                         in: time_zone_set,
                         message: 'Zona waktu tidak tersedia'
                       }

  # Other ActiveRecord
  attr_accessor :password
  attr_accessor :osn

  # Display methods
  def to_s
    username
  end

  def to_param
    "#{id}-#{username.downcase}"
  end

  # Other methods

  def point
    PointTransaction.where(user: self).sum(:point)
  end

  def self.get_user(username_or_email)
    User.find_by('username ILIKE ? OR email = ?', username_or_email,
                 username_or_email)
  end
end
