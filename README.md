# Serverless URL shortener

Serverless URL shortener using S3, Lambda, API Gateway and DynamoDB with Terraform.

---

### Index
* <a href="#solution-architecture">Solution Architecture</a>
* <a href="#terraform-files">Terraform Files</a>
* <a href="#provision-and-deployment">Provision and Deployment</a>
  * <a href="#prerequisite">Prerequisite</a>
  * <a href="#run">Run</a>
  * <a href="#destroy">Destroy</a>

---

# Solution Architecture

# Terraform Files

* ``versions.tf`` - Specifies AWS provider version and region. Default profile will be used.


* ``dynamodb.tf`` - Creates the DynamoDB Key-Value database table.
  * Table is named: **urls_db**
  * Primary key is named: **keyword**
  * Value attribute will be named: **full_url**
  * On-Demand capacity mode is enabled with **PAY_PER_REQUEST** billing mode.


* ``variables.tf`` - Defines the following Lambda functions metadata (name, description and endpoint):
  * **add-url-pair** - Adds a new URL pair into the database. It will warn you if the **keyword** is already in use.
  * **delete-url-pair** - Removes a URL pair from the database. It will warn you if the **keyword** is not in use.


* ``iam.tf`` - Performs the following actions:
  1. Creates the IAM role for Lambda
  2. Attaches an *AWSLambdaBasicExecutionRole* policy to it 
  3. Creates a policy to allow all DynamoDB actions on the created table performed by the Lambda role.


* ``lambda.tf`` - Creates the Lambda functions defined on ``variables.tf`` and assigns them the role created on ``iam.tf``.


* ``api_gateway.tf`` - Performs the following actions:
  1. Creates the **HTTP** type API Gateway
  2. Attaches the stage called **url-shortener** to it.
  3. Setup API logging into CloudWatch.
  4. Integrates the Lambda functions URI to the API Gateway with an **AWS_PROXY** type.
  5. Creates the Lambdas routes (endpoints) using above integrations.
  6. Establish **AllowExecutionFromAPIGateway** permission for the Lambda functions.


* ``s3.tf`` - Perform the following actions for hosting a static website that servers a landing page:
  1. Creates a bucket called **serverless-url-shortener**.
  2. Specifies the bucket web files (*index.html* & *error.html*).
  3. Enables versioning in the bucket.
  4. Establishes a bucket public access ACL settings.
  5. Attaches a public access bucket policy.


# Provisioning and Deployment

## Prerequisite

## Run

## Destroy

