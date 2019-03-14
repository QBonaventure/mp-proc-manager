use Mix.Config


config :mp_proc_manager, MPProcManager.Controller.Maniacontrol,
  version: "200119",
  root_path: "/opt/mppm/maniacontrol/"


import_config "dev.secret.exs"
