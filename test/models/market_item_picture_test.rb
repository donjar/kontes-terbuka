# frozen_string_literal: true
# == Schema Information
#
# Table name: market_item_pictures
#
#  id                   :integer          not null, primary key
#  market_item_id       :integer          not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_market_item_pictures_on_market_item_id  (market_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (market_item_id => market_items.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength
