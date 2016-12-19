defmodule Mongox.Mixfile do
  use Mix.Project

  def project do
    [app: :mongox,
     version: "0.2.0",
     elixir: "~> 1.0",
     deps: deps,
     name: "MongoX",
     source_url: "https://github.com/emerleite/mongox",
     description: description,
     test_coverage: [tool: ExCoveralls],
     package: package]
  end

  def application do
    [applications: [:logger, :connection],
     mod: {Mongo, []},
     env: []]
  end

  defp deps do
    [{:connection, "~> 1.0"},
     {:poolboy,    "~> 1.5", optional: true},
     {:excoveralls, "~> 0.5", only: :test},
     {:ex_doc, github: "elixir-lang/ex_doc"}]
  end

  defp description do
    "MongoDB driver for Elixir."
  end

  defp package do
    [maintainers: ["Emerson Macedo"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/emerleite/mongox"}]
  end
end
