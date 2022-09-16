defmodule Tiki.Enums do
  import Tiki.Support.EnumType

  # Tiki warehouse type:
  # - Pickup: Warehouse which supplies products to TIKI warehouses.
  # - Return: Warehouse which receives returned products from Tiki
  def_enum(WarehouseType, return: 0, pickup: 1)

  # Tiki warehouse status
  # - inactive: 0
  # - active: 1
  def_enum(WarehouseStatus, inactive: 0, active: 1)

  # Operation model
  # - Drop Shipping (dropship)
  # - Fulfillment by Tiki (instock)
  # - On-Demand Fulfillment (backorder)
  # - Seller Delivery (seller_backorder)
  # - Cross Border (cross_border)
  def_enum(OperationModel, [
    "dropship",
    "instock",
    "backorder",
    "seller_backorder",
    "cross_border"
  ])

  # | Status           | Description                                                |
  # |------------------+------------------------------------------------------------|
  # | waiting          | This order item needs availability confirmation            |
  # | seller_confirmed | confirm  enough stock – by seller                          |
  # | seller_canceled  | This order item is canceled – not enough stock – by seller |
  # | confirmed        | Internal status                                            |
  # | ready_to_pick    | Only for drop shipping order. Ready for picking by Tiki    |
  def_enum(OrderItemConfirmationStatus, [
    "waiting",
    "seller_confirmed",
    "seller_canceled",
    "confirmed",
    "ready_to_pick"
  ])

  # | inventory_type   | customer          | description                                             |
  # |------------------+-------------------+---------------------------------------------------------|
  # | cross_border     | Global seller     | products is transported from abroad                     |
  # | instock          | Vietnamese seller | products in TIKI storage, TIKI pack, TIKI deliver       |
  # | backorder        | Vietnamese seller | products in seller storage, TIKI pack, TIKI deliver     |
  # | seller_backorder | Vietnamese seller | products in seller storage, seller pack, seller deliver |
  # | drop_ship        | Vietnamese seller | products in seller storage, seller pack, TIKI deliver   |
  def_enum(InventoryType, ["cross_border", "instock", "backorder", "seller_backorder", "dropship"])

  # | Fulfillment Type | Description                                                      |
  # |------------------+------------------------------------------------------------------|
  # | tiki_delivery    | Supplied by either Tiki or Seller<br>Delivered by Tiki           |
  # | seller_delivery  | Supplied by Seller<br>Delivered by Seller                        |
  # | cross_border     | Supplied **oversea** by Seller                                   |
  # | dropship         | Supplied by Seller<br>Delivered by Tiki **directly to Customer** |
  # | instant_delivery | Supplied by either Tiki or Seller                                |
  # |                  | Delivered instantly online: Ebooks, eVoucher, scratch cards…     |
  def_enum(OrderFulfillmentType, [
    "tiki_delivery",
    "seller_delivery",
    "cross_border",
    "dropship",
    "instant_delivery"
  ])

  # | **Value**           | **Description**                             |
  # |---------------------+---------------------------------------------|
  # | queueing            | waiting for the seller to confirm the order |
  # | canceled            | canceled order                              |
  # | complete            | complete order                              |
  # | successful_delivery | successful delivery                         |
  # | processing          | order is being processing                   |
  # | waiting_payment     | waiting for payment                         |
  # | handover_to_partner | handover to partner                         |
  # | waiting_payment     | waiting payment                             |
  # | closed              | closed                                      |
  # | packaging           | packaging                                   |
  # | picking             | picking                                     |
  # | shipping            | shipping                                    |
  # | paid                | paid                                        |
  # | delivered           | success delivery                            |
  # | holded              | holded                                      |
  # | ready_to_ship       | ready to ship                               |
  # | payment_review      | payment review                              |
  # | returned            |                                             |
  # | finished_packing    | finished packing                            |

  def_enum(OrderStatus, [
    "queueing",
    "canceled",
    "complete",
    "successful_delivery",
    "processing",
    "waiting_payment",
    "handover_to_partner",
    "waiting_payment",
    "closed",
    "packaging",
    "picking",
    "shipping",
    "paid",
    "delivered",
    "holded",
    "ready_to_ship",
    "payment_review",
    "returned",
    "finished_packing"
  ])

  def_enum(OrderIncludableField,
    status_histories: "status_histories",
    item_fees: "item.fees",
    item_confirmation_histories: "item.confirmation_histories"
  )

  # Failure cause	Description	Will cancel the order?
  # - out_of_needs	Customer no longer needs the items	Yes
  # - redelivery_appointment	Customer or seller wants to make another delivery attempt	No
  # - out_of_stock	Products are out of stock	Yes
  def_enum(DeliveryFailureCause, ["out_of_needs", "redelivery_appointment", "out_of_stock"])

  # | Cross border shipment status       | Description                                    |
  # |------------------------------------+------------------------------------------------|
  # | transferring_to_foreign_warehouses | Orders transferring to your foreign warehouses |
  # | has_come_to_foreign_warehouses     | Orders has come to your foreign warehouses     |
  # | rotating_to_vietnam                | Orders rotating to vietnam                     |
  # | customs_clearance                  | Customs clearance processing                   |
  # | customs_clearance_complete         | Customs clearance complete                     |
  # | item_arrived_in_vietnam            | Orders arrived in vietnam                      |
  # | ready_for_delivery                 | Orders ready for delivery                      |
  # | on_delivery                        | Orders on delivery                             |
  # | **successful_delivery**            | Orders successful delivery                     |
  def_enum(CrossborderShipmentStatus, [
    "transferring_to_foreign_warehouses",
    "has_come_to_foreign_warehouses",
    "rotating_to_vietnam",
    "customs_clearance",
    "customs_clearance_complete",
    "item_arrived_in_vietnam",
    "ready_for_delivery",
    "on_delivery",
    "successful_delivery"
  ])

  def_enum(ProductIncludableField, ["seller", "categories", "inventory", "attributes", "images"])

  def_enum(ProductActiveType, active: 1, inactive: 0)
end
