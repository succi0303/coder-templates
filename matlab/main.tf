terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

provider "coder" {}

data "coder_workspace" "me" {}

data "coder_workspace_owner" "me" {}

module "filebrowser" {
  source   = "registry.coder.com/modules/filebrowser/coder"
  version  = "1.0.8"
  agent_id = coder_agent.main.id
  folder   = "/home/matlab/Documents/MATLAB"
}

resource "coder_app" "matlab_browser" {
  agent_id     = coder_agent.main.id
  display_name = "Matlab Browser"
  slug         = "matlab"
  icon         = "/icon/matlab.svg"
  url          = "http://localhost:8888"
  subdomain    = true
  share        = "owner"
}

resource "coder_app" "matlab_desktop" {
  agent_id     = coder_agent.main.id
  display_name = "MATLAB Desktop"
  slug         = "desktop"
  icon         = "/icon/matlab.svg"
  url          = "http://localhost:6080"
  subdomain    = true
  share        = "owner"
}

resource "coder_agent" "main" {
  arch           = "amd64"
  os             = "linux"
  startup_script = <<EOT
        #!/bin/bash
        set -euo pipefail
        # start Matlab browser
        /bin/run.sh -browser >/dev/null 2>$1 &
        echo "Starting Matlab Browser"
        # start desktop
        /bin/run.sh -vnc >/dev/null 2>&1 &
        echo "Starting Matlab Desktop"
    EOT

  display_apps {
    vscode                 = false
    ssh_helper             = false
    port_forwarding_helper = false
  }

  metadata {
    display_name = "CPU Usage"
    interval     = 10
    order        = 1
    key          = "cpu_usage"
    script       = "coder stat cpu"
  }

  metadata {
    display_name = "RAM Usage"
    interval     = 10
    order        = 2
    key          = "ram_usage"
    script       = "coder stat mem"
  }

  metadata {
    display_name = "Disk Usage"
    interval     = 600
    order        = 3
    key          = "disk_usage"
    script       = "coder stat disk $HOME"
  }

  metadata {
    display_name = "Word of the Day"
    interval     = 86400
    order        = 4
    key          = "word_of_the_day"
    script       = <<EOT
            curl -o - --silent https://www.merriam-webster.com/word-of-the-day 2>&1 | awk ' $0 ~ "Word of the Day: [A-z]+" { print $5; exit }'
        EOT
  }
}

data "coder_parameter" "matlab_version" {
  name         = "matlab_version"
  display_name = "MATLAB Version"
  icon         = "/icon/matlab.svg"
  description  = "Choose MATLAB Version"
  default      = "r2024a"
  type         = "string"
  mutable      = false
  order        = 1
  option {
    name        = "r2023a"
    description = "r2023a"
    value       = "r2023a"
  }
  option {
    name        = "r2024a"
    description = "r2024a"
    value       = "r2024a"
  }
}

resource "docker_image" "matlab" {
  name         = "matifali/matlab:${data.coder_parameter.matlab_version.value}"
  keep_locally = true
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}-home"
}

resource "docker_container" "workspace" {
  count     = data.coder_workspace.me.start_count
  image     = docker_image.matlab.name
  name      = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}"
  hostname  = lower(data.coder_workspace.me.name)
  dns       = ["1.1.1.1"]
  entrypoint = ["sh", "-c", coder_agent.main.init_script]
  env       = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  restart   = "unless-stopped"

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  ipc_mode = "host"

  volumes {
    container_path = "/home/matlab"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }

  labels {
    label = "docker.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}