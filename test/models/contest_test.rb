# frozen_string_literal: true

# == Schema Information
#
# Table name: contests
#
#  id                          :integer          not null, primary key
#  name                        :string           not null
#  start_time                  :datetime         not null
#  end_time                    :datetime         not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  problem_pdf_file_name       :string
#  problem_pdf_content_type    :string
#  problem_pdf_file_size       :integer
#  problem_pdf_updated_at      :datetime
#  rule                        :text             default("")
#  result_time                 :datetime         not null
#  feedback_time               :datetime         not null
#  gold_cutoff                 :integer          default(0), not null
#  silver_cutoff               :integer          default(0), not null
#  bronze_cutoff               :integer          default(0), not null
#  result_released             :boolean          default(FALSE), not null
#  problem_tex_file_name       :string
#  problem_tex_content_type    :string
#  problem_tex_file_size       :integer
#  problem_tex_updated_at      :datetime
#  marking_scheme_file_name    :string
#  marking_scheme_content_type :string
#  marking_scheme_file_size    :integer
#  marking_scheme_updated_at   :datetime
#  book_promo                  :string
#  timer                       :string
#
# Indexes
#
#  index_contests_on_end_time       (end_time)
#  index_contests_on_feedback_time  (feedback_time)
#  index_contests_on_result_time    (result_time)
#  index_contests_on_start_time     (start_time)
#

require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  test 'contest can be saved' do
    assert build(:contest).save, 'Contest cannot be saved'
  end

  test 'default rule is from Social' do
    assert_equal create(:contest).rule, Social.default_rules,
                 'Contest rule default is not good.'
  end

  test 'contest associations' do
    assert_equal Contest.reflect_on_association(:user_contests).macro,
                 :has_many,
                 'Contest does not have many user contests.'
    assert_equal Contest.reflect_on_association(:short_problems).macro,
                 :has_many,
                 'Contest does not have many short problems.'
    assert_equal Contest.reflect_on_association(:long_problems).macro,
                 :has_many,
                 'Contest does not have many long problems.'
    assert_equal Contest.reflect_on_association(:feedback_questions).macro,
                 :has_many,
                 'Contest does not have many feedback questions.'
  end

  test 'attachments' do
    c = build(:contest, problem_pdf: PDF)
    assert c.save, 'Contest with PDF problem cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'problems',
                                       c.id.to_s, 'soal.pdf')),
           'PDF problem file is not uploaded.'
    assert_not build(:contest, problem_pdf: TEX).save,
               'Contest with invalid problem PDF can be saved.'

    c = build(:contest, marking_scheme: PDF)
    assert c.save, 'Contest with valid marking scheme cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'problems',
                                       c.id.to_s, 'ms.pdf')),
           'Marking scheme is not uploaded.'
    c = build(:contest, problem_tex: TEX)
    assert c.save, 'Contest with TeX problem cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'problems',
                                       c.id.to_s, 'soal.tex')),
           'TeX problem file is not uploaded.'
    assert_not build(:contest, problem_tex: PDF).save,
               'Contest with invalid problem PDF can be saved.'
  end

  test 'name must exist' do
    assert_not build(:contest, name: nil).save,
               'Contest with no name can be saved.'
  end

  test 'end time must exist' do
    assert_not build(:contest, end_time: nil).save,
               'Contest with no end time can be saved.'
  end

  test 'start time must exist' do
    assert_not build(:contest, start_time: nil).save,
               'Contest with no start time can be saved.'
  end

  test 'result time must exist' do
    assert_not build(:contest, result_time: nil).save,
               'Contest with no result time can be saved.'
  end

  test 'feedback time must exist' do
    assert_not build(:contest, feedback_time: nil).save,
               'Contest with no feedback time can be saved.'
  end

  test 'cutoffs' do
    c = create(:contest)
    assert_equal c.gold_cutoff, 0,
                 'Contest does not have zero gold cutoff as default.'
    assert_equal c.silver_cutoff, 0,
                 'Contest does not have zero silver cutoff as default.'
    assert_equal c.bronze_cutoff, 0,
                 'Contest does not have zero bronze cutoff as default.'

    assert_not build(:contest, gold_cutoff: nil).save,
               'Contest with nil gold cutoff can be saved.'
    assert_not build(:contest, silver_cutoff: nil).save,
               'Contest with nil silver cutoff can be saved.'
    assert_not build(:contest, bronze_cutoff: nil).save,
               'Contest with nil bronze cutoff can be saved.'
  end

  test 'result released cannot be nil' do
    assert_not build(:contest, result_released: nil).save,
               'Contest with nil result released can be saved.'
  end

  test 'start time must be before end time' do
    assert_not build(:contest, start_time: Time.zone.now,
                               end_time: Time.zone.now - 10.seconds).save,
               'Contest with start time > end time can be saved.'
  end

  test 'end time must be before result time' do
    assert_not build(:contest, start_time: Time.zone.now,
                               end_time: Time.zone.now + 10.seconds,
                               result_time: Time.zone.now + 5.seconds).save,
               'Contest with end time > result time can be saved.'
  end

  test 'result time must be before feedback time' do
    assert_not build(:contest, start: 0, ends: 10,
                               result: 20, feedback: 15).save,
               'Contest with result time > feedback time can be saved.'
  end

  test 'result can only be released after contest ended' do
    c = create(:contest, ends: 10)
    create(:feedback_question, contest: c)
    assert_not c.update(result_released: true),
               'Contest that has not ended can have results released'
  end

  test 'result can only be released with feedback questions' do
    c = create(:contest)
    assert_not c.update(result_released: true),
               'Contest that has no feedback questions can be released'
  end

  test 'next contest returns next smallest contest end time' do
    create(:contest, start: -5, ends: -3)
    c = create(:contest, ends: 5)
    create(:contest, ends: 10)
    create(:contest, ends: 20)
    assert_equal Contest.next_contest.id, c.id,
                 'Next contest does not return the contest with smallest ' \
  'end time from now'
  end

  test 'next important contest returns closest feedback or end time' do
    c = create(:contest, start: -5, ends: -3, feedback: 45)
    assert_equal Contest.next_important_contest.id, c.id,
                 'Next important contest does not return closest ' \
                 'end/feedback time'
  end

  test 'next important contest returns closest feedback or end time 2' do
    create(:contest, ends: 30, feedback: 45)
    c = create(:contest, start: -5, ends: -3, result: 20, feedback: 25)
    assert_equal Contest.next_important_contest.id, c.id,
                 'Next important contest does not return closest ' \
                 'end/feedback time'
  end

  test 'next important contest returns closest feedback or end time 3' do
    create(:contest, ends: 30, feedback: 45)
    c = create(:contest, ends: 20, feedback: 90)
    assert_equal Contest.next_important_contest.id, c.id,
                 'Next important contest does not return closest ' \
                 'end/feedback time'
  end

  test 'refresh contest' do
    c = create(:contest)
    c.refresh

    jobs = Delayed::Job.where(queue: "contest_#{c.id}").select do |j|
      handler = YAML.load(j.handler)
      handler.method_name == :refresh_results_pdf
    end
    assert_equal jobs.count, 1, 'Refresh results pdf not created.'
    assert_in_delta Time.zone.now, jobs.first.run_at, 5,
                    'Calling refresh does not refresh immediately.'
  end
end
