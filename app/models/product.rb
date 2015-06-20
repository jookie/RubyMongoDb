#models/product.rb
name:String
field :length, type: Float
field :width,  type: Float
field :height, type: Float
field :weight, type: Float
class Product
  attr_accessible :name, :length, :width, :height, :weight

  include Mongoid::Document
  field :name,   type: String
  field :length, type: Float
  field :width,  type: Float
  field :height, type: Float
  field :weight, type: Float

  field :delta,  type: Float, :allow_nil => true

  # All dimensions and weight must be present in order for shipping information to be effective.
  validate :length, presence: true, numericality: { greater_than: 0.01,
                                                                  :message   => "Invalid length."}
  validate :width , presence: true, numericality: { greater_than: 0.01,
                                                                  :greater_than_or_equal_to => :length,
                                                                  :message   => "Invalid width."}
  validate :height, presence: true, numericality: { greater_than: 0.01,
                                                                  :message   => "Invalid height."}

  # Shows ONE product that best matches a given length/width/height/weight query
  # For example:
  # if I make an API request for a product with the following dimensions: 48”l X 14”w X 12”h (@ 42lbs)
  # the API should send me back “Golf - Small”
  def retreive_product_name_by_dimention_and_weight(parm_length, parm_width, parm_height, parm_weight)
    #These are the other options to try implement the search
    #Product.where([] => [parm_length, parm_width, parm_height])
    #Product.where(:length.gte => parm_length).and(:width.gte => parm_width).
    # and(:height.gte => parm_height).and(:parm_weight.gte => parm_weight)
    products = Product.all_of(:length.gte => parm_length,
                              :width.gte  => parm_width,
                              :height.gte => parm_height,
                              :weight.gte => parm_weight)
    products.each do |product|
        product.delta = product.length+product.width+product.height+product.weight-
                        parm_length-parm_width-parm_height-parm_weight
    end

    # which one ?
    Product.descending(:delta)

    products.find().sort( { delta: 1 } )

    return products.first.name
  end
end
