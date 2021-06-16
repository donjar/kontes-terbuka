# frozen_string_literal: true

require_relative 'support'

FactoryBot.define do
  factory :about_user do
    user
    name { 'Test' }
    description { 'Test' }
    image { PNG }
  end

  sequence :unique do |n|
    name = 'aaaaaaaa'
    n.times { name = name.succ }
    name
  end

  sequence :number do |n|
    n + 1
  end

  factory :color do
    name { generate(:unique) }
  end

  factory :contest do
    transient do
      start { 0 }
      ends { 20 }
      result { 40 }
      feedback { 60 }
    end

    name { 'Kontes Coba' }
    start_time { Time.zone.now + start.seconds }
    end_time { Time.zone.now + ends.seconds }
    result_time { Time.zone.now + result.seconds }
    feedback_time { Time.zone.now + feedback.seconds }

    factory :full_contest do
      transient do
        users { 4 }
        short_problems { 5 }
        long_problems { 4 }
        feedback_questions { 3 }
        markers { 3 }
      end

      gold_cutoff { 10 }
      silver_cutoff { 8 }
      bronze_cutoff { 6 }
      problem_pdf { PDF }
      problem_tex { TEX }
      marking_scheme { PDF }

      after(:create) do |contest, evaluator|
        users = create_list(:user, evaluator.users)
        short_problems = create_list(:short_problem, evaluator.short_problems,
                                     contest: contest)
        long_problems = create_list(:long_problem, evaluator.long_problems,
                                    contest: contest)
        feedback_questions = create_list(:feedback_question,
                                         evaluator.feedback_questions,
                                         contest: contest)

        markers = create_list(:user, evaluator.markers)
        markers.each do |m|
          long_problems.each do |lp|
            m.add_role(:marker, lp)
          end
        end

        user_contests = []
        long_submissions = []

        users.each do |u|
          user_contests.push(create(:user_contest, user: u, contest: contest))
        end

        user_contests.each do |uc|
          short_problems.each do |sp|
            create(:short_submission, user_contest: uc, short_problem: sp)
          end
          long_problems.each do |lp|
            long_submissions.push(create(:long_submission, user_contest: uc,
                                                           long_problem: lp))
          end
          feedback_questions.each do |fq|
            create(:feedback_answer, user_contest: uc, feedback_question: fq)
          end
        end

        long_submissions.each do |ls|
          create(:submission_page, long_submission: ls, page_number: 1)
          markers.each do |m|
            create(:temporary_marking, user: m, long_submission: ls)
          end
        end
      end
    end
  end

  factory :feedback_answer do
    answer { 'Saya baik!' }
    feedback_question
    user_contest

    after(:create) do |fa|
      fa.user_contest.update(contest: fa.feedback_question.contest)
    end
  end

  factory :feedback_question do
    question { 'Halo, apa kabar?' }
    contest
  end

  factory :long_problem do
    contest
    problem_no { generate(:number) }
    statement { 'Esai' }
  end

  factory :long_submission do
    long_problem
    user_contest

    trait :marked do
      score { 6 }
      feedback { 'Jangan lupa dimasukin balik jawaban fungsinya, bodoh' }
    end

    after(:create) do |ls|
      create(:submission_page, long_submission: ls)
      ls.user_contest.update(contest: ls.long_problem.contest)
    end
  end

  factory :notification do
    event { 'contest_ending' }
    time_text { '3 jam' }
    description { '3 jam sebelum kontes selesai' }
    seconds { 180 }
  end

  factory :point_transaction do
    point { 10 }
    description { 'Kontes Bodoh' }
    user
  end

  factory :province do
    name { generate(:unique) }
    timezone { 'WITA' }
  end

  factory :referrer do
    name { generate(:unique) }
  end

  factory :short_problem do
    contest
    problem_no { generate(:number) }
    statement { 'Isian' }
    answer { '0' }
    correct_score { 1 }
    wrong_score { 0 }
    empty_score { 0 }
  end

  factory :short_submission do
    short_problem
    user_contest
    answer { '3' }

    after(:create) do |ss|
      ss.user_contest.update(contest: ss.short_problem.contest)
    end
  end

  factory :status do
    name { generate(:unique) }
  end

  factory :submission_page do
    submission { PDF }
    page_number { generate(:number) }
    long_submission
  end

  factory :temporary_marking do
    user
    long_submission

    trait :filled do
      mark { 3 }
      tags { 'udah lumayan' }
    end
  end

  factory :user do
    username { generate(:unique) }
    password { 'qwerqwerty' }
    password_confirmation { password }
    email { generate(:unique) + '@a.b' }
    fullname { 'qwerqwer' }
    province
    status
    color
    school { 'qwerty' }
    terms_of_service { '1' }

    transient do
      role { nil }
    end

    after(:create) do |user, evaluator|
      unless evaluator.role.nil?
        begin
          user.add_role(*evaluator.role)
        rescue StandardError
          user.add_role :panitia
          retry
        end
      end
    end
  end

  factory :user_contest do
    contest
    user
  end

  factory :user_notification do
    user
    notification
  end
end
