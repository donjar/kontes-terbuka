# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?
    user_abilities(user)

    (%w[marker panitia] + Role.admins).each do |role|
      __send__("#{role}_abilities", user) if user.has_cached_role? role, :any
    end
  end

  private def user_abilities(user)
    contest_related_user_abilities(user)
    user_related_user_abilities(user)
  end

  private def contest_related_user_abilities(user)
    can %i[show index], Contest
    can :download_results, Contest, result_released: true
    can %i[show_rules accept_rules], Contest,
        id: Contest.currently_in_contest.pluck(:id)
    can %i[download_problem_pdf give_feedback feedback_submit], Contest,
        id: user.user_contests.pluck(:contest_id)
    can %i[create destroy download], LongSubmission,
        user_contest_id: user.user_contests.in_time.pluck(:id),
        long_problem_id: LongProblem.in_time.pluck(:id)
    can %i[create_on_contest update], ShortSubmission,
        user_contest_id: user.user_contests.in_time.pluck(:id),
        short_problem_id: ShortProblem.in_time.pluck(:id)
    can %i[new create], UserContest, user: user
    can %i[new_on_contest create_on_contest], FeedbackAnswer
  end

  private def user_related_user_abilities(user)
    can :show, User, enabled: true
    can :index, User
    can %i[show_full edit update change_password process_change_password
           referrer_update], User, id: user.id
    can %i[index create delete], UserNotification, user_id: user.id
  end

  private def marker_abilities(user)
    long_problems = LongProblem.with_role(:marker, user).pluck(:id, :contest_id)
    can %i[download_submissions autofill upload_report mark],
        LongProblem, id: long_problems.map(&:first)
    can %i[mark submit_mark], LongSubmission,
        long_problem_id: long_problems.map(&:first)
    can :download_marking_scheme, Contest, id: long_problems.map(&:second)
    can :admin, Application
  end

  private def panitia_abilities(user)
    can %i[preview summary admin download_marking_scheme
           download_problem_pdf download_reports], Contest
    can %i[index_full show_full show], User
    can :download_on_contest, FeedbackAnswer
    can %i[admin profile see_referrers], Application
    can :download_certificates_data, UserContest
    can %i[create edit update destroy], AboutUser, user_id: user.id
  end

  private def marking_manager_abilities(_user)
    can %i[download_submissions mark], LongProblem
    can %i[assign_markers create_marker remove_marker], Role
  end

  private def problem_admin_abilities(_user)
    can %i[admin read_problems destroy_short_probs
           destroy_long_probs update_marking_scheme], Contest
    can :manage, ShortProblem
    can :manage, LongProblem
  end

  private def admin_abilities(_user)
    can :manage, :all
  end
end
