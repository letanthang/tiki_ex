defmodule Tiki.Client do
  @moduledoc """
  Process and sign data before sending to Tiktok and process response from Tiki server
  Proxy could be config

      config :tiki, :config,
            proxy: "http://127.0.0.1:9090",
            timeout: 10_000,
            response_handler: MyModule,
            middlewares: [] # custom middlewares

  Your custom reponse handler module must implement `handle_response/1`
  """

  @default_endpoint "https://api.tiki.vn/integration/v2/"
  @doc """
  Create new client
  **Options**
  - `access_token [string]`: access token,
  - `endpoint [string]`: custom endpoint
  - `form_data [boolean]`: use form data, using json by default
  """

  def new(opts \\ []) do
    config = Tiki.Support.Helpers.get_config()

    # if proxy config -> set for adapter
    options =
      if config.proxy do
        [adapter: [proxy: config.proxy]]
      else
        []
      end

    middlewares = [
      {Tesla.Middleware.BaseUrl, opts[:endpoint] || @default_endpoint},
      {Tesla.Middleware.Opts, options},
      Tesla.Middleware.KeepRequest
    ]

    middlewares =
      if opts[:access_token] do
        middlewares ++
          [{Tesla.Middleware.Headers, [{"Authorization", "Bearer #{opts[:access_token]}"}]}]
      else
        middlewares
      end

    middlewares =
      if opts[:form_data] do
        middlewares ++ [Tesla.Middleware.FormUrlencoded, Tesla.Middleware.DecodeJson]
      else
        middlewares ++ [Tesla.Middleware.JSON]
      end

    # if config setting timeout, otherwise use default settings
    middlewares =
      if config.timeout do
        [{Tesla.Middleware.Timeout, timeout: config.timeout} | middlewares]
      else
        middlewares
      end

    {:ok, Tesla.client(middlewares ++ config.middlewares)}
  end

  @doc """
  Perform a GET request

      get("/users")
      get("/users", query: [scope: "admin"])
      get(client, "/users")
      get(client, "/users", query: [scope: "admin"])
      get(client, "/users", body: %{name: "Jon"})
  """
  @spec get(Tesla.Client.t(), String.t(), keyword()) :: {:ok, any()} | {:error, any()}
  def get(client, path, opts \\ []) do
    client
    |> Tesla.get(path, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  @doc """
  Perform a POST request.

      post("/users", %{name: "Jon"})
      post("/users", %{name: "Jon"}, query: [scope: "admin"])
      post(client, "/users", %{name: "Jon"})
      post(client, "/users", %{name: "Jon"}, query: [scope: "admin"])
  """
  @spec post(Tesla.Client.t(), String.t(), map(), keyword()) :: {:ok, any()} | {:error, any()}
  def post(client, path, body, opts \\ []) do
    client
    |> Tesla.post(path, body, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  @doc """
  Perform a POST request.

      post("/users", %{name: "Jon"})
      post("/users", %{name: "Jon"}, query: [scope: "admin"])
      post(client, "/users", %{name: "Jon"})
      post(client, "/users", %{name: "Jon"}, query: [scope: "admin"])
  """
  @spec put(Tesla.Client.t(), String.t(), map(), keyword()) :: {:ok, any()} | {:error, any()}
  def put(client, path, body, opts \\ []) do
    client
    |> Tesla.put(path, body, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  @doc """
  Perform a DELETE request

      delete("/users")
      delete("/users", query: [scope: "admin"])
      delete(client, "/users")
      delete(client, "/users", query: [scope: "admin"])
      delete(client, "/users", body: %{name: "Jon"})
  """
  @spec delete(Tesla.Client.t(), String.t(), keyword()) :: {:ok, any()} | {:error, any()}
  def delete(client, path, opts \\ []) do
    client
    |> Tesla.delete(path, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  defp process(response) do
    module =
      Application.get_env(:tiki, :config, [])
      |> Keyword.get(:response_handler, __MODULE__)

    module.handle_response(response)
  end

  @doc """
  Default response handler for request, user can customize by pass custom module in config
  """
  def handle_response(response) do
    case response do
      {:ok, %{body: body}} ->
        if is_map(body) && body["error"] do
          {:error, body}
        else
          {:ok, body}
        end

      {_, _result} ->
        {:error, %{type: :system_error, response: response}}
    end
  end
end
