# Serverless URL shortener

Serverless URL shortener using Route 53, CloudFront, S3, API Gateway, Lambda and DynamoDB with Terraform.

### Index
* <a href="#solution-architecture">Solution Architecture</a>
  * <a href="#solution-flow">Solution Flow</a>
* <a href="#provision-and-deployment">Provision and Deployment</a>
  * <a href="#prerequisite">Prerequisite</a>
  * <a href="#run">Run</a>
  * <a href="#destroy">Destroy</a>
* <a href="#terraform">Terraform</a>
  * <a href="#configuration-files">Configuration Files</a>
  * <a href="#s3-backend-setup">S3 Backend setup</a>
  * <a href="#terraform-docs">terraform-docs</a>
  * <a href="#extra-terraform-documentation">Extra Terraform documentation</a>
* <a href="#demo">Demo</a>
  * <a href="#add-url-pair">Add URL pair</a>
  * <a href="#access-url">Access URL</a>
  * <a href="#delete-url-pair">Delete URL pair</a>

---

## Solution Architecture

![solution_architecture](img/solution_architecture.png)

### Solution Flow

1. The users access the URL shortener by using a custom domain thanks to Route 53 DNS routing service.
2. Route 53 directs the users to the CloudFront distribution.
3. The CloudFront distribution serves an S3 static website, providing a user-friendly interface for the URL shortener.
4. When users add or delete URL pairs, the S3 static website communicates with an API Gateway endpoint to send the request and display the feedback.
5. The API Gateway triggers the corresponding Lambda function that performs the requested action and provide feedback.
6. The Lambda functions will create or delete records in DynamoDB and respond with success or failure feedback.
7. When users use the URL shortener to redirect, a Lambda@Edge function is executed.
8. The Lambda@Edge function retrieves the full URL from DynamoDB based on the provided keyword.
9. The user's browser is redirected to the desired web page URL, completing the redirection process.

---

## Provisioning and Deployment

### Prerequisite

### Run

### Destroy

---

##  Terraform


### Configuration Files
| Configuration file | Description                                                                                                                                                                                                                                                                                                                                                                                                                               |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ``versions.tf``    | Specifies AWS provider version and region. Default profile will be used.                                                                                                                                                                                                                                                                                                                                                                  |
| ``cloudfront.tf``  | Creates a CloudFront distribution with both origin and behaviour for the **API Gateway** and the **S3 static website**.                                                                                                                                                                                                                                                                                                                   |
| ``dynamodb.tf``    | Creates the DynamoDB Key-Value database table.<br/>* Table is named: **urls_db**<br/>* Primary key is named: **keyword**<br/>* Value attribute will be named: **full_url**<br/>* On-Demand capacity mode is enabled with **PAY_PER_REQUEST** billing mode.                                                                                                                                                                                |
| ``variables.tf``   | Defines the following Lambda functions metadata (name, description and endpoint):<br/>* **add-url-pair** - Adds a new URL pair into the database. It will warn you if the **keyword** is already in use.<br/>* **delete-url-pair** - Removes a URL pair from the database. It will warn you if the **keyword** is not in use.<br/>* **redirect** -                                                                                        |
| ``iam.tf``         | Performs the following actions:<br/>1. Creates the IAM role for Lambda.<br/>2. Attaches an *AWSLambdaBasicExecutionRole* policy to it.<br/>3. Creates a policy to allow all DynamoDB actions on the created table performed by the Lambda role.                                                                                                                                                                                           |
| ``lambda.tf``      | Creates the Lambda functions defined on ``variables.tf`` using the Python functions located at ``/lambdas`` and assigns them the role created on ``iam.tf``.                                                                                                                                                                                                                                                                              |
| ``api_gateway.tf`` | Performs the following actions:<br/>1. Creates the **HTTP** type API Gateway<br/>2. Attaches the stage called **url-shortener** to it.<br/>3. Setup API logging into CloudWatch.<br/>4. Integrates the Lambda functions URI to the API Gateway with an **AWS_PROXY** type.<br/>5. Creates the Lambdas routes (endpoints) using above integrations.<br/>6. Establish **AllowExecutionFromAPIGateway** permission for the Lambda functions. |
| ``s3.tf``          | Perform the following actions for hosting a static website that servers as a landing page:<br/>1. Creates a bucket called **serverless-url-shortener**.<br/>2. Specifies the bucket web files (*index.html* & *error.html*).<br/>3. Enables versioning in the bucket.<br/>4. Establishes a bucket public access ACL settings.<br/>5. Attaches a public access bucket policy.                                                              |

### S3 Backend setup


### terraform-docs

``terraform-docs`` is a utility to generate documentation from Terraform modules in various output formats.

It can be automatically triggered by GitHub Actions thanks to the following workflow: **[.github/workflows/terraform-docs.yaml](.github/workflows/terraform-docs.yaml)**

The documentation it generates is located at **[docs/terraform-docs.md](docs/terraform-docs.md)**

More info can be found at https://terraform-docs.io/

### Extra Terraform documentation

Extra documentation about the Terraform blocks and resources used for this solution can be found at **[docs/terraform_blocks_documentation.md](docs/extra-terraform-documentation.md)**

---

## Demo

### Add URL pair

### Access URL

### Delete URL pair