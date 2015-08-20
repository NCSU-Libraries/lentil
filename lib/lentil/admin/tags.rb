if defined?(ActiveAdmin)
  ActiveAdmin.register Lentil::Tag do
    actions :index, :create, :new

    config.batch_actions = false
    config.sort_order = "name_asc"

    filter :name
    filter :tagsets_title, :as => :string, :label => "Tagsets"

    scope :all, :default => true
    scope "Harvesting", :harvestable
    scope "Not Harvesting", :not_harvestable
    scope "Not in a Tagset", :no_tagsets

    index :download_links => false do
      harvestable_ids = Lentil::Tag.harvestable.map(&:id)

      column :id
      column :name
      column "Harvestable" do |tag|
        if harvestable_ids.include?(tag.id)
          "True"
        else
          "False"
        end
      end
      column "Tagsets" do |tag|
        tag.tagsets.sort_by(&:title).map{ |t| t.title}.join(' | ')
      end
    end

    controller do
      def scoped_collection
        super.includes :taggings, :tagsets
      end
    end
  end
end
