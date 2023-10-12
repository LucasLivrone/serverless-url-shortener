bucket         = var.tf_state_backend_bucket
key            = var.tf_state_backend_key
region         = var.aws_region
encrypt        = true
dynamodb_table = var.tf_state_lock