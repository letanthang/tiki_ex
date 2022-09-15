defmodule Tiki.Product do
  @moduledoc """
  Support product management api
  """

  alias Tiki.Client
  alias Tiki.Support.Helpers

  alias Tiki.Type.CommaSeparatedString
  alias Tiki.Enums.ProductIncludableField

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#update-delivery-status-for-seller-delivery

  When you deliver the a seller delivery order, you need to tell whether the delivery is successful or not.
  """
  @create_product_schema %{
    category_id: [type: :integer, required: true],
    name: [type: :string, required: true],
    description: [type: :string, required: true],
    market_price: [type: :integer, required: true],
    attributes: [
      type: %{
        "brand" => [type: :string]
        # there are many optional attributes
      },
      required: true
    ],
    image: [type: :string, required: true],
    images: [type: {:array, :string}, required: true],
    option_attributes: [type: {:array, :string}, required: true],
    variants: [
      type:
        {:array,
        %{
          sku: [type: :string, required: true],
          min_code: [type: :string, required: true],
          option1: [type: :string],
          option2: [type: :string],
          price: :float,
          market_price: :float,
          inventory_type: [type: :string, required: true],
          seller_warehouse: [type: :string, required: true],
          warehouse_stocks: [type: {:array, %{
            warehouseId: [type: :integer, required: true],
            qtyAvailable: [type: :integer, required: true],
          }}, required: true],
          brand_origin: [type: :string],
          image: [type: :string, required: true],
          images: [type: {:array, :string}, required: true],
        }},
      required: true
    ],
    meta_data: [
      type: %{
        is_auto_turn_on: [type: :boolean]
      },
      required: true
    ],
  }
  def create_product(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @create_product_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.post(client, "/products/#{data.code}/seller-delivery/update-delivery", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-category-detail
  """
  @get_product_schema %{
    productId: [type: :integer, required: true],
    includes: CommaSeparatedString.type(in: ProductIncludableField.enum()),
  }
  def get_product(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_product_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/products/#{data.productId}", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-category-detail
  """
  @get_product_by_schema %{
    original_sku: [type: :string, required: true]
  }
  def get_product_by(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_product_by_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/products/findBy", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#update-product-info
  """
  @update_product_info_schema %{
    product_id: [type: :integer, required: true],
    attributes: [
      type: %{
        "brand" => [type: :string]
        # there are many optional attributes
      },
      required: true
    ],
    image: [type: :string],
    images: [type: {:array, :string}],
  }
  def update_product_info(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @update_product_info_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.post(client, "/requests/updateProductInfo", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#update-original-sku
  """
  @update_original_sku_schema %{
    product_id: [type: :integer, required: true],
    original_sku: [type: :string, required: true]
  }
  def update_original_sku_info(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @update_original_sku_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.post(client, "/requests/updateProductInfo", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#update-variant-price-quantity-active-v2-1
  """
  @update_sku_schema %{
    product_id: [type: :integer, required: true],
    price: [type: :integer],
    active: [type: :boolean],
    seller_warehouse: [type: :string],
    warehouse_quantities: [type: {:array, %{
      warehouse_id: [type: :integer, required: true],
      qty_available: [type: :integer, required: true],
    }}],
  }
  def update_sku_info(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @update_sku_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.put(client, "/products/updateSku", data)
    end
  end
end