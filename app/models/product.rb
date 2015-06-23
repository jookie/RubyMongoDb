
# class Product
   #attr_accessible :name, :length, :width, :height, :weight
#
#   include Mongoid::Document
#   field :name,   type: String
#   field :length, type: Float
#   field :width,  type: Float
#   field :height, type: Float
#   field :weight, type: Float
#
#   # if null than you you can calculte the price field
#   field :price,  type: Float, :allow_nil => true
# end

class Product < ActiveRecord::Base
  # if null than you can calculte the price field
  # All dimensions and weight must be present in order for shipping information to be effective.


  validates :name, presence: true

  validates :length, presence: true, numericality: { greater_than: 0.01,
                                                    :message   => "Invalid length."}
  validates :width , presence: true, numericality: { greater_than: 0.01,
                                                    :greater_than_or_equal_to => :length,
                                                    :message   => "Invalid width."}
  validates :height, presence: true, numericality: { greater_than: 0.01,
                                                    :message   => "Invalid height."}

  validates :weight, presence: true, numericality: { greater_than: 0.01,
                                                     :message   => "Invalid weight."}
  # Shows ONE product that best matches a given length/width/height/weight query
  # For example:
  # if you make an API request for a product with the following dimensions: 48”l X 14”w X 12”h (@ 42lbs)
  # the API should send back “Golf - Small”

  #gem 'devise'
  #gem 'figaro'

  # calculate weighted price only if:
  # the retreived filtered filtered collection of all the products by dimentions and weight is greater
  # than the parameters, is not containing any null price.
  # otherwise use the true price or weighted price for selecting the Product.
  # Find the rate for a specific UPS service for a specific package or shipment

  # Calculate weighted price only if filtered products list is not containing any null price.
  #  WorldShip
  # Step 1: Register with My UPS.
  # Step 2: Log-in
  # Step 3: Select an API.
  # Step 4: Download the API documentation.
  # Step 5: Request an access key.

  # Rating
  # Compare delivery services and shipping rates to determine the best option for your customers.

   def Product.retreive_product_name_by_dimention_and_weight(parm_length, parm_width, parm_height, parm_weight)
    products = Product.valid_records(parm_length, parm_width, parm_height, parm_weight)
    # calculate weighted price only if filtered products list is not containing any null price
    filtered_products = products.find_all { |price| price['price'] == nil}
    if (filtered_products.length > 0)
      products.each do |product|
        product.price = product.length+product.width+product.height+product.weight-
            parm_length-parm_width-parm_height-parm_weight
      end
    end
    products.order('price DESC')
    return products.first.name
  end

private
  def Product.valid_records(parm_length, parm_width, parm_height, parm_weight)
    w =      "length  >= #{parm_length}"
    w += " AND width  >= #{parm_width}"
    w += " AND height >= #{parm_height}"
    w += " AND weight >= #{parm_weight}"
    products = Product.where(w);
    return products
  end

  def Product.query_MongoDb(parm_length, parm_width, parm_height, parm_weight)

    # which one ?
    #Product.descending(:price)
    #add find().sort( { delta: 1 } )
    #products.find().sort( { delta: 1 } )

    products = Product.all_of(:length.gte => parm_length,
                              :width.gte  => parm_width ,
                              :height.gte => parm_height,
                              :weight.gte => parm_weight)

  end

end
