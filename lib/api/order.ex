defmodule Tiki.Order do
  @moduledoc """
  Support list and get order details
  """

  alias Tiki.Client
  alias Tiki.Support.Helpers
  alias Tiki.Enums.OrderItemConfirmationStatus
  alias Tiki.Enums.OrderFulfillmentType
  alias Tiki.Enums.OrderStatus
  alias Tiki.Enums.OrderIncludableField
  alias Tiki.Enums.DeliveryFailureCause
  alias Tiki.Enums.CrossborderShipmentStatus
  alias Tiki.Type.SetExpression
  alias Tiki.Type.CommaSeparatedString
  alias Tiki.Type.Timestamp

  @doc """
  Returns a list of sales orders managed by the authorized seller, base on a specific search query.
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#order-listing-v2
  """
  @list_order_schema %{
    page: [type: :integer, number: [min: 1]],
    limit: [type: :integer, number: [min: 1]],
    code: [type: {:array, :string}],
    sku: [type: {:array, :string}],
    item_confirmation_status: [type: :string, in: OrderItemConfirmationStatus.enum()],
    item_inventory_type: SetExpression.type(in: ["back_order", "instock", "preorder"]),
    fulfillment_type: SetExpression.type(in: OrderFulfillmentType.enum()),
    status: SetExpression.type(in: OrderStatus.enum()),
    include: CommaSeparatedString.type(in: OrderIncludableField.enum()),
    is_rma: :boolean,
    filter_date_by: [type: :string, in: ~w(today last7days last30days)],
    created_from_date: Timestamp.type(),
    created_to_date: Timestamp.type(),
    order_by: :string
  }
  def list_order(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @list_order_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)

      Client.get(client, "/orders", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#order-details-v2
  """
  @get_order_schema %{
    code: [type: :string, required: true],
    include: CommaSeparatedString.type(in: OrderIncludableField.enum())
  }
  def get_order(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_order_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/orders/#{data.code}", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#confirm-enough-stock
  This API support confirm available stock for operation models:

  - On-Demand Fulfillment
  - Seller Delivery
  - Cross Border
  """
  @confirm_stock_schema %{
    code: [type: :string, required: true],
    available_item_ids: [type: {:array, :integer}, required: true],
    seller_inventory_id: [type: :integer, required: true]
  }
  def confirm_stock(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @confirm_stock_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.post(client, "/orders/#{data.code}/confirm-available", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#confirm-enough-stock-for-drop-shipping
  This API support confirm available stock for Drop Shipping operation model. After seller has confirmed enough stock, seller has to pack products properly. And prepare to for the driver to come picking the package.
  """
  @confirm_dropshipping_stock_schema %{
    code: [type: :string, required: true],
    confirmation_status: [
      type: :string,
      in: ["seller_confirmed", "seller_canceled"],
      required: true
    ],
    seller_inventory_id: [type: :integer, required: true],
    expected_pickup_time: Timestamp.type()
  }
  def confirm_dropshipping_stock(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @confirm_dropshipping_stock_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.post(client, "/orders/#{data.code}/dropship/confirm-available", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#get-expected-pickup-times
  """
  def get_expected_pickup_times(opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      Client.get(client, "/orders/dropship/expected-pickup-slots")
    end
  end

  @doc """
  This API return seller inventories and mappings from Tiki warehouses to seller inventories – which will be used in order confirmation and dropship confirmation.

  Notes, this API only return active & requisition inventories those matches the Tiki warehouse codes.

  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#get-seller-inventories-for-confirmation
  """
  @list_seller_warehouse_schema %{
    tiki_warehouse_codes: CommaSeparatedString.type(required: true)
  }
  def list_seller_inventories(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @list_seller_warehouse_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/seller-inventories", query: data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#update-delivery-status-for-seller-delivery

  When you deliver the a seller delivery order, you need to tell whether the delivery is successful or not.
  """
  @update_delivery_status_schema %{
    code: [type: :string, required: true],
    status: [type: :string, required: true, in: ~w(successful_delivery failed_delivery)],
    failure_cause: [type: :string, in: DeliveryFailureCause.enum()],
    appointment_date: Timestamp,
    note: :string
  }
  def update_delivery_status(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @update_delivery_status_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.post(client, "/orders/#{data.code}/seller-delivery/update-delivery", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#update-shipment-status-for-cross-border
  Only call this endpoint to update the shipment status of your cross border orders if you have one of the following conditions:

  - You are 3rd Party Logistic partner
  - Your store handles the shipment of the oversea packages to customers – self-deliver mode
  """
  @update_crossborder_shipment_status_schema %{
    code: [type: :string, required: true],
    status: [type: :string, required: true, in: CrossborderShipmentStatus.enum()],
    update_time: [type: Timestamp, required: true]
  }
  def update_crossborder_shipment_status(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @update_crossborder_shipment_status_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.post(client, "/orders/#{data.code}/cross-border/update-shipment", data)
    end
  end

  @doc """
  Get shipping label for on-demand fulfillment

  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#get-shipping-label-for-on-demand-fulfillment
  Return invoice label of a seller delivery order, with a selectable format. Only invoke this endpoint when:

  - Order operation model is seller delivery
  - Order is already confirmed to have enough stock
  - Order status != canceled
  """
  @get_shipping_label_schema %{
    code: [type: :string, required: true],
    format: [type: :string, default: "html", in: ["html"]]
  }
  def get_shipping_label(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_shipping_label_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/orders/#{data.code}/tiki-delivery/labels", query: data)
    end
  end

  @doc """
  Get invoice label for seller delivery

  Ref https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#get-invoice-label-for-seller-delivery
  Return invoice label of a seller delivery order, with a selectable format. Only invoke this endpoint when:

  - Order operation model is seller delivery
  - Order is already confirmed to have enough stock
  - Order status != canceled
  """
  @get_invoice_label_schema %{
    code: [type: :string, required: true],
    format: [type: :string, default: "html", in: ["html"]]
  }
  def get_invoice_label(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_invoice_label_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/orders/#{data.code}/seller-delivery/labels", query: data)
    end
  end

  @doc """
  Get shipping stamp for dropship
  https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#get-shipping-stamp-for-dropship

  Return order labels of a drop shipping order, with a selectable format. Only invoke this endpoint when:

  - Order operation model is drop shipping
  - Order is already confirmed to have enough stock
  - Order status != canceled
  """
  @get_dropship_shipping_label_schema %{
    code: [type: :string, required: true],
    format: [type: :string, default: "html", in: ["html"]]
  }
  def get_dropship_shipping_label(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_dropship_shipping_label_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/orders/#{data.code}/dropship/labels", query: data)
    end
  end

  @doc """
  Get cross border label for cross border
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#get-cross-border-label-for-cross-border

  Return order label of a cross border order, with a selectable format. Only invoke this endpoint when:

  - Order operation model is cross border
  - Order is already confirmed to have enough stock
  - Order status != canceled
  """
  @get_crossborder_shipping_label_schema %{
    code: [type: :string, required: true],
    format: [type: :string, default: "html", in: ["html"]]
  }
  def get_crossborder_shipping_label(params, opts \\ []) do
    with {:ok, data} <- Tarams.cast(params, @get_crossborder_shipping_label_schema),
         {:ok, client} <- Client.new(opts) do
      data = Helpers.clean_nil(data)
      Client.get(client, "/orders/#{data.code}/cross-border/labels", query: data)
    end
  end
end
