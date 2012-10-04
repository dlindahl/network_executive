NetworkExecutive::Engine.routes.draw do
  mount NetworkExecutive::Station => '/tune_in', as:'station'

  match 'channels/:channel_name' => 'network#index', as: :channel

  match 'you_tube' => 'components#you_tube', as: :you_tube
  match 'twitter'  => 'components#twitter',  as: :twitter

  match 'guide' => 'guide#index', as: :guide

  match 'programs/:program_name' => 'programs#show', as: :program

  root to:'network#index'
end