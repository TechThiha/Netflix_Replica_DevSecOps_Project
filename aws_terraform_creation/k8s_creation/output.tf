output "k8s_master_public_ip" {
  value       = aws_instance.k8s_master.public_ip
  description = "The public IP address of the Kubernetes master instance"
}

output "k8s_worker_public_ips" {
  value       = [for instance in aws_instance.k8s_worker : instance.public_ip]
  description = "The public IP addresses of the Kubernetes worker instances"
}