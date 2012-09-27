NetworkExecutive::Engine.routes.draw do
  mount NetworkExecutive::Station => '/tune_in', as:'station'

  match 'channels/:channel_name' => 'network#index', as: :channel

  root to:'network#index'
end