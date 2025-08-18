resource "aws_vpc_peering_connection" "vpc2_to_vpc1" {
  peer_vpc_id = var.vpc1_vpc_id
  vpc_id      = var.vpc2_vpc_id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "${var.environment}-vpc2-to-vpc1-peering"
  }
}

resource "aws_route" "vpc2_to_vpc1" {
  route_table_id            = var.vpc2_private_route_table_id
  destination_cidr_block    = var.vpc1_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc2_to_vpc1.id
}

resource "aws_route" "vpc1_to_vpc2" {
  count                     = length(var.vpc1_route_table_ids)
  route_table_id            = var.vpc1_route_table_ids[count.index]
  destination_cidr_block    = var.vpc2_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc2_to_vpc1.id
}
