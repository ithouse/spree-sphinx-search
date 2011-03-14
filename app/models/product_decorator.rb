Product.class_eval do
  define_index do

    is_active_sql = "(products.deleted_at IS NULL AND products.public IS TRUE AND products.available_on <= NOW() #{'AND (products.count_on_hand > 0)' unless Spree::Config[:allow_backorders]} )"

    set_property :sql_range_step => 1000000
    set_property :delta => true

    indexes :name
    indexes :description
    #indexes :meta_description
    #indexes :meta_keywords
    #indexes taxons.name, :as => :taxon, :facet => true
    has taxons(:id), :as => :taxon_ids

    has :diagonal_length
    has :weight
    has :battery_life
    has :installed_ram
    has :hdd_capacity
    has master(:price), :as => :master_price, :type => :integer
    #has product_discount_price(:price), :as => :discount_price
    has product_discount_price(:price), :as => :discount, :type => :boolean

    indexes [product_properties.property.name,product_properties.value], :as => :property
    has product_properties(:id), :as => :product_property_ids

    #group_by :deleted_at
    group_by :available_on
    has is_active_sql, :as => :is_active, :type => :boolean
  end
end

