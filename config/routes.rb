require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Sidekiq::Web.use Rack::Auth::Basic, 'Sidekiq Protected Area' do |username, password|
  #   username == ENV['SIDEKIQ_WEB_USERNAME'] && password == ENV['SIDEKIQ_WEB_PASSWORD']
  # end

  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
  mount CulturalActivitiesBackend::API => '/'
end
