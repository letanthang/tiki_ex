defmodule Tiki.Type.Timestamp do
  @moduledoc """
  Helper type support tiki timestamp

  ## How to use

  - Build schema:

      schema = %{
        from: Timestamp.type()
      }

  - Cast

      Tarams.cast(%{from:  DateTime.utc_now()}, schema)

  """
  alias Tiki.Type.Timestamp

  @doc """
  Cast and validate DateTime
  """
  def cast(%DateTime{} = value) do
    {:ok, value}
  end

  def cast(%NaiveDateTime{} = value) do
    {:ok, value}
  end

  def cast(_), do: {:error, "invalid datetime value"}

  @doc """
  Serialize list to string
  """
  def dump(nil, _), do: {:ok, nil}

  def dump(value, _) do
    {:ok, Calendar.strftime(value, "%Y-%m-%d %H:%M:%S")}
  end

  @doc """
  Helper module to build schema expression for Timestamp type
  """
  def type(opts \\ []) do
    [
      type: Timestamp,
      into: {Timestamp, :dump}
    ] ++ opts
  end
end
