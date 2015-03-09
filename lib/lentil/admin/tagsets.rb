if defined?(ActiveAdmin)
  ActiveAdmin.register Lentil::Tagset do

    config.batch_actions = false
    config.sort_order = "title_asc"

    filter :title
    filter :description

    scope :all
    scope :harvesting, :default => true do |tagsets|
      tagsets.where(:harvest => TRUE)
    end
    scope :not_harvesting do |tagsets|
      tagsets.where(:harvest => FALSE)
    end

    index :download_links => false do
      column :id
      column :title
      column :description
      column :tags do |tagset|
        tagset.tags.sort_by(&:name).map{|t| t.name}.join(' | ')
      end
      column :harvest
      actions
    end

    show do |tagset|
      attributes_table do
        row :id
        row :title
        row :description
        row :tags do |tagset|
          tagset.tags.sort_by(&:name).map{|t| t.name}.join(' | ')
        end
        row :harvest
      end
    end

    form do |f|
      f.inputs do
        f.input :title
        f.input :description
        f.input :tags, :input_html => {:class => [:"chzn-select"]}, :collection => Lentil::Tag.all.sort_by(&:name)
        f.input :harvest
      end
      f.actions
    end
  end
end
