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
        collection do 
          put :publish
          get :full_form
          put :full_form
        end
      end
      resources :image_files
      resources :categories
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
