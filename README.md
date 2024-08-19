# AWS IAM Identity Center Sync and ABAC

## 1.0 Overview
Attribute-based access control (ABAC) is an authorization strategy that defines permissions based
on attributes or *tags*. Tags can be attached to IAM users or roles, and to AWS resources. You can
define policies using tag condition keys to grant permissions to your principals based on their tags.


## 2.0 Project Outline
A user should be able to create a new project that:
* Contains all permission sets for a project
* Defines individual permission sets as inline policies
* Replicates or defines customer policies
* Include a variable for a tag that will only allows access to resources with same tag

### 2.1 ABAC Policies
> **IMPORTANT**
> Policies using the following strategy allow *all* actions for a service, but explicitly deny 
> permissions-altering actions. Denying actions overrides any other policies allowing the principal 
> to perform that action. This can have unintended results. The best practice is to use explicit 
> denies only when there is no circumstance that should allow that action. Otherwise, allow a list 
> of individual actions, and the unwanted actions are denied by default. 

Policies that allow for ABAC based on permissions should allow principals to create, edit, and delete resources with values that match the principal's tags. These Policies can be divided into multiple statements.

#### 2.1.1 Matching Principal and Resource Tags
This statement **ALLOWS** all of a service's actions on all related resources if the resource tags match the principal tags.
```
statement {
    sid       = "AllActions<AWS_SERVICE>SameTags"
    effect    = "Allow"
    actions   = ["<AWS_SERVICE>:*"]
    resources = ["*"]

    # Add a condition block for every tag you assign a resource
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/tag1"
      values   = ["$${aws:PrincipalTag/tag1}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/tag2"
      values   = ["$${aws:PrincipalTag/tag2}"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"

      # List the tag keys
      values = [
        "tag1",
        "tag2"
      ]
    }

    # Add a condition block for every tag you assign a resource
    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/tag1"
      values   = ["$${aws:PrincipalTag/tag1}"]
    }

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/tag2"
      values   = ["$${aws:PrincipalTag/tag2}"]
    }
  }
```

#### 2.1.2 No Resource Tags
This statement **ALLOWS** certain of a service's actions on all related resources if there are no resource tags.
```
statement {
    sid       = "AllResources<AWS_SERVICE>NoTags"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<ACTION>"]
  }
```

#### 2.1.3 Matching a Principal tag
This statement **ALLOWS** read-only operations if the principal is tagged with the same access tag as the resource.
```
statement {
    sid       = "Read<AWS_SERVICE>SameTag"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<READ_ONLY_OPS>*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/tag1"
      values   = ["$${aws:PrincipalTag/tag1}"]
    }
  }
```

#### 2.1.4 Requests to Remove Tags
This statement **DENIES** requests to remove tags with keys beginning with a certain string. These tags control resouce access; therefore, removing tags removes permissions.
```
statement {
    sid       = "DenyUntag<AWS_SERVICE>ReservedTags"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:<ACTION>"]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:TagKeys"
      values   = ["<SOME_STRING>*"]
    }
  }
```

#### 2.1.5 Resource Permissions Management
This statement **DENIES** access to create, edit, or delete resource-based policies. These policies could be used to change the permissions of the resource.
```
statement {
    sid       = "DenyPermissionsManagement"
    effect    = "Deny"
    resources = ["*"]
    actions   = ["<AWS_SERVICE>:*Policy"]
  }
```

## 3.0 Considerations
* Customise inline policies to attach to users or groups and filter through them.
* Implement ABAC in other services and resources:
    * Resources like EC2 instances. Could potentially try an S3 bucket again.
    * Automate that process for creating and applying the role. 
    * Tag the roles and users.
* Check if actions could be a wildcard or if you have to specify the actions.
For example, could you use `[*]` instead of something like `ec2:ListInstances`.
* Check if roles have to be given tags manually or if they can be automatically
applied whenever a new SSO instance is given.

> **NOTE**
> When playing with IAM SSO and Terraform State. Always have an admin account 
> assigned to the managedment account outside of Terraform state, in case you
> make the mistake of removing all access.
>
> If pushing a change altering or going near admin permission sets and the 
> management account push  it from another user, or use a use/role with keys.

