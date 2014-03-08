ResearchIde::Application.routes.draw do
  devise_for :users
  root 'projects#index'

  resources :projects do
    member do
      post :add_participant
      post :enter_state, action: :enter_state

      # Handle both an update and a remove button in the participant form
      # without if / else hackery in the controller.
      post :update_participant, constraints: ParamPresenceRouting.new('update'),
           action: :update_participant
      post :update_participant, constraints: ParamPresenceRouting.new('destroy'),
           action: :destroy_participant
    end
  end

  resources :tasks, only: [:show, :edit, :update] do
    post :preview, on: :collection

    resources :attachments, only: [:create]
  end

  resources :attachments, only: [:destroy]

  # Handle serving attachments with RackDAV:
  dav = RackDAV::Handler.new(
    root: '/tmp/',
    resource_class: DispatcherResource,
  )
  dav_with_auth = Rack::Auth::Basic.new(dav) do |username, password|
    user = User.find_for_authentication(:email => username)
    user && user.valid_password?(password)
  end
  mount dav_with_auth, at: "/files/"

  get 'webdav' => 'high_voltage/pages#show', id: 'webdav'
end
