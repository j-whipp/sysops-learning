

# get the profile credential and sets it as the default profile in the current session, from here on out all operations will leverage these credentials unless superceded
$ProfileName = '{{profile_name}}'
$BucketName = (Get-S3Bucket).BucketName # I only have 1 bucket in my test acct so I do it this way, generally you'd supply the string value
Get-AWSCredential -ProfileName $ProfileName | Set-AWScredential

# construct the parameters we need to pass to Get-S3Object
# left some common params commented out, play around with these as you get more comfortable
$GetParams = @{
    BucketName      = $BucketName
    RequestPayer    = 'requester' # string value that does nothing more than act as a confirmation boolean for the API, MUST be 'requester' https://github.com/aws/aws-sdk-go-v2/blob/service/s3/v1.5.0/service/s3/types/enums.go#L931
    #Key             = 'objectKey'
    #Prefix          = 'photos' # more info on object prefixes, basically "pseudo-directories" for organizing objects in buckets https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-prefixes.html
}

# Now call the ListObjects API operation using Get-S3Object which returns up to 1,000 objects from the bucket https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectsV2.html
# Each returned object contains a Key value which is a unique identifier for an object, think filename in this case
$BucketObjects = Get-S3Object @GetParams

# Now write each file(object) using Read-S3Object
$BucketObjects.ForEach{$_ | Read-S3Object -File $_.Key -Folder "$env:USERPROFILE\temp"}

