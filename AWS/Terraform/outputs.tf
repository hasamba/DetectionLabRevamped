output "region" {
  value = data.aws_region.current.name
}

output "logger_public_ip" {
  value = aws_instance.logger.public_ip
}

output "logger_ssh_access" {
  value = "ssh vagrant@${aws_instance.logger.public_ip} (password=vagrant)"
}

output "dc_public_ip" {
  value = aws_instance.dc.public_ip
}

output "wef_public_ip" {
  value = aws_instance.wef.public_ip
}

output "win11_public_ip" {
  value = aws_instance.win11.public_ip
}

output "fleet_url" {
  value = local.fleet_url
}

output "splunk_url" {
  value = local.splunk_url
}

output "guacamole_url" {
  value = local.guacamole_url
}

output "velociraptor_url" {
  value = local.velociraptor_url
}
