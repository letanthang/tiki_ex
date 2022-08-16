defmodule Tiki.Seller do
  @moduledoc """
  API to get seller information
  """
  alias Tiki.Client
  alias Tiki.Support.Helpers
  alias Tiki.Enums.WarehouseTypeEnum
  alias Tiki.Enums.WarehouseStatusEnum

  @doc """
  Get seller info
  Ref: https://open.tiki.vn/docs/docs/current/api-references/seller-api/#get-seller
  """
  def me(opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/sellers/me")
    end
  end

  @doc """
  Return list of seller warehouses

  Ref: https://open.tiki.vn/docs/docs/current/api-references/seller-api/#get-seller-warehouse
  """
  @get_seller_warehouse_schema %{
    status: [type: :integer, in: WarehouseStatusEnum.enum()],
    type: [type: :integer, in: WarehouseTypeEnum.enum()],
    limit: :integer,
    page: :integer
  }
  def get_seller_warehouse(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_seller_warehouse_schema),
         data <- Helpers.clean_nil(data),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/sellers/me/warehouses", query: data)
    end
  end
end
