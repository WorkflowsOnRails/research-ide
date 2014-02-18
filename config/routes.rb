ResearchIde::Application.routes.draw do
  devise_for :users
  root 'projects#index'

  resources :projects do
    member do
      post :add_participant

      # Handle both an update and a remove button in the participant form
      # without if / else hackery in the controller.
      post :update_participant, constraints: ParamPresenceRouting.new('update'),
           action: :update_participant
      post :update_participant, constraints: ParamPresenceRouting.new('destroy'),
           action: :destroy_participant
    end
  end
end