## 4.0 Resources/Services that allow for ABAC
<div style="height: 200px; overflow-y: auto;">

| Header 1 | Header 2 |
AWS Account Management	 No
AWS Activate Console	 No
AWS Amplify Admin	 No
AWS Amplify	 Partial
AWS Amplify UI Builder	 Yes
Apache Kafka APIs for Amazon MSK clusters	 No
Amazon API Gateway	 No
Amazon API Gateway Management	 Yes
Amazon API Gateway Management V2	 Yes
AWS App Studio	 No
AWS App2Container	 No
AWS AppConfig	 Yes
AWS AppFabric	 Yes
Amazon AppFlow	 Yes
Amazon AppIntegrations	 Yes
Application Auto Scaling	 Yes
AWS Application Cost Profiler	 No
AWS Application Discovery  Arsenal	 No
AWS Application Discovery Service	 No
AWS Application Migration Service	 Yes
AWS Application Transformation Service	 No
AWS App Mesh	 Yes
AWS App Mesh Preview	 No
AWS App Runner	 Yes
Amazon AppStream 2.0	 Yes
AWS AppSync	 Yes
AWS Artifact	 No
Amazon Athena	 Yes
AWS Audit Manager	 Yes
AWS Auto Scaling	 No
AWS B2B Data Interchange	 Yes
AWS Backup	 Yes
AWS Backup Gateway	 Yes
AWS Backup storage	 No
AWS Batch	 Yes
Amazon Bedrock	 Yes
AWS Billing and Cost Management	 No
AWS Billing and Cost Management Data Exports	 Yes
AWS Billing Conductor	 Yes
Amazon Braket	 Yes
AWS Budget Service	 No
AWS BugBust	 Yes
AWS Certificate Manager (ACM)	 Yes
AWS Chatbot	 No
Amazon Chime	 Yes
AWS Clean Rooms	 Yes
AWS Clean Rooms ML	 Yes
AWS Client VPN	 No
AWS Cloud9	 Yes
AWS Cloud Control API	 No
Amazon Cloud Directory	 No
AWS CloudFormation	 Yes
Amazon CloudFront	 Partial
Amazon CloudFront KeyValueStore	 No
AWS CloudHSM	 Yes
AWS Cloud Map	 Yes
Amazon CloudSearch	 No
AWS CloudShell	 No
AWS CloudTrail	 Yes
AWS CloudTrail Data	 Yes
Amazon CloudWatch	 Yes
Amazon CloudWatch Application Insights	 No
Amazon CloudWatch Application Signals	 Yes
Amazon CloudWatch Evidently	 Yes
Amazon CloudWatch Internet Monitor	 Yes
Amazon CloudWatch Logs	 Partial
Amazon CloudWatch Network Monitor	 Yes
Amazon CloudWatch Observability Access Manager	 Yes
Amazon CloudWatch RUM	 Yes
Amazon CloudWatch Synthetics	 Yes
AWS CodeArtifact	 Yes
AWS CodeBuild	 Partial (Info)
Amazon CodeCatalyst	 Yes
AWS CodeCommit	 Yes
AWS CodeConnections	 Yes
AWS CodeDeploy	 Yes
AWS CodeDeploy secure host commands service	 No
Amazon CodeGuru Profiler	 Yes
Amazon CodeGuru Reviewer	 Yes
Amazon CodeGuru Security	 Yes
AWS CodePipeline	 Yes
AWS CodeStar	 Yes
AWS CodeStar Connections	 Yes
AWS CodeStar Notifications	 Yes
Amazon CodeWhisperer	 Yes
Amazon Cognito	 Yes
Amazon Cognito Sync	 No
Amazon Cognito user pools	 Yes
Amazon Comprehend	 Yes
Amazon Comprehend Medical	 No
AWS Compute Optimizer	 No
AWS Config	 Yes
Amazon Connect	 Yes
Amazon Connect Cases	 Yes
Amazon Connect Customer Profiles	 Yes
Amazon Connect High-volume outbound communications	 Yes
Amazon Connect Voice ID	 Yes
AWS Console Mobile Application	 No
AWS Consolidated Billing	 No
AWS Control Catalog	 No
AWS Control Tower	 No
AWS Cost and Usage Report	 No
AWS Cost Explorer	 Yes
AWS Cost Optimization Hub	 No
AWS  Customer Verification Service	 No
AWS Database Migration Service	 Yes
Database Query Metadata Service	 No
AWS Data Exchange	 Yes
Amazon Data Lifecycle Manager	 Yes
AWS Data Pipeline	 Partial
AWS DataSync	 Yes
Amazon DataZone	 No
AWS Deadline Cloud	 Yes
AWS DeepComposer	 Yes
AWS DeepRacer	 Yes
Amazon Detective	 Yes
AWS Device Farm	 Yes
Amazon DevOps Guru	 No
AWS Diagnostic tools	 Yes
AWS Direct Connect	 Yes
AWS Directory Service	 Yes
Amazon DocumentDB Elastic Clusters	 Yes
Amazon DynamoDB Accelerator (DAX)	 No
Amazon DynamoDB	 No
Amazon Elastic Compute Cloud (Amazon EC2)	 Yes
Amazon EC2 Auto Scaling	 Yes
EC2 Image Builder	 Yes
Amazon EC2 Instance Connect	 No
Amazon ElastiCache	 Yes
AWS Elastic Beanstalk	 Yes
Amazon Elastic Block Store (Amazon EBS)	 Yes
Amazon Elastic Container Registry (Amazon ECR)	 Yes
Amazon Elastic Container Registry Public (Amazon ECR Public)	 Yes
Amazon Elastic Container Service (Amazon ECS)	 Yes
AWS Elastic Disaster Recovery	 Yes
Amazon Elastic File System (Amazon EFS)	 Partial
Amazon Elastic Inference	 No
Amazon Elastic Kubernetes Service (Amazon EKS)	 Yes
Amazon Elastic Kubernetes Service (Amazon EKS) Auth	 No
AWS Elastic Load Balancing	 Partial
Amazon Elastic Transcoder	 No
AWS Elemental Appliances and Software Activation Service	 Yes
AWS Elemental Appliances and Software	 Yes
AWS Elemental MediaConnect	 No
AWS Elemental MediaConvert	 Yes
AWS Elemental MediaLive	 Yes
AWS Elemental MediaPackage	 Yes
AWS Elemental MediaPackage V2	 Yes
AWS Elemental MediaPackage VOD	 Yes
AWS Elemental MediaStore	 Yes
AWS Elemental MediaTailor	 Yes
AWS Elemental Support Cases	 No
AWS Elemental Support Content	 No
Amazon EMR	 Yes
Amazon EMR on EKS	 Yes
Amazon EMR Serverless	 Yes
AWS Entity Resolution	 Yes
Amazon EventBridge	 Yes
Amazon EventBridge Pipes	 Yes
Amazon EventBridge Scheduler	 Yes
Amazon EventBridge Schemas	 Yes
AWS Fault Injection Service	 Yes
Amazon FinSpace	 Yes
Amazon FinSpace API	 No
AWS Firewall Manager	 Yes
Fleet Hub for AWS IoT Device Management	 Yes
Amazon Forecast	 Yes
Amazon Fraud Detector	 Yes
FreeRTOS	 Yes
AWS Free Tier	 No
Amazon FSx	 Yes
Amazon GameLift	 Yes
AWS Global Accelerator	 Yes
AWS Glue	 Partial
AWS Glue DataBrew	 Yes
AWS Ground Station	 Yes
Amazon Ground Truth Labeling	 No
Amazon GuardDuty	 Yes
AWS Health APIs And Notifications	 No
AWS HealthImaging	 Yes
AWS HealthLake	 Yes
AWS HealthOmics	 Yes
AWS IAM Identity Center	 Partial
IAM Identity Center Directory	 No
IAM Identity Center Identity Store	 No
IAM Identity Center OIDC service	 No
AWS Identity and Access Management (IAM)	 Partial (Info)
AWS Identity and Access Management Access Analyzer	 Yes
AWS Identity and Access Management Roles Anywhere	 Yes
AWS Identity Store Auth	 No
AWS Identity Sync	 No
AWS Import/Export	 No
Amazon Inspector	 Yes
Amazon Inspector Classic	 No
Amazon InspectorScan	 No
Amazon Interactive Video Service	 Yes
Amazon Interactive Video Service Chat	 Yes
AWS Invoicing	 No
AWS IoT 1-Click	 Yes
AWS IoT Analytics	 Yes
AWS IoT	 Yes
AWS IoT Core Device Advisor	 Yes
AWS IoT Device Tester	 No
AWS IoT Events	 Yes
AWS IoT FleetWise	 Yes
AWS IoT Greengrass	 Yes
AWS IoT Greengrass V2	 Partial
AWS IoT Jobs DataPlane	 No
AWS IoT RoboRunner	 No
AWS IoT SiteWise	 Yes
AWS IoT TwinMaker	 Yes
AWS IoT Wireless	 Yes
AWS IQ	 No
AWS IQ Permissions	 No
Amazon Kendra	 Yes
Amazon Kendra Intelligent Ranking	 Yes
AWS Key Management Service (AWS KMS)	 Yes
Amazon Keyspaces (for Apache Cassandra)	 Yes
Amazon Managed Service for Apache Flink	 Yes
Amazon Managed Service for Apache Flink V2	 Yes
Amazon Data Firehose	 Yes
Amazon Kinesis Data Streams	 No
Amazon Kinesis Video Streams	 Yes
AWS Lake Formation	 No
AWS Lambda	 Partial (Info)
AWS Launch Wizard	 No
Amazon Lex	 Yes
Amazon Lex V2	 Yes
AWS License Manager	 Yes
AWS License Manager Linux Subscriptions Manager	 No
AWS License Manager User Subscriptions	 No
Amazon Lightsail	 Partial (Info)
Amazon Location Service	 Yes
Amazon Lookout for Equipment	 Yes
Amazon Lookout for Metrics	 Yes
Amazon Lookout for Vision	 Yes
Amazon Machine Learning	 No
Amazon Macie	 Yes
AWS Mainframe Modernization	 Yes
AWS Mainframe Modernization Application  Testing	 Yes
Amazon Managed Blockchain	 Yes
Amazon Managed Blockchain Query	 No
Amazon Managed Grafana	 Yes
Amazon Managed Service for Prometheus	 Yes
Amazon Managed Streaming for Apache Kafka (MSK)	 Yes
Amazon Managed Streaming for Kafka Connect	 No
Amazon Managed Workflows for Apache Airflow	 Yes
AWS Marketplace	 No
AWS Marketplace Catalog	 Yes
AWS Marketplace Commerce Analytics	 No
AWS Marketplace Deployment Service	 Yes
AWS Marketplace Discovery	 No
AWS Marketplace Entitlement Service	 No
AWS Marketplace Image Building Service	 No
AWS Marketplace Management Portal	 No
AWS Marketplace Metering Service	 No
AWS Marketplace Private Marketplace	 No
AWS Marketplace Procurement Systems Integration	 No
AWS Marketplace Seller Reporting	 No
AWS Marketplace Vendor Insights	 Yes
Amazon Mechanical Turk	 No
Amazon MediaImport	 No
Amazon MemoryDB	 Yes
Amazon Message Delivery Service	 No
Amazon Message Gateway Service	 No
AWS Microservice Extractor for .NET	 No
AWS Migration Acceleration Program Credits	 No
AWS Migration Hub	 No
AWS Migration Hub                Orchestrator	 Yes
AWS Migration Hub Refactor Spaces	 Yes
AWS Migration Hub                Strategy Recommendations	 No
Amazon Monitron	 Yes
Amazon MQ	 Yes
Amazon Neptune	 No
Amazon Neptune Analytics	 Yes
AWS Network Firewall	 Yes
AWS Network Manager	 Yes
AWS Network Manager Chat	 No
Amazon Nimble Studio	 Yes
Amazon One Enterprise	 Yes
Amazon OpenSearch A313  Ingestion	 Yes
Amazon OpenSearch Serverless	 Yes
Amazon OpenSearch Service	 Yes
AWS OpsWorks	 No
AWS OpsWorks Configuration Management	 No
AWS Organizations	 Yes
AWS Outposts	 Yes
AWS Panorama	 Yes
AWS Partner Central account management	 No
AWS Payment Cryptography	 Yes
AWS Payments	 No
AWS Performance Insights	 No
Amazon Personalize	 No
Amazon Pinpoint	 Yes
Amazon Pinpoint Email Service	 Yes
Amazon Pinpoint SMS and Voice Service	 No
Amazon Pinpoint SMS and Voice Service V2	 Yes
Amazon Polly	 No
AWS Price List	 No
AWS Private 5G	 Yes
AWS Private CA Connector for Active Directory	 Yes
AWS Private CA Connector for SCEP	 Yes
AWS Private Certificate Authority (AWS Private CA)	 Yes
AWS Proton	 Yes
AWS Purchase Orders Console	 Yes
Amazon Q Business	 Yes
Amazon Q Business Q Apps	 No
Amazon Q Developer	 No
Amazon Q  in Connect	 Yes
Amazon Quantum Ledger Database (Amazon QLDB)	 Yes
Amazon QuickSight	 Yes
Amazon RDS Data API	 No
Amazon RDS IAM Authentication	 No
AWS Recycle Bin	 Yes
Amazon Redshift	 Yes
Amazon Redshift Data API	 No
Amazon Redshift Serverless	 Yes
Amazon Rekognition	 Yes
Amazon Relational Database Service (Amazon RDS) (Info)	 Yes
AWS re:Post Private	 Yes
AWS Resilience Hub	 Yes
AWS Resource Access Manager (AWS RAM)	 Yes
AWS Resource Explorer	 Yes
AWS Resource Groups	 Yes
AWS Resource Groups Tagging API	 No
Amazon RHEL Knowledgebase Portal	 No
AWS RoboMaker	 Yes
Amazon Route 53	 No
Amazon Route 53 Application Recovery Controller - Zonal Shift	 No
Amazon Route 53 Domains	 No
Amazon Route 53 Profiles	 Yes
Amazon Route 53 Recovery Cluster	 No
Amazon Route 53 Recovery Control Config	 Yes
Amazon Route 53 Recovery Readiness	 Yes
Amazon Route 53 Resolver	 Yes
Amazon S3 Express	 No
Amazon S3 Glacier	 Yes
Amazon SageMaker	 Yes
Amazon SageMaker geospatial capabilities	 Yes
Amazon SageMaker Ground Truth Synthetic	 No
Amazon SageMaker with MLflow	 No
AWS Savings Plans	 Yes
AWS Secrets Manager	 Yes
AWS Security Hub	 Yes
Amazon Security Lake	 No
AWS Security Token Service (AWS STS)	 Yes
AWS Serverless Application Repository	 No
AWS Service Catalog	 Yes
Service Quotas	 Yes
AWS Shield	 Yes
AWS Signer	 Yes
AWS Signin	 No
Amazon SimpleDB	 No
Amazon Simple Email Service ‐ Mail Manager	 Yes
Amazon Simple Email Service (Amazon SES) v2	 Yes
Amazon Simple Notification Service (Amazon SNS)	 Yes
Amazon Simple Queue Service (Amazon SQS)	 Partial
Amazon Simple Storage Service (Amazon S3)	 Partial (Info)
Amazon Simple Storage Service (Amazon S3) Object Lambda	 No
Amazon Simple Storage Service (Amazon S3) on AWS Outposts	 No
Amazon Simple Workflow Service (Amazon SWF)	 Yes
AWS SimSpace Weaver	 Yes
AWS Site-to-Site VPN	 No
AWS Snowball	 No
AWS Snowball Edge	 No
AWS Snow Device Management	 Yes
AWS SQL Workbench	 Yes
AWS Step Functions	 Yes
AWS Storage Gateway	 Yes
AWS Supply Chain	 Yes
AWS Support App in Slack	 No
AWS Support	 No
AWS Support Plans	 No
AWS Support Recommendations	 No
AWS Sustainability	 No
AWS Systems Manager	 Yes
AWS Systems Manager for SAP	 Yes
AWS Systems Manager GUI Connect	 No
AWS Systems Manager Incident Manager	 Yes
AWS Systems Manager Incident Manager Contacts	 No
AWS Systems Manager Quick Setup	 Yes
Tag Editor	 No
AWS Tax Settings	 No
AWS Telco Network Builder	 Yes
Amazon Textract	 No
Amazon Timestream	 Yes
Amazon Timestream Influxdb	 Yes
AWS Tiros API (for Reachability Analyzer)	 No
Amazon Transcribe	 Yes
AWS Transfer Family	 Yes
Amazon Translate	 Yes
AWS Trusted Advisor	 No
AWS User Notifications	 Yes
AWS User Notifications Contacts	 Yes
AWS User Subscriptions	 No
AWS Verified Access	 No
Amazon Verified Permissions	 No
Amazon Virtual Private Cloud (Amazon VPC)	 Yes
Amazon VPC Lattice	 Yes
Amazon VPC Lattice Services	 No
AWS WAF	 Yes
AWS WAF  Classic	 Yes
AWS WAF  Regional	 Yes
AWS Well-Architected Tool	 Yes
AWS Wickr	 Yes
Amazon WorkDocs	 No
Amazon WorkMail	 Yes
Amazon WorkMail Message Flow	 No
Amazon WorkSpaces	 Yes
Amazon WorkSpaces Secure Browser	 Yes
Amazon WorkSpaces Thin Client	 Yes
AWS X-Ray	 Partial (Info)
![image](https://github.com/user-attachments/assets/1a7c2521-ceda-4996-a135-757f28977754)

</div>

## 5.0 Requirements
| Name | Version |
|------|---------|
| [Terraform](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_terraform) | >= 1.0|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |

## 5.0 Providers
| Name | Version |
|------|---------|
| [aws](https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/README.md#requirement_aws) | 5.58.0 |

## Useful links

### Terraform Registry
- [Data Source: aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)

- [Resource: aws_ssoadmin_instance_access_control_attributes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_instance_access_control_attributes)


### AWS User Guides & Tutorials
- [IAM tutorial: Define permissions to access AWS resources based on tags](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_attribute-based-access-control.html)

- [Permission sets](https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html)

- [Managed policies and inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)

- [IAM JSON policy elements: Condition](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition.html)

- [AWS global condition context keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html#condition-keys-principaltag)

- [Determining whether a request is allowed or denied within an account](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html#policy-eval-denyallow)

- [Define permissions based on attributes with ABAC authorization](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html)

- [AWS global condition context keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html)

- [AWS services that work with IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html)

- [Attributes for access control](https://docs.aws.amazon.com/singlesignon/latest/userguide/attributesforaccesscontrol.html)

- [Checklist: Configuring ABAC in AWS using IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/abac-checklist.html)

- [Enable and configure attributes for access control](https://docs.aws.amazon.com/singlesignon/latest/userguide/configure-abac.html)

- [Attribute mappings for AWS Managed Microsoft AD directory](https://docs.aws.amazon.com/singlesignon/latest/userguide/attributemappingsconcept.html#defaultattributemappings)

- [Create permission policies for ABAC in IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/configure-abac-policies.html)

### AWS Knowledge Center
- [How do I use the PrincipalTag, ResourceTag, RequestTag, and TagKeys condition keys to create an IAM policy for tag-based restriction?](https://repost.aws/knowledge-center/iam-tag-based-restriction-policies)

### Other websites
- [The state of ABAC on AWS (in 2024)](https://ramimac.me/abac)
