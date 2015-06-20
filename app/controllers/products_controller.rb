class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
    render :json => @products, :status => :ok
  end

  def show
    begin
       name = retreive_product_name_by_dimention_and_weight(params[:length],
                                                            params[:width],
                                                            params[:heigh],
                                                            params[:weight])
    rescue
      respond_info('error', 'internal_server_error', 'Show product name Failed', :internal_server_error)
      return
    end
    render :json => name, :status => :ok
  end

  def create

    # Calculate weighted price only if filtered products list is not containing any null price.
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

  def update
    begin
      @product = Product.find(params[:id])
    rescue
      respond_info('error', 'internal_server_error', 'Update product Failed', :internal_server_error)
      return
    end
    if @product.update(product_params)
      render :json => @products, :status => :no_content #HTTP status code: 204 No Content
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @product = Product.find(params[:id])
    rescue
      respond_info('error', 'internal_server_error', 'Delete product Failed', :internal_server_error)
      return
    end
    @product.destroy
    respond_info('success', 'success', 'Success', :no_content) #HTTP status code: 204 No Content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :length, :width, :height, :weight)
    end
end
