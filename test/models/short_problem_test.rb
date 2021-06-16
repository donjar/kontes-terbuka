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

require 'test_helper'

class ShortProblemTest < ActiveSupport::TestCase
  test 'short problem can be saved' do
    assert build(:short_problem).save, 'Short problem cannot be saved'
  end

  test 'short problem associations' do
    assert_equal ShortProblem.reflect_on_association(:contest).macro,
                 :belongs_to,
                 'Short Problem relation is not belongs to contest.'
    assert_equal ShortProblem.reflect_on_association(:short_submissions).macro,
                 :has_many,
                 'Short Problem relation is not has many short submissions.'
  end

  test 'contest cannot be null' do
    assert_not build(:short_problem, contest_id: nil).save,
               'Short Problem with null contest id can be saved.'
  end

  test 'problem number cannot be null' do
    assert_not build(:short_problem, problem_no: nil).save,
               'Short Problem with null problem number can be saved.'
  end

  test 'problem no >= 1' do
    15.times do |n|
      no = n - 7
      if no < 1
        assert_not build(:short_problem, problem_no: no).save,
                   'Short Problem with no < 1 can be saved.'
      else
        assert build(:short_problem, problem_no: no).save,
               'Short Problem with no >= 1 cannot be saved.'
      end
    end
  end

  test 'times must be between contest times' do
    c = create(:contest, start: 100, ends: 200, result: 300, feedback: 400)
    assert build(:short_problem, contest: c,
                                 start_time: c.start_time + 50.seconds).save,
           'Short problem with start time > contest start time cant save.'
    assert build(:short_problem, contest: c,
                                 start_time: c.start_time).save,
           'Short problem with start time = contest start time cant save.'
    assert build(:short_problem, contest: c,
                                 start_time: nil).save,
           'Short problem with start time nil cant save.'
    assert_not build(:short_problem,
                     contest: c,
                     start_time: c.start_time - 50.seconds).save,
               'Problem with start time < contest start time can save.'

    assert build(:short_problem, contest: c,
                                 end_time: c.end_time - 50.seconds).save,
           'Short problem with end time < contest start time cant save.'
    assert build(:short_problem, contest: c,
                                 end_time: c.end_time).save,
           'Short problem with end time = contest start time cant save.'
    assert build(:short_problem, contest: c,
                                 end_time: nil).save,
           'Short problem with end time nil cant save.'
    assert_not build(:short_problem, contest: c,
                                     end_time: c.end_time + 50.seconds).save,
               'Problem with end time > contest end time can save.'

    assert_not build(:short_problem,
                     contest: c,
                     start_time: Time.zone.now + 160.seconds,
                     end_time: Time.zone.now + 140.seconds).save,
               'Problem with start time > end time can save.'
  end

  test 'in_time' do
    c = create(:contest, start: -100, ends: 100, result: 300, feedback: 400)

    create(:short_problem, start_time: Time.zone.now - 80.seconds,
                           end_time: Time.zone.now - 40.seconds,
                           contest: c)
    sp = create(:short_problem, start_time: Time.zone.now - 20.seconds,
                                end_time: Time.zone.now + 20.seconds,
                                contest: c)
    create(:short_problem, start_time: Time.zone.now + 40.seconds,
                           end_time: Time.zone.now + 80.seconds,
                           contest: c)

    assert_equal c.short_problems.in_time, [sp],
                 'Got problem in the in_time method'
  end

  test 'answer cannot be null' do
    assert_not build(:short_problem, answer: nil).save,
               'Short Problem with null answer can be saved.'
  end

  test 'statement cannot be null' do
    assert_not build(:short_problem, statement: nil).save,
               'Short Problem with null statement can be saved.'
  end

  test 'unique pair on contest and problem no' do
    sp = create(:short_problem)
    assert_not build(:short_problem, contest: sp.contest,
                                     problem_no: sp.problem_no).save,
               'Short Problem with null statement can be saved.'
  end

  test 'most answer' do
    sp = create(:short_problem)
    %w[2 2 2 2 3 3 4 4 4 5].each do |ans|
      create(:short_submission, short_problem: sp, answer: ans)
    end

    assert_equal sp.most_answer.map(&:answer), ['2'],
                 'ShortProblem most answer is not working'

    sp2 = create(:short_problem)
    %w[2 2 2 3 3 3 4 4 4 5].each do |ans|
      create(:short_submission, short_problem: sp2, answer: ans)
    end

    assert_equal sp2.most_answer.map(&:answer).sort, %w[2 3 4],
                 'ShortProblem most answer is not working'
  end

  test 'correct answers' do
    sp = []
    6.times do |ans|
      sp[ans] = create(:short_problem, answer: ans.to_s)
    end

    6.times do |i|
      (i + 1).times do |ans|
        create(:short_submission, short_problem: sp[ans], answer: ans.to_s)
      end
    end

    6.times do |ans|
      assert_equal sp[ans].correct_answers, 6 - ans,
                   'correct_answers is not working'
    end
  end
end
