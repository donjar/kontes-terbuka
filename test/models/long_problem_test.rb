# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: long_problems
#
#  id                  :integer          not null, primary key
#  contest_id          :integer          not null
#  problem_no          :integer          not null
#  statement           :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  report_file_name    :string
#  report_content_type :string
#  report_file_size    :integer
#  report_updated_at   :datetime
#  start_time          :datetime
#  end_time            :datetime
#  max_score           :integer          default(7)
#
# Indexes
#
#  index_long_problems_on_contest_id_and_problem_no  (contest_id,problem_no) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contest_id => contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class LongProblemTest < ActiveSupport::TestCase
  test 'long problem can be saved' do
    assert build(:long_problem).save, 'Long problem cannot be saved'
  end

  test 'long problem associations' do
    assert_equal LongProblem.reflect_on_association(:contest).macro,
                 :belongs_to,
                 'Long Problem relation is not belongs to contest.'
    assert_equal LongProblem.reflect_on_association(:long_submissions).macro,
                 :has_many,
                 'Long Problem relation is not has many long submissions.'
  end

  test 'attachments' do
    lp = build(:long_problem, report: PDF)
    assert lp.save, 'Long Problem with report cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'reports',
                                       lp.contest_id.to_s,
                                       "lap#{lp.contest_id}-#{lp.problem_no}" +
    File.extname(lp.report_file_name))), 'Long Problem report is not uploaded.'
  end

  test 'problem no >= 1' do
    15.times do |n|
      no = n - 7
      if no < 1
        assert_not build(:long_problem, problem_no: no).save,
                   'Long Problem with no < 1 can be saved.'
      else
        assert build(:long_problem, problem_no: no).save,
               'Long Problem with no >= 1 cannot be saved.'
      end
    end
  end

  test 'times must be between contest times' do
    c = create(:contest, start: 100, ends: 200, result: 300, feedback: 400)
    assert build(:long_problem, contest: c,
                                start_time: c.start_time + 50.seconds).save,
           'Long Problem with start time < contest start time cant save.'
    assert build(:long_problem, contest: c,
                                start_time: c.start_time).save,
           'Long Problem with start time = contest start time cant save.'
    assert build(:long_problem, contest: c,
                                start_time: nil).save,
           'Long Problem with start time nil cant save.'
    assert_not build(:long_problem,
                     contest: c,
                     start_time: c.start_time - 50.seconds).save,
               'Problem with start time >= contest start time can save.'

    assert build(:long_problem, contest: c,
                                end_time: c.end_time - 50.seconds).save,
           'Long Problem with start time < contest start time cant save.'
    assert build(:long_problem, contest: c,
                                end_time: c.end_time).save,
           'Long Problem with start time = contest start time cant save.'
    assert build(:long_problem, contest: c,
                                end_time: nil).save,
           'Long Problem with start time nil cant save.'
    assert_not build(:long_problem, contest: c,
                                    end_time: c.end_time + 50.seconds).save,
               'Problem with end time <= contest end time can save.'

    assert_not build(:long_problem,
                     contest: c,
                     start_time: Time.zone.now + 160.seconds,
                     end_time: Time.zone.now + 140.seconds).save,
               'Problem with start time > end time can save.'
  end

  test 'in_time' do
    c = create(:contest, start: -100, ends: 100, result: 300, feedback: 400)

    create(:long_problem, start_time: Time.zone.now - 80.seconds,
                          end_time: Time.zone.now - 40.seconds,
                          contest: c)
    lp = create(:long_problem, start_time: Time.zone.now - 20.seconds,
                               end_time: Time.zone.now + 20.seconds,
                               contest: c)
    create(:long_problem, start_time: Time.zone.now + 40.seconds,
                          end_time: Time.zone.now + 80.seconds,
                          contest: c)

    assert_equal c.long_problems.in_time, [lp],
                 'Got problem in the in_time method'
  end

  test 'to string' do
    lp = create(:long_problem)
    assert_equal lp.to_s, "#{lp.contest} no. #{lp.problem_no}",
                 'Long Problem to_s is not expected.'
  end

  test 'long problem needs a contest' do
    assert_not build(:long_problem, contest: nil).save,
               'Long Problem with no contest can be saved.'
  end

  test 'long problem needs a problem no' do
    assert_not build(:long_problem, problem_no: nil).save,
               'Long Problem with no problem number can be saved.'
  end

  test 'long problem has a unique (contest, problem no) pair' do
    lp = create(:long_problem)
    assert_not build(:long_problem, contest: lp.contest,
                                    problem_no: lp.problem_no).save,
               'Long Problem with duplicate contest and ' \
               'problem no can be saved.'
  end

  test 'zip location' do
    lp = create(:long_problem)
    assert_equal lp.zip_location,
                 Rails.root.join('public', 'contest_files', 'submissions',
                                 "kontes#{lp.contest_id}",
                                 "no#{lp.problem_no}.zip").to_s,
                 'Zip location is not correct'
  end

  test 'compress_submissions' do
    c = create(:full_contest)
    lp = c.long_problems.take
    ls = lp.long_submissions

    File.delete(lp.zip_location) if File.file?(lp.zip_location)
    lp.compress_submissions

    assert File.exist?(lp.zip_location), 'Zip file does not exist'

    Zip::File.open(lp.zip_location) do |file|
      assert_equal file.select { |f| f.ftype == :directory }.count,
                   ls.count, 'Number of folders does not match!'

      filenames = file.map(&:name)

      ls.each do |l|
        l.submission_pages.each do |p|
          filename = "peserta#{p.long_submission.user_contest_id}/" \
                     "kontes#{p.long_submission.long_problem.contest_id}_" \
                     "no#{p.long_submission.long_problem.problem_no}_" \
                     "peserta#{p.long_submission.user_contest_id}_" \
                     "hal#{p.page_number}.pdf"
          assert filenames.include?(filename), "#{filename} is not there!!"
        end
      end
    end
  end

  test 'autofill' do
    c = create(:full_contest)
    lp = c.long_problems.take
    ls = lp.long_submissions.first
    ls2 = lp.long_submissions.second

    ls.temporary_markings.find_each { |u| u.update(mark: 7) }
    ls2.temporary_markings.each_with_index do |tm, i|
      tm.update(mark: i)
    end

    lp.autofill
    assert_equal ls.reload.score, 7, 'autofill is not working'
    assert_nil ls2.reload.score, 'autofill is not working'
  end
end
