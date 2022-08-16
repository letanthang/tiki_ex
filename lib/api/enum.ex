defmodule Tiki.Enums do
  import Tiki.Support.EnumType

  # Tiki warehouse type:
  # - Pickup: Warehouse which supplies products to TIKI warehouses.
  # - Return: Warehouse which receives returned products from Tiki
  def_enum(WarehouseTypeEnum, return: 0, pickup: 1)

  # Tiki warehouse status
  # - inactive: 0
  # - active: 1
  def_enum(WarehouseStatusEnum, inactive: 0, active: 1)
end
