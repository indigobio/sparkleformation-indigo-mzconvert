## sparkleformation-indigo-mzconvert
This repository contains a SparkleFormation template that creates an 
auto scaling group of MZConvert EC2 instances.

Additionally, the template creates a private Route53 (DNS) CNAME record:
mzconvert.`ENV['private_domain']`.

### Dependencies

The template requires external Sparkle Pack gems, which are noted in
the Gemfile and the .sfn file.  These gems interact with AWS through the
`aws-sdk-core` gem to identify or create  availability zones, subnets, and 
security groups.

### Parameters

When launching the compiled CloudFormation template, you will be prompted for
some stack parameters:

| Parameter | Default Value | Purpose |
|-----------|---------------|---------|
| ChefRunlist | role[base],role[mzconvert] | No need to change |
| ChefServer | https://api.opscode.com/organizations/product\_dev | No need to change |
| ChefValidationClientName | product\_dev-validator | No need to change |
| ChefVersion | 12.4.0 | No need to change |
| MzconvertAssociatePublicIpAddress | false | No need to change |
| MzconvertDeleteEbsVolumesOnTermination | true | Set to false if you want the EBS volumes to persist when the instance is terminated |
| MzconvertDesiredCapacity | 1 | No need to change |
| MzconvertEbsOptimized| false | Enable EBS optimization for the instance (instance type must be an m3, m4, c3 or c4 type; maybe others) |
| MzconvertEbsProvisionedIops| 300 | Number of provisioned IOPS to request for io1 EBS volumes |
| MzconvertEbsVolumeSize | 10 | Size (in GB) of additional EBS volumes |
| MzconvertEbsVolumeType | gp2 | EBS volume type (gp2, or general purpose, or io1, provisioned IOPS).  Provisioned IOPS volumes incur additional expense. |
| MzconvertInstanceMonitoring | false | Set to true to enable detailed cloudwatch monitoring (additional costs incurred) |
| MzconvertInstanceType | t2.small | Increase the instance size for more network throughput |
| MzconvertMaxSize | 1 | No need to change |
| MzconvertMinSize | 0 | No need to change |
| MzconvertNotificationTopic | auto-determined | No need to change |
| RootVolumeSize | 12 | No need to change |
| SshKeyPair | indigo-bootstrap | No need to change |
