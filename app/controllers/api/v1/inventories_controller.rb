class Api::V1::InventoriesController < ApplicationController

  before_action :set_policy

    def index
    authorize! :index?
    inventories = service.list(filter_params)
    render json: InventorySerializer.collection(inventories)  # แก้ตรงนี้
    end


    def show
      inventory = service.find(params[:id])
      render json: InventorySerializer.new(inventory).as_json, status: :ok
    end



  def create
    authorize! :create?
    form = CreateInventoryForm.new(inventory_params)
    unless form.valid?
      render json: { errors: form.errors.full_messages },
             status: :unprocessable_entity
      return
    end
    inventory = service.create(form.to_attributes)
    render json: InventorySerializer.new(inventory).as_json,
           status: :created
  end

  def adjust
    authorize! :adjust?
    inventory = service.adjust_stock(params[:id], params[:quantity].to_i)
    render json: InventorySerializer.new(inventory).as_json
  end

  def destroy
    authorize! :destroy?
    service.delete(params[:id])
    head :no_content
  end

  private

  def set_policy
    @policy = InventoryPolicy.new(current_user)
  end

  def authorize!(action)
    unless @policy.public_send(action)
      render json: { error: 'สิทธิ์ไม่เพียงพอ' }, status: :forbidden
    end
  end

  def service
    @service ||= InventoryService.new
  end

  def inventory_params
    params.require(:inventory).permit(:product_id, :quantity)
  end

  def filter_params
    params.permit(:product_id)
  end
end