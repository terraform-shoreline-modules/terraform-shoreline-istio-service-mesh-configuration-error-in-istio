resource "shoreline_notebook" "service_mesh_configuration_error_in_istio" {
  name       = "service_mesh_configuration_error_in_istio"
  data       = file("${path.module}/data/service_mesh_configuration_error_in_istio.json")
  depends_on = [shoreline_action.invoke_get_container_logs,shoreline_action.invoke_istio_config_update]
}

resource "shoreline_file" "get_container_logs" {
  name             = "get_container_logs"
  input_file       = "${path.module}/data/get_container_logs.sh"
  md5              = filemd5("${path.module}/data/get_container_logs.sh")
  description      = "Identify the source of the configuration error by reviewing the Istio configuration files and logs."
  destination_path = "/tmp/get_container_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "istio_config_update" {
  name             = "istio_config_update"
  input_file       = "${path.module}/data/istio_config_update.sh"
  md5              = filemd5("${path.module}/data/istio_config_update.sh")
  description      = "Correct the configuration error by modifying the Istio configuration files as necessary."
  destination_path = "/tmp/istio_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_container_logs" {
  name        = "invoke_get_container_logs"
  description = "Identify the source of the configuration error by reviewing the Istio configuration files and logs."
  command     = "`chmod +x /tmp/get_container_logs.sh && /tmp/get_container_logs.sh`"
  params      = ["POD_NAME","LOG_FILE_PATH","NAMESPACE","CONTAINER_NAME"]
  file_deps   = ["get_container_logs"]
  enabled     = true
  depends_on  = [shoreline_file.get_container_logs]
}

resource "shoreline_action" "invoke_istio_config_update" {
  name        = "invoke_istio_config_update"
  description = "Correct the configuration error by modifying the Istio configuration files as necessary."
  command     = "`chmod +x /tmp/istio_config_update.sh && /tmp/istio_config_update.sh`"
  params      = ["YOUR_DEPLOYMENT","YOUR_CONFIG_FILE","NAMESPACE"]
  file_deps   = ["istio_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.istio_config_update]
}

