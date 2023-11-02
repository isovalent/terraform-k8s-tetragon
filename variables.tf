variable "tetragon_helm_chart" {
  default     = "tetragon/tetragon"
  description = "The name of the Helm chart to use to install Tetragon. It is assumed that the Helm repository containing this chart has been added beforehand (e.g. using 'helm repo add')."
  type        = string
}

variable "tetragon_helm_extra_args" {
  default     = ""
  description = "Extra arguments to be passed to the 'helm upgrade --install' command that installs Tetragon."
  type        = string
}

variable "tetragon_helm_release_name" {
  default     = "tetragon"
  description = "The name of the Helm release to use for tetragon."
  type        = string
}

variable "tetragon_helm_values_file_path" {
  description = "The path to the file containing the values to use when installing Tetragon."
  type        = string
}

variable "tetragon_helm_values_override_file_path" {
  description = "The path to the file containing the values to use when installing Tetragon. These values will override the ones in 'tetragon_helm_values_file_path'."
  type        = string
}

variable "tetragon_helm_version" {
  description = "The version of the Tetragon Helm chart to install."
  type        = string
}

variable "tetragon_namespace" {
  default     = "kube-system"
  description = "The namespace in which to install Tetragon."
  type        = string
}

variable "extra_provisioner_environment_variables" {
  default     = {}
  description = "A map of extra environment variables to include when executing the provisioning script."
  type        = map(string)
}

variable "path_to_kubeconfig_file" {
  description = "The path to the kubeconfig file to use."
  type        = string
}

variable "pre_tetragon_install_script" {
  default     = ""
  description = "A script to be run right before installing Tetragon."
  type        = string
}

variable "post_tetragon_install_script" {
  default     = ""
  description = "A script to be run right after installing Tetragon."
  type        = string
}