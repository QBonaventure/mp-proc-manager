defmodule MPProcManager.Mixfile do
  use Mix.Project

  defp description do
    """
    Processus manager for ManiaPlanet & ManiaControl servers
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Quentin Bonaventure"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/fearthec/mp-proc-manager"}
    ]
  end

  def project do
    [
      app: :mp_proc_manager,
      version: "0.1.1",
      elixir: "~> 1.9.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {MPProcManager.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:xmlrpc, "~> 1.4"},
      {:httpoison, "~> 1.6"},
      {:observer_cli, "~> 1.5"}
    ]
  end
end
