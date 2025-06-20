Rails.application.routes.draw do
  # Scam check routes
  get "scam_check/index"
  post "scam_check/create"
  get "scam_check/:id", to: "scam_check#show", as: :scam_check
  patch "scam_check/:id/update_details", to: "scam_check#update_details", as: :update_scam_check_details
  post "scam_check/clear_history", to: "scam_check#clear_history", as: :clear_scam_check_history
  
  # Home route
  get "home/index"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
