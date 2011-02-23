Product.class_eval do

      define_index do
        is_active_sql = "(products.deleted_at IS NULL AND products.public IS TRUE AND products.available_on <= NOW() #{'AND (products.count_on_hand > 0)' unless Spree::Config[:allow_backorders]} )"
        set_property :sql_range_step => 1000000
        indexes :name
        indexes :description
        indexes :meta_description
        indexes :meta_keywords
        indexes taxons.name, :as => :taxon, :facet => true
        has taxons(:id), :as => :taxon_ids
        group_by :deleted_at
        group_by :available_on
        has is_active_sql, :as => :is_active, :type => :boolean
      end
end
