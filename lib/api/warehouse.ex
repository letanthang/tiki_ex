defmodule Tiki.Warehouse do
  @moduledoc """
  Support list and get warehouse details
  """

  alias Tiki.Client

  @doc """
  Returns a list of warehouse managed by the authorized seller, base on a specific search query.
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-tiki-warehouses
  """
  def list_warehouse_tiki(_params, opts \\ []) do
    with {:ok, client} <- Client.new(opts) do

      Client.get(client, "/warehouses/tiki")
    end
  end
end