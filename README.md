# book-domain
POC to create simple service to book domains and hosting content on AWS S3

## Shortcuts and considerations
Because it's only POC I cut off some less important parts and simplify others:

 * Dirty modules api, I use full object (outputs from resoures) to comunicate between modules, this is convinient during writing but it can be confusing, generated documentation is less detailed and it's much harder to validate modules inputs.
 * Missing some base configuration like logging feature for CloudFront or versioning for S3, there is no also no tag in any resoures. 
 * API between Storage and Web Pages Privider is in both direction, this smells, maybe separation should be a litte different.
