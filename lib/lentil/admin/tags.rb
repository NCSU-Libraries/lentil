if defined?(ActiveAdmin)
  ActiveAdmin.register Lentil::Tag do
    actions :index, :create, :new

    config.batch_actions = false
    config.sort_order = "name_asc"

    filter :name

    index :download_links => false do
      column :id
      column :name
      column "Tagsets" do |tag|
        tag.tagsets.sort_by(&:title).map{ |t| t.title}.join(' | ')
      end
    end
  end
end