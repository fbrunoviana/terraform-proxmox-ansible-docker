output "root_password" {
  value = random_password.password.result
  description = "The password for the root user of the LXC container."
  sensitive = true
}