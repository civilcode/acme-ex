# S3 Setup Guide

## For applications

In order to connect to a AWS Service, an application requires a key and a secret, and permissions.  First create an IAM user for the application:

1. Click on the account name at the top right
2. Select `Security Credentials`
3. In the left sidebar, click on `Users`
4. Create a new user.  Use a name such as `my-bucket`.  Make sure an access key gets generated for each user.
5. Download (or copy) the credentials.  This is the only time where you can see the access key and secret, so don't skip this step, otherwise you'll have to delete the access key and create a new one.

For each user, we now need to assign permissions.

1. Click on a user
2. In the tab `Permissions`, click on `Inline Policies`, and then on `Click Here`.
3. Click on `Select` to use the Policy Generator
4. Select Amazon S3 as the AWS service
5. Select these permissions: `ListObjects, GetObject, GetObjectAcl, GetObjectTagging, GetObjectTorrent, GetObjectVersion, GetObjectVersionAcl, GetObjectVersionForReplication, GetObjectVersionTagging, GetObjectVersionTorrent, ListMultipartUploadParts, AbortMultipartUpload, PutObject, PutObjectTagging, PutObjectVersionTagging, PutObjectAcl, PutObjectVersionAcl, ObjectOwnerOverrideToBucketOwner`
6. Use this ARN (replace BUCKETNAME with the proper bucket name): `arn:aws:s3:::BUCKETNAME/*`
7. Click on `Add Statement`
8. Click on `Next Step`
9. Review the policy and validate it.
10. Then apply it.  It should look like this:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1459884741000",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::my-bucket/*"
            ]
        }
    ]
}
```

### CORS policy

For the buckets, we need to add a CORS policy:

1. In the top navigation, click on `Services` and select `S3`
2. Click on one of the buckets
3. Click on the `Properties` tab
4. Expand `Permissions`
5. Click on `Add CORS policy`:

```
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>Authorization</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

## For humans

For giving access to the AWS console to manage the buckets and other AWS services, you first need to create an IAM user:

1. Click on the account name at the top right
2. Select `Security Credentials`
3. In the left sidebar, click on `Users`
4. Create a new user.  Use an e-mail as the name.
5. Download (or copy) the credentials (access key and secret).  This is the only time where you can see the access key and secret, so don't skip this step, otherwise you'll have to delete the user and create a new one.  You might need the key and secret in some tools such as Transmit.
6. Back in the list, click on the new user name you just created.
7. In the `Security Credentials` tab, click on the `Manage Password` button.  Choose to automatically assign the password then apply the changes.  Take note of the password.
8. In the `Permissions` tab, click on the `Attach Policy` button, select `AdministratorAccess` and then click on `Attach Policy`.

That's it.  The new user can now access the AWS console here:  `https://123.signin.aws.amazon.com/console`
