class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]


  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    respond_to do |format|
      format.html
      format.json { render :json => @products, :status => :ok }
    end
  end
  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  # GET /products/1
  # GET /products/1.json
  def show
    begin
      p =  @product;
      l =  p.length;
      w =  params[:width];
      h =  params[:height] ;
      wg = params[:weight]
      name = retreive_product_name_by_dimention_and_weight(l, w, h , wg)
    rescue
      return
    end
    render :json => name, :status => :ok
  end
  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    begin
      @product = Product.find(params[:id])
    rescue
      format.html { render :edit }
      format.json { render :json => {:status => 'internal_server_error',
                                     :data => {:code => 'error', :message => 'internal_server_error'}}.to_json,
                                     :status => :internal_server_error }
      return
    end
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :json => @products, :status => :no_content } #HTTP status code: 204 No Content
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { render :json => {:status => status,
                                     :data => {:code => 'success', :message => 'Success'}}.to_json,
                           :status => :no_content }

      format.json { head :no_content }
    end
  end

  private
  def respond_info(status, code, message, http_hdr_status)
    respond_to do |format|
      format.json { render :json => {:status => status, :data => {:code => code, :message => message}}.to_json, :status => http_hdr_status }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:name, :length, :width, :height, :weight, :price)
  end


end
