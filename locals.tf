locals {
  provisioner_environment = merge(var.extra_provisioner_environment_variables, local.provisioner_environment_variables)               // The full set of environment variables passed to the provisioning script.
  provisioner_environment_variables = {                                                                                               // The set of environment variables set by this module on the provisioning script.
    TETRAGON_HELM_CHART                = var.tetragon_helm_chart,                                                                     // The Tetragon Helm chart to deploy.
    TETRAGON_HELM_EXTRA_ARGS           = var.tetragon_helm_extra_args                                                                 // Extra arguments to be passed to the 'helm upgrade --install' command that installs Tetragon.
    TETRAGON_HELM_RELEASE_NAME         = var.tetragon_helm_release_name,                                                              // The name to use for the Tetragon Helm release.
    TETRAGON_HELM_VALUES_FILE          = var.tetragon_helm_values_file_path,                                                          // The path to the Helm values file to use when installing Tetragon.
    TETRAGON_HELM_VALUES_OVERRIDE_FILE = var.tetragon_helm_values_override_file_path,                                                 // The path to the Helm values override file to use when installing Tetragon.
    TETRAGON_HELM_VERSION              = var.tetragon_helm_version,                                                                   // The version of the Tetragon Helm chart to deploy.
    TETRAGON_NAMESPACE                 = var.tetragon_namespace,                                                                      // The namespace where to deploy Tetragon.
    INSTALL_KUBE_PROMETHEUS_CRDS       = true,                                                                                        // Whether to install (some of) the 'kube-prometheus' CRDs (such as 'ServiceMonitor').
    KUBECONFIG                         = var.path_to_kubeconfig_file                                                                  // The path to the kubeconfig file that will be created and output.
    PRE_TETRAGON_INSTALL_SCRIPT        = var.pre_tetragon_install_script != "" ? base64encode(var.pre_tetragon_install_script) : ""   // The script to execute before installing Tetragon.
    POST_TETRAGON_INSTALL_SCRIPT       = var.post_tetragon_install_script != "" ? base64encode(var.post_tetragon_install_script) : "" // The script to execute after installing Tetragon.
    WAIT_FOR_TETRAGON_CRDS             = var.wait_for_tetragon_crds
  }
  provisioner_path        = "${abspath(path.module)}/scripts/provisioner.sh"
  tp_deployer_environment = merge(var.extra_tp_deployer_environment_variables, local.tp_deployer_environment_variables) // The full set of environment variables passed to the TracingPolicy deployment script.
  tp_deployer_environment_variables = {                                                                                 // The set of environment variables set by this module on the TracingPolicy deployment script.
    KUBECONFIG = var.path_to_kubeconfig_file                                                                            // The path to the kubeconfig file
    TP_DIR     = var.tetragon_tracingpolicy_directory                                                                   // The path to the TracingPolicies that should be deployed.
  }
  tp_deployer_path = "${abspath(path.module)}/scripts/tp-deployer.sh"
}
