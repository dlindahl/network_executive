NetworkExecutive::Engine.routes.draw do
  mount NetworkExecutive::Station => '/tune_in', as:'station'

  match 'channels/:channel_name' => 'network#index', as: :channel

  match 'lineup' => 'lineup#index', as: :lineup

  match 'programs/:program_name' => 'programs#show', as: :program

  root to:'network#index'
end