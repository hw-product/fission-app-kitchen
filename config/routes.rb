Rails.application.routes.draw do
  instance_exec(
    :kitchen, 'v1/github/kitchen',
    &FissionApp::Repositories.repositories_routes
  )

  instance_exec(
    :kitchen, :disable_details,
    &FissionApp::Jobs.jobs_routes
  )

  namespace :kitchen do
    get 'dashboard', :to => 'dashboard#index', :as => :dashboard
    get 'job/:job_id', :to => 'jobs#details', :as => :job
    resources :repository, :only => [:show]
  end
end
