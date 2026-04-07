module Api
  module V1
    class ProductsController < ApplicationController
      include PaginationHelper


      before_action :set_service
      before_action :set_product,       only: [:show, :update, :destroy]
      before_action :set_policy
      before_action :authorize_create!, only: [:create]
      before_action :authorize_update!, only: [:update]
      before_action :authorize_delete!, only: [:destroy]

      def index
        result = paginate(@service.list_products(filter_params), params)
        render json: { data: ProductSerializer.collection(result[:data]), meta: result[:meta] }
      end

      def show
        render json: { data: ProductSerializer.new(@product).as_json }
      end

      def create
        form = CreateProductForm.new(product_params)
        unless form.valid?
          return render json: { errors: form.errors.full_messages }, status: :unprocessable_entity
        end
        product = @service.create_product(form.to_h)
        render json: { data: ProductSerializer.new(product).as_json }, status: :created
      end

      def update
        form = UpdateProductForm.new(product_params)
        unless form.valid?
          return render json: { errors: form.errors.full_messages }, status: :unprocessable_entity
        end
        product = @service.update_product(@product.id, form.to_h)
        render json: { data: ProductSerializer.new(product).as_json }
      end

      def destroy
        @service.delete_product(@product.id)
        render json: { message: 'ลบสินค้าเรียบร้อย' }
      end

      private

      def set_service
        @service = ProductService.new
      end

      def set_product
        @product = @service.find_product(params[:id])
      end

      def set_policy
        @policy = ProductPolicy.new(current_user)
      end

      def authorize_create!
        render json: { error: 'สิทธิ์ไม่เพียงพอ' }, status: :forbidden unless @policy.can_create?
      end

      def authorize_update!
        render json: { error: 'สิทธิ์ไม่เพียงพอ' }, status: :forbidden unless @policy.can_update?
      end

      def authorize_delete!
        render json: { error: 'สิทธิ์ไม่เพียงพอ' }, status: :forbidden unless @policy.can_delete?
      end

      def product_params
        params.require(:product).permit(:name, :price, :stock, :category)
      end

      def filter_params
        params.permit(:category, :in_stock)
      end
    end
  end
end
