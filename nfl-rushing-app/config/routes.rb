Rails.application.routes.draw do
  resources :rushing do
    collection do
      get 'show_stats'
    end
  end
end
