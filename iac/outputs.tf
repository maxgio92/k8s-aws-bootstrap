# Master nodes

output "cluster_master_size" {
  value = length(aws_instance.cluster_master_node)
}

output "cluster_master_nodes_public_ips" {
  value = aws_instance.cluster_master_node.*.public_ip
}

output "cluster_master_nodes_public_dns" {
  value = aws_instance.cluster_master_node.*.public_dns
}

output "cluster_master_nodes_private_ips" {
  value = aws_instance.cluster_master_node.*.private_ip
}

output "cluster_master_nodes_private_dns" {
  value = aws_instance.cluster_master_node.*.private_dns
}

# Worker nodes

output "cluster_worker_size" {
  value = length(aws_instance.cluster_worker_node)
}

output "cluster_worker_nodes_public_ips" {
  value = aws_instance.cluster_worker_node.*.public_ip
}

output "cluster_worker_nodes_public_dns" {
  value = aws_instance.cluster_worker_node.*.public_dns
}

output "cluster_worker_nodes_private_ips" {
  value = aws_instance.cluster_worker_node.*.private_ip
}

output "cluster_worker_nodes_private_dns" {
  value = aws_instance.cluster_worker_node.*.private_dns
}
