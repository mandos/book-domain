# book-domain
POC to create simple service to book domains and hosting content on AWS S3

## Shortcuts and considerations
Because it's only POC I cut off some less important parts and simplify others:

 * To keep it simply, I created all resoures by myself, in production solution I would consider using modules from Hashicorp's Registry
 * Aliases TODO
 * With every change of Lambda's Python code, version is automatically increase, deploy and used for CloudFront, on production environment maybe deploying Lambda should be in separate process.
 * TTL for CloudFront is set to 0 to make manual tests easier
 * Dirty modules api, I use full object (outputs from resoures) to comunicate between modules, this is convinient during writing but it can be confusing, generated documentation is less detailed and it's much harder to validate modules inputs.
 * Missing some base configuration like logging feature for CloudFront or versioning for S3, there is also no tags in any resoures. 
 * API between Storage and Web Pages Privider is in both direction, this smells stange, maybe separation should be a litte different.
 * Lack of any test, only manual testing.
 * Not used Global Table feature of DynamoDB.
