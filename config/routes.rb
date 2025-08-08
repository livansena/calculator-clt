Rails.application.routes.draw do
  get "calculator/index"

  # Calculator routes
  post "calculate", to: "calculator#calculate"
  root "calculator#index"
end
