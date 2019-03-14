defmodule MPProcManager.ServerConfig do
  alias __MODULE__
  alias MPProcManager.ServerConfigStore
  import Record
  defrecord(:xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl"))
  defrecord(:xmlAttribute, extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl"))
  defrecord(:xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  @app_path Application.get_env(:mp_proc_manager, :app_path)
  @root_path Application.get_env(:mp_proc_manager, :mp_servers_root_path)
  @config_path @root_path <> "UserData/Config/"
  @maps_path @root_path <> "UserData/Maps/"

  defstruct [
    name: nil,
    title_pack: "TMStadium@nadeo",
    comment: nil,
    login: nil,
    password: nil,
    validation_key: Application.get_env(:mp_proc_manager, :masteraccount_validation_key),
    max_players: "32",
    player_pwd: nil,
    spec_pwd: nil,
    superadmin_pass: nil,
    admin_pass: nil,
    user_pass: nil,
    listening_ports: nil,
  ]


  def create_config_file(%ServerConfig{} = serv_config) do
    xml = get_base_xml()

    authorization_levels =
      elem(xml, 2)
      |> List.keyfind(:authorization_levels, 0)
      |> elem(2)
    authorization_levels = {:authorization_levels, [], authorization_levels}

    masterserver_account =
      elem(xml, 2)
      |> List.keyfind(:masterserver_account, 0)
      |> elem(2)
      |> List.keyreplace(:password, 0, {:password, [], [charlist(serv_config.password)]})
      |> List.keyreplace(:login, 0, {:login, [], [charlist(serv_config.login)]})
      |> List.keyreplace(:validation_key, 0, {:validation_key, [], [charlist(serv_config.validation_key)]})
    masterserver_account = {:masterserver_account, [], masterserver_account}

    server_options =
      elem(xml, 2)
      |> List.keyfind(:server_options, 0)
      |> elem(2)
      |> List.keyreplace(:name, 0, {:name, [], [charlist(serv_config.name)]})
      |> List.keyreplace(:comment, 0, {:comment, [], [charlist(serv_config.comment)]})
      |> List.keyreplace(:max_players, 0, {:max_players, [], [charlist(serv_config.max_players)]})
      |> List.keyreplace(:password_spectator, 0, {:password_spectator, [], []})
      |> List.keyreplace(:password, 0, {:password, [], [charlist(serv_config.player_pwd)]})
    server_options = {:server_options, [], server_options}

    system_config =
      elem(xml, 2)
      |> List.keyfind(:system_config, 0)
      |> elem(2)
    system_config = {:system_config, [], system_config}

    new_xml = {:dedicated, [], [authorization_levels, masterserver_account, server_options, system_config]}

    pp = :xmerl.export_simple([new_xml], :xmerl_xml)
    |> List.flatten

    filename = serv_config.login <> ".txt"
    :file.write_file(@config_path <> filename, pp)

    filename
  end


  def create_tracklist(%ServerConfig{login: login}) do
    target_path = "#{@maps_path}MatchSettings/#{login}.txt"
    source_path = "#{@maps_path}MatchSettings/tracklist.txt"

    'ls #{target_path} >> /dev/null 2>&1 || cp #{source_path} #{target_path}'
    |> :os.cmd
  end

  defp charlist(value) when is_binary(value), do: String.to_charlist(value)
  defp charlist(nil = value), do: []


  def get_base_xml() do
    {result, _misc} =
      @config_path <> "dedicated_cfg.default.txt"
      |>:xmerl_scan.file([{:space, :normalize}])
    [clean] = :xmerl_lib.remove_whitespace([result])
    :xmerl_lib.simplify_element(clean)
  end

end
