Rails.application.routes.draw do


  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'login' => 'sessions#delete'

  get 'reports/jobs_all' => 'reports#jobs_all'
  get 'photos/:id/check' => 'photos#check'
  get 'works' => 'stores#user'
  put '/events/readall' => 'events#readall'

  #get 'admin/index/task1' => 'admin/#task1'
  #root :to => 'stores#index'
  root :to => 'stores#main'


  resources :user do
    resources :jobs
    resources :events
  end
  resources :stores, param: :code do
    resources :jobs do
      resources :patch_panels do
        resources :ports
      end
      resources :photos, only: [:show, :edit, :update, :create, :new, :destroy]
      resources :registrators
    end
  end

  resources :jobs do
    member do
      put 'done'
      put 'accept'
      put 'return_to_work'
      put 'before_done_send_to_admin'
      put 'sn_inc_create'
      put 'sn_inc_delete_link'
      put 'sn_task_create'
      put 'calculate_latest_job_in_store'
      put 'calculate_latest_job_in_store_all'
    end
    resources :photos, only: [:show, :edit, :update, :create, :new, :destroy]
    resources :patch_panels do
      resources :ports
    end
    resources :registrators
  end


  namespace :admin do
    get 'index' => 'admin#index'
    resources :staffs
    resources :users
    resources :groupmanager
    resources :settings_ldap
  end

  namespace :info do
    root :to => 'info#index'
    get 'index' => 'info#index'
    get 'category/add' => 'category#add'
    get 'subcategory/add' => 'subcategory#add'
    get 'file/add' => 'file#add'

    get 'category/edit' => 'category#edit'
    get 'subcategory/edit' => 'subcategory#edit'
    get 'file/edit' => 'file#edit'
    get 'file/about' => 'file#about'

    resources :category
    resources :subcategory
    resources :file
  end


    resources :reports
  resources :staff, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
