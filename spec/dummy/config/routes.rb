Dummy::Application.routes.draw do
  mount NetworkExecutive::Engine => '/', as: 'network_executive'
end
