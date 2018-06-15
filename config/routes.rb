Rails.application.routes.draw do
    root 'tweet#index'

    get '/tweet' => 'tweet#index'
    get '/tweet/new' => 'tweet#new'
    post '/tweet/create' => 'tweet#create'
    get '/tweet/:id/destroy' => 'tweet#destroy'
    get '/tweet/:id/edit' => 'tweet#edit'
    post '/tweet/:id/update' => 'tweet#update'
    get '/tweet/:id' => 'tweet#show'
    
end
