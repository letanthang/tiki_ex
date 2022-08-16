defmodule Tiki.Support.EnumType do
  @moduledoc """
  EctoEnum helps to generate enum type and enum helper function.
  You can define an enum module manually like this
      defmodule MyEnum do
          def enum, do: ["value1", "value2", "value3"]
          def value1, do: "value1"
          def value2, do: "value2"
          def value3, do: "value3"
      end

  Now with EctoEnum you can do it with a few lines of code
      defmodule MyModule do
          import Tiki.Support.EnumType
          def_enum MyEnum, ["value1", "value2", "value3"]
      end

  It still provides same functions with manual implemented module

  ## Use different name and value

  In some case, you want to use a different name instead of the same with value, you can pass a tuple like this
      defmodule MyModule do
        import Tiki.Support.EnumType
        def_enum MyEnum, name1: "Value 1", name2: "value 2"
      end
      MyModule.MyEnum.name1()
      # => "Value 1"
  """

  defmacro def_enum(module_name, enum) do
    enum =
      Enum.map(enum, fn
        {k, v} -> {k, v}
        v -> {v, v}
      end)

    enum_values = Enum.map(enum, &elem(&1, 1))

    quote location: :keep do
      defmodule unquote(module_name) do
        def enum do
          unquote(enum_values)
        end

        unquote(
          for {key, value} <- enum do
            quote do
              def unquote(:"#{key}")() do
                unquote(value)
              end
            end
          end
        )
      end
    end
  end
end
