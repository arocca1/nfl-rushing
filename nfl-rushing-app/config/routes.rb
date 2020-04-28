Rails.application.routes.draw do
  resources :rushing, only: [:index] do
    collection do
      get 'show_stats'
    end
  end
end
