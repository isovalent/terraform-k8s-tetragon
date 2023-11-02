// The resource used to run the provisioning script.
resource "null_resource" "main" {
  triggers = merge(local.provisioner_environment, {
    TETRAGON_HELM_VALUES_FILE_SHA1 = sha1(file(var.tetragon_helm_values_file_path)) // Use the contents of the Tetragon (base) Helm values file as a trigger.
    PROVISIONER_SHA1             = sha1(file(local.provisioner_path)),          // Use the contents of the provisioning script as a trigger.
  })
  provisioner "local-exec" {
    command     = local.provisioner_path        // The path to the provisioning script.
    environment = local.provisioner_environment // The set of environment variables used when running the provisioning script.
  }
}
