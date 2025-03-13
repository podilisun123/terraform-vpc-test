module "vpc_test" {
    source ="../terraform-aws-vpc"
    project_name = var.project_name
    environment_name = var.environment_name
    public_subnet_cidrs  = var.public_subnet_cidrs
    private_subnet_cidrs  = var.private_subnet_cidrs
    database_subnet_cidrs  = var.database_subnet_cidrs
    is_peering_required = var.is_peering_required
}