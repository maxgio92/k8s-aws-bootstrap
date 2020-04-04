output "cluster_master_node_ips" {
  value = aws_instance.cluster_master_node.*.public_ip
}
output "cluster_worker_node_ips" {
  value = aws_instance.cluster_worker_node.*.public_ip
}
