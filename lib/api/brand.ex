defmodule Tiki.Brand do
  @moduledoc """
  Support list and get brand details
  """

  alias Tiki.Client
  alias Tiki.Support.Helpers

  @doc """
  Returns a list of brand managed by the authorized seller, base on a specific search query.
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-brand-by-name
  """
  @list_brand_schema %{
    name: [type: :string],
    page: [type: :integer],
    limit: [type: :integer]
  }
  def list_brand(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @list_brand_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)

      Client.get(client, "/brands", query: data)
    end
  end
end
