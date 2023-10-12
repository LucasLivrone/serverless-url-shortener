# Use S3 backend for storing the State file and State lock.
terraform {
  backend "s3" {}
}
/*
Since variables cannot be used in this block, we will rely on "terraform init -backend-config" during the
GitHub Actions workflow run in order to specify the details of the backend.This is how it looks like:
  terraform init \
  -backend-config="bucket=${{ vars.TF_STATE_BACKEND_BUCKET }}" \
  -backend-config="key=${{ vars.TF_STATE_BACKEND_KEY }}" \
  -backend-config="region=${{ vars.REGION }}" \
  -backend-config="dynamodb_table=${{ vars.TF_STATE_LOCK }}" \
  -backend-config="encrypt=true"
*/