BootstrapStarter::Application.routes.draw do

	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'}

		namespace :admin do
			resources :users
      resources :pairings do
        member do
          get :edit_combined
          put :edit_combined
        end
        collection do 
          put :publish
          get :upload
          put :upload
        end
      end
      resources :image_files
      resources :categories

	    match '/pairings/near/:id/:lat/:lon', :to => 'pairings#near', :as => :pairings_near, :via => :get, :constraints => {:lon => /.+\..*/, :lat => /.+\..*/}
		end

    # root
	  match '/about', :to => 'root#about', :as => :about, :via => :get
	  match '/next/:id', :to => 'root#next', :as => :next, :via => :get
	  match '/previous/:id', :to => 'root#previous', :as => :previous, :via => :get

		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
