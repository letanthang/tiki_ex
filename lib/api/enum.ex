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
end
