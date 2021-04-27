terraform {
  required_providers {
    aws = {
      configuration_aliases = [ aws.edge_lambda ]
    }
  }
}

