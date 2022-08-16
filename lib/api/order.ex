defmodule Tiki.Order do
  @moduledoc """
  Support list and get order details
  """

  alias Tiki.Client

  @list_order_schema %{}
  def list_order(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @list_order_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/orders", data)
    end
  end

  @get_order_schema %{}
  def get_order(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_order_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/orders/#{data.order_id}", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#confirm-enough-stock
  This API support confirm available stock for operation models:

  - On-Demand Fulfillment
  - Seller Delivery
  - Cross Border
  """
  @confirm_stock_schema %{}
  def confirm_stock(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @confirm_stock_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/orders/#{data.order_id}/confirm-available", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#confirm-enough-stock-for-drop-shipping
  This API support confirm available stock for Drop Shipping operation model. After seller has confirmed enough stock, seller has to pack products properly. And prepare to for the driver to come picking the package.
  """
  @confirm_dropshipping_stock_schema %{}
  def confirm_dropshipping_stock(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @confirm_dropshipping_stock_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/orders/#{data.order_id}/dropship/confirm-available", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#get-expected-pickup-times
  """
  @get_expected_pickup_times_schema %{}
  def get_expected_pickup_times(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_expected_pickup_times_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/orders/dropship/expected-pickup-slots", data)
    end
  end

  @doc """
  This API return seller inventories and mappings from Tiki warehouses to seller inventories – which
  will be used in order confirmation and dropship confirmation.

  Notes, this API only return active & requisition inventories those matches the Tiki warehouse codes.
  """
  @list_seller_warehouse_schema %{}
  def list_seller_warhouse(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @list_seller_warehouse_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/seller-inventories", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#update-delivery-status-for-seller-delivery

  When you deliver the a seller delivery order, you need to tell whether the delivery is successful or not.
  """
  @update_delivery_status_schema %{}
  def update_delivery_status(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @update_delivery_status_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/order/#{data.code}/seller-delivery/update-delivery", data)
    end
  end

  @doc """
  Ref: https://open.tiki.vn/docs/docs/current/api-references/order-api-v2/#update-shipment-status-for-cross-border
  Only call this endpoint to update the shipment status of your cross border orders if you have one of the following conditions:

  - You are 3rd Party Logistic partner
  - Your store handles the shipment of the oversea packages to customers – self-deliver mode
  """
  @update_crossborder_shipment_status_schema %{}
  def update_crossborder_shipment_status(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @update_crossborder_shipment_status_schema),
         {:ok, client} <- Client.new(opts) do
      Client.post(client, "/order/#{data.code}/cross-border/update-shipment", data)
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
  @get_shipping_label_schema %{}
  def get_shipping_label(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_shipping_label_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/order/#{data.code}/tiki-delivery/labels", data)
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
  @get_invoice_label_schema %{}
  def get_invoice_label(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_invoice_label_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/order/#{data.code}/seller-delivery/labels", data)
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
  @get_dropship_shipping_label_schema %{}
  def get_dropship_shipping_label(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_dropship_shipping_label_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/order/#{data.code}/dropship/labels", data)
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
  @get_crossborder_shipping_label_schema %{}
  def get_crossborder_shipping_label(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_crossborder_shipping_label_schema),
         {:ok, client} <- Client.new(opts) do
      Client.get(client, "/order/#{data.code}/cross-border/labels", data)
    end
  end
end
