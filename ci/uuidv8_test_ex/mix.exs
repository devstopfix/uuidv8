defmodule UUIDV8Test.MixProject do
  use Mix.Project

  def project do
    [
      app: :uuidv8_test_ex,
      version: "1.0.49",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:uuidv8, manager: :rebar3, path: "../../"}
    ]
  end
end
