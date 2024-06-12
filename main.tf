resource "null_resource" "provisioner" {
  triggers = merge(local.provisioner_environment, {
    TETRAGON_HELM_VALUES_FILE_SHA1 = sha1(file(var.tetragon_helm_values_file_path)) // Use the contents of the Tetragon (base) Helm values file as a trigger.
    PROVISIONER_SHA1               = sha1(file(local.provisioner_path)),            // Use the contents of the provisioning script as a trigger.
  })
  provisioner "local-exec" {
    command     = local.provisioner_path        // The path to the provisioning script.
    environment = local.provisioner_environment // The set of environment variables used when running the provisioning script.
  }
}

resource "null_resource" "tp_deployer" {
  count = var.tetragon_tracingpolicy_directory != "" ? 1 : 0
  depends_on = [
    null_resource.provisioner
  ]
  triggers = merge(local.tp_deployer_environment, {
    TRACINGPOLICY_DIR_SHA1 = sha1(join("", [for f in fileset(var.tetragon_tracingpolicy_directory, "*.yaml") : filesha1("${var.tetragon_tracingpolicy_directory}/${f}")]))
    TP_DEPLOYER_SHA1       = sha1(file(local.tp_deployer_path)),
  })
  provisioner "local-exec" {
    command     = local.tp_deployer_path        // The path to the TracingPolicy deployment script.
    environment = local.tp_deployer_environment // The set of environment variables used when running the TracingPolicy deployment script.
  }
}
