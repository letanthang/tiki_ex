defmodule Tiki.Category do
  @moduledoc """
  Support list and get category details
  """

  alias Tiki.Client
  alias Tiki.Support.Helpers

  @doc """
  Returns a list of category managed by the authorized seller, base on a specific search query.
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-categories
  """
  @list_category_schema %{
    parent: [type: :integer, number: [min: 1]],
    name: [type: :string],
    is_primary: [type: :boolean],
    is_cross_border: [type: :boolean]
  }
  def list_category(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @list_category_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)

      Client.get(client, "/categories", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-category-detail
  """
  @get_category_schema %{
    category_id: [type: :integer, required: true],
    include_parents: [type: :boolean]
  }
  def get_category(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_category_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/categories/#{data.category_id}", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-category-attributes
  """
  @get_category_attribute_schema %{
    category_id: [type: :integer, required: true]
  }
  def get_category_attribute(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_category_attribute_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/categories/#{data.category_id}/attributes", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-attribute-values
  """
  @get_category_attribute_value_schema %{
    attribute_id: [type: :integer, required: true],
    q: [type: :string],
    page: [type: :integer, number: [min: 1]],
    limit: [type: :integer, number: [min: 1]]
  }
  def get_category_attribute_value(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_category_attribute_value_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/attributes/#{data.attribute_id}/values", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/product-api/#get-attribute-values
  """
  @get_category_option_label_schema %{
    category_id: [type: :integer, required: true]
  }
  def get_category_option_labels(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_category_option_label_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/categories/#{data.category_id}/optionLabels", query: data)
    end
  end
end
