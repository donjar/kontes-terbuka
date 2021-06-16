# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'welcome#index'
  # Comment root and uncomment these to enter maintenance mode:
  # root 'application#maintenance'
  # match '*path', to: 'application#maintenance', via: :all

  resources :users do
    member do
      get 'change-password', to: 'users#change_password'
      post 'change-password', to: 'users#process_change_password'
      patch 'referrer-update', to: 'users#referrer_update'
      put 'referrer-update', to: 'users#referrer_update'
    end

    collection do
      get 'sign', to: 'welcome#sign'
      get 'register', to: 'users#new'
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      post 'forgot', to: 'users#process_forgot_password'

      post 'check', to: 'users#check_unique'
      get 'verify/:verification', to: 'users#verify', as: 'verify'
      get 'reset-password/:verification', to: 'users#reset_password',
                                          as: 'reset_password'
      post 'reset-password/:verification', to: 'users#process_reset_password'
    end

    resources :user_notifications, path: '/user-notifications',
                                   only: %i[index create] do
      collection do
        delete 'delete', to: 'user_notifications#delete'
      end
    end

    resource :about_user, path: '/about-user', only: %i[create edit update destroy]
  end

  resources :roles, only: %i[create destroy] do
    collection do
      get '', to: 'roles#manage', as: ''
    end
  end

  resources :contests, except: [:edit], shallow: true do
    member do
      get 'admin', to: 'contests#admin'
      get 'summary', to: 'contests#summary'
      post 'read-problems', to: 'contests#read_problems'
      get 'results', to: 'contests#download_results',
                     defaults: { format: 'pdf' }
      get 'problem-pdf', to: 'contests#download_problem_pdf'
      get 'marker', to: 'roles#assign_markers'
      get 'ms-pdf', to: 'contests#download_marking_scheme'
      get 'reports', to: 'contests#download_reports'
      post 'refresh', to: 'contests#refresh'
      post 'send_certificates', to: 'contests#send_certificates'
    end

    resources :user_contests, path: '/user-contests', only: %i[new create] do
      collection do
        get 'download-certificates-data',
            to: 'user_contests#download_certificates_data',
            as: 'download_certificates_data'
      end
    end

    resources :short_problems, path: '/short-problems',
                               except: %i[index new show] do
      collection do
        delete '', to: 'short_problems#destroy_on_contest', as: ''
      end
    end

    resources :short_submissions, path: '/short-submissions', only: [] do
      collection do
        post '', to: 'short_submissions#create_on_contest', as: ''
      end
    end

    resources :long_problems, path: '/long-problems',
                              except: %i[index new show] do
      member do
        post 'marker', to: 'roles#create_marker'
        delete 'marker', to: 'roles#remove_marker'
        get 'submissions', to: 'long_problems#download_submissions'
        patch 'autofill', to: 'long_problems#autofill'
        put 'autofill', to: 'long_problems#autofill'
        post 'upload-report', to: 'long_problems#upload_report'
      end

      collection do
        delete '', to: 'long_problems#destroy_on_contest', as: ''
      end

      resources :temporary_markings, path: 'temporary-markings', only: [] do
        collection do
          get '', to: 'temporary_markings#new_on_long_problem', as: ''
          post '', to: 'temporary_markings#modify_on_long_problem'
        end
      end

      resources :long_submissions, path: '/long-submissions',
                                   only: %i[create destroy] do
        member do
          get '', to: 'long_submissions#download', as: ''
        end

        collection do
          get '', to: 'long_submissions#mark', as: ''
          patch '', to: 'long_submissions#submit_mark'
          put '', to: 'long_submissions#submit_mark'
        end
      end
    end

    resources :feedback_questions, path: '/feedback-questions',
                                   except: %i[index new show] do
      collection do
        post 'copy', to: 'feedback_questions#copy_across_contests'
        delete '', to: 'feedback_questions#destroy_on_contest', as: ''
      end
    end

    resources :feedback_answers, path: '/feedback-answers', only: [] do
      collection do
        get 'new', to: 'feedback_answers#new_on_contest', as: 'new'
        get '', to: 'feedback_answers#download_on_contest', as: ''
        post '', to: 'feedback_answers#create_on_contest'
      end
    end
  end

  resources :referrers, only: [] do
    collection do
      delete 'reset', to: 'referrers#reset'
    end
  end

  %w[home rumah utama].each { |r| get "/#{r}", to: 'home#index' }
  %w[faq faqs pertanyaan].each { |r| get "/#{r}", to: 'home#faq' }
  %w[book books buku].each { |r| get "/#{r}", to: 'home#book' }
  %w[donate donasi sumbang].each { |r| get "/#{r}", to: 'home#donate' }
  %w[about tentang].each { |r| get "/#{r}", to: 'home#about' }
  %w[privacy privasi].each { |r| get "/#{r}", to: 'home#privacy' }
  %w[terms syarat ketentuan].each { |r| get "/#{r}", to: 'home#terms' }
  %w[contact kontak hubungi].each { |r| get "/#{r}", to: 'home#contact' }

  get '/penguasa', to: 'home#admin', as: :admin
  post '/masq', to: 'home#masq'
  delete '/masq', to: 'home#unmasq'
  resources :long_submissions, only: :new

  match '*path', to: 'errors#error_4xx', via: :all
end
# rubocop:enable Metrics/BlockLength
