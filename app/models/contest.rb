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
#
# Indexes
#
#  index_contests_on_end_time       (end_time)
#  index_contests_on_feedback_time  (feedback_time)
#  index_contests_on_result_time    (result_time)
#  index_contests_on_start_time     (start_time)
#
# rubocop:enable Metrics/LineLength

class Contest < ActiveRecord::Base
  include ContestAttributes
  include ContestJobs
  has_paper_trail
  schema_validations except: :rule

  # For results pdf
  include WickedPdf::WickedPdfHelper::Assets
  include ActionView::Helpers::AssetTagHelper
  include ApplicationHelper
  include ContestsHelper

  # Callbacks
  before_create do
    self.rule = File.open('app/assets/default_rules.txt', 'r').read
  end

  after_save :prepare_jobs

  # Associations
  has_many :user_contests
  has_many :users, through: :user_contests

  has_many :short_problems
  has_many :short_submissions, through: :short_problems

  has_many :long_problems
  has_many :long_submissions, through: :long_problems
  has_many :submission_pages, through: :long_submissions

  has_many :feedback_questions
  has_many :feedback_answers, through: :feedback_questions

  # Attachments
  has_attached_file :problem_pdf,
                    url: '/contests/:id/pdf',
                    path: ':rails_root/public/contest_files/problems/' \
                    ':id/soal.:extension'
  validates_attachment_content_type :problem_pdf,
                                    content_type: ['application/pdf']

  has_attached_file :problem_tex,
                    path: ':rails_root/public/contest_files/problems/' \
                    ':id/soal.:extension'
  validates_attachment_content_type :problem_tex,
                                    content_type: ['text/x-tex']

  has_attached_file :marking_scheme,
                    url: '/contests/:id/ms-pdf',
                    path: ':rails_root/public/contest_files/problems/' \
                    ':id/ms.:extension'

  # Validations
  validates_datetime :start_time, on_or_before: :end_time
  validates_datetime :end_time, on_or_before: :result_time
  validates_datetime :result_time, on_or_before: :feedback_time

  validate :result_released_when_contest_ended
  def result_released_when_contest_ended
    return unless result_released && !ended?
    errors.add :result_released, 'after contest ended'
  end

  def self.next_contest
    Contest.where('end_time > ?', Time.zone.now).order('end_time')[0]
  end

  def self.next_important_contest
    next_feedback = Contest.where('feedback_time > ?', Time.zone.now)
                           .order('feedback_time')[0]
    next_end = Contest.where('end_time > ?', Time.zone.now)
                      .order('end_time')[0]
    return next_end if next_feedback.nil?
    return next_feedback if next_end.nil?
    return next_feedback if next_feedback.feedback_time < next_end.end_time
    next_end
  end

  def compress_reports
    File.delete(report_zip_location) if File.file?(report_zip_location)
    ZipFileGenerator.new(reports_location, report_zip_location).write
  end

  def compress_submissions
    File.delete(submissions_zip_location) if File.file?(report_zip_location)
    ZipFileGenerator.new(submissions_location, submissions_zip_location).write
  end

  def report_zip_location
    reports_location + '.zip'
  end

  def submissions_zip_location
    submissions_location + '.zip'
  end

  def refresh
    delay(queue: "contest_#{id}").refresh_results_pdf
  end

  def refresh_results_pdf
    contest = self
    b = binding
    pdf = WickedPdf.new.pdf_from_string(
      ERB.new(File.read(results_template)).result(b),
      orientation: 'Landscape',
      header: { right: Time.zone.now
                           .strftime('Versi %d-%m-%Y %H:%M:%S GMT%z') },
      footer: { left: "Hasil #{contest}",
                right: 'Halaman [page] dari [topage]' }
    )

    File.delete(results_location) if File.file?(results_location)
    unless File.directory?(File.dirname(results_location))
      FileUtils.mkdir_p(File.dirname(results_location))
    end
    File.open(results_location, 'wb') { |f| f << pdf }
  end

  def results_location
    Rails.root.join('public', 'contest_files', 'results', "#{id}.pdf").to_s
  end

  private

  def reports_location
    Rails.root.join('public', 'contest_files', 'reports', id.to_s).to_s
  end

  def submissions_location
    Rails.root.join('public', 'contest_files', 'submissions',
                    "kontes#{id}").to_s
  end

  def results_template
    Rails.root.join('app', 'views', 'contests', 'download_results.html.erb')
  end
end
