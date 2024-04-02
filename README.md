# terraform-k8s-tetragon

An opinionated Terraform module that can be used to install and manage Tetragon on top of a Kubernetes cluster.

## Example Usage
```hcl
module "tetragon" {
  source = "git::ssh://git@github.com/isovalent/terraform-k8s-tetragon.git?ref=<release-tag>"

  # Wait until Cilium CNI is done.
  depends_on = [
    module.cilium
  ]

  tetragon_helm_release_name              = "tetragon"
  tetragon_helm_values_file_path          = var.tetragon_helm_values_file_path
  tetragon_helm_version                   = var.tetragon_helm_version
  tetragon_helm_chart                     = var.tetragon_helm_chart
  tetragon_namespace                      = var.tetragon_namespace
  path_to_kubeconfig_file                 = module.kubeadm_cluster.path_to_kubeconfig_file
  tetragon_helm_values_override_file_path = var.tetragon_helm_values_override_file_path
  post_tetragon_install_script            = file("${path.module}/scripts/post-tetragon-install-script.sh")
  extra_provisioner_environment_variables = local.extra_provisioner_environment_variables
}
```

## Terraform Module Doc
<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1.1 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.1.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [null_resource.provisioner](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.tp_deployer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_provisioner_environment_variables"></a> [extra\_provisioner\_environment\_variables](#input\_extra\_provisioner\_environment\_variables) | A map of extra environment variables to include when executing the provisioning script. | `map(string)` | `{}` | no |
| <a name="input_extra_tp_deployer_environment_variables"></a> [extra\_tp\_deployer\_environment\_variables](#input\_extra\_tp\_deployer\_environment\_variables) | A map of extra environment variables to include when executing the TracingPolicy deployment script. | `map(string)` | `{}` | no |
| <a name="input_path_to_kubeconfig_file"></a> [path\_to\_kubeconfig\_file](#input\_path\_to\_kubeconfig\_file) | The path to the kubeconfig file to use. | `string` | n/a | yes |
| <a name="input_post_tetragon_install_script"></a> [post\_tetragon\_install\_script](#input\_post\_tetragon\_install\_script) | A script to be run right after installing Tetragon. | `string` | `""` | no |
| <a name="input_pre_tetragon_install_script"></a> [pre\_tetragon\_install\_script](#input\_pre\_tetragon\_install\_script) | A script to be run right before installing Tetragon. | `string` | `""` | no |
| <a name="input_tetragon_helm_chart"></a> [tetragon\_helm\_chart](#input\_tetragon\_helm\_chart) | The name of the Helm chart to use to install Tetragon. It is assumed that the Helm repository containing this chart has been added beforehand (e.g. using 'helm repo add'). | `string` | `"tetragon/tetragon"` | no |
| <a name="input_tetragon_helm_extra_args"></a> [tetragon\_helm\_extra\_args](#input\_tetragon\_helm\_extra\_args) | Extra arguments to be passed to the 'helm upgrade --install' command that installs Tetragon. | `string` | `""` | no |
| <a name="input_tetragon_helm_release_name"></a> [tetragon\_helm\_release\_name](#input\_tetragon\_helm\_release\_name) | The name of the Helm release to use for tetragon. | `string` | `"tetragon"` | no |
| <a name="input_tetragon_helm_values_file_path"></a> [tetragon\_helm\_values\_file\_path](#input\_tetragon\_helm\_values\_file\_path) | The path to the file containing the values to use when installing Tetragon. | `string` | n/a | yes |
| <a name="input_tetragon_helm_values_override_file_path"></a> [tetragon\_helm\_values\_override\_file\_path](#input\_tetragon\_helm\_values\_override\_file\_path) | The path to the file containing the values to use when installing Tetragon. These values will override the ones in 'tetragon\_helm\_values\_file\_path'. | `string` | `""` | no |
| <a name="input_tetragon_helm_version"></a> [tetragon\_helm\_version](#input\_tetragon\_helm\_version) | The version of the Tetragon Helm chart to install. | `string` | n/a | yes |
| <a name="input_tetragon_namespace"></a> [tetragon\_namespace](#input\_tetragon\_namespace) | The namespace in which to install Tetragon. | `string` | `"kube-system"` | no |
| <a name="input_tetragon_tracingpolicy_directory"></a> [tetragon\_tracingpolicy\_directory](#input\_tetragon\_tracingpolicy\_directory) | Path to the directory where TracingPolicy files are stored which should automatically be applied. The directory can contain one or multiple valid TracingPoliciy YAML files. | `string` | `""` | no |

### Outputs

No outputs.
<!-- END_TF_DOCS -->