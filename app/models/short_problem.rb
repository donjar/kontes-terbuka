# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: short_problems
#
#  id            :integer          not null, primary key
#  contest_id    :integer          not null
#  problem_no    :integer          not null
#  statement     :string           default(""), not null
#  answer        :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  start_time    :datetime
#  end_time      :datetime
#  correct_score :integer          default(1)
#  wrong_score   :integer          default(0)
#  empty_score   :integer          default(0)
#
# Indexes
#
#  index_short_problems_on_contest_id_and_problem_no  (contest_id,problem_no) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contest_id => contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

class ShortProblem < ActiveRecord::Base
  has_paper_trail

  include ProblemTimesValidation

  # Associations
  belongs_to :contest

  has_many :short_submissions
  has_many :user_contests, through: :short_submissions

  validates :problem_no, numericality: { greater_than_or_equal_to: 1 }

  def start_time_is_nil
    start_time.nil?
  end

  def end_time_is_nil
    end_time.nil?
  end

  # Methods
  def most_answer
    ShortProblem.find_by_sql ['SELECT answer, COUNT(*) AS count ' \
                              'FROM short_submissions ' \
                              'WHERE short_problem_id = ? ' \
                              'GROUP BY answer HAVING COUNT(*) = ' \
                              '(SELECT COUNT(*) FROM short_submissions ' \
                              'WHERE short_problem_id = ? ' \
                              'GROUP BY answer ORDER BY COUNT(*) DESC LIMIT 1)',
                              id, id]
  end

  scope(:in_time, lambda {
    where('start_time IS NULL OR start_time <= ?', Time.zone.now)
    .where('end_time IS NULL OR end_time >= ?', Time.zone.now)
  })

  def correct_answers
    short_submissions.where(answer: answer).count
  end
end
