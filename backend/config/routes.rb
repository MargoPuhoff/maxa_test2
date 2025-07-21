Rails.application.routes.draw do
  resources :file_pdfs, only: [:create, :index]
end
