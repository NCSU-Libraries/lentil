if defined?(ActiveAdmin)
  ActiveAdmin.register Lentil::User do
    actions :index
    config.batch_actions = false

    filter :service
    filter :user_name
    filter :full_name
    filter :bio

    index do
      column :id
      column :user_name
      column :full_name
      column :service
      column :images_count
      column :bio, :sortable => false
    end
  end
end