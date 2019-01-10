Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post   'create_post'                 => 'blogs#create_post'
  put    'update_post/:id'             => 'blogs#update_post'

  get    'index'                       => 'blogs#index'
  get    'get_posts'                   => 'blogs#get_posts'
  patch  'edit_posts'                  => 'blogs#edit_posts'
  delete 'delete'                      => 'blogs#delete'
  get    'get_pending_posts'           => 'blogs#get_pending_posts'
  get    'email_users_about_updated_posts' => 'blogs#email_users_about_updated_posts'
  post   'publish_post'                => 'blogs#publish_post'
  get    'get_current_users_blogposts' => 'blogs#get_current_users_blogposts'
end
