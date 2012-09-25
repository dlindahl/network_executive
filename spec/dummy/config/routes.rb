Dummy::Application.routes.draw do
  mount NetworkExecutive::Engine => '/network_executive', as: 'network_executive'
end
