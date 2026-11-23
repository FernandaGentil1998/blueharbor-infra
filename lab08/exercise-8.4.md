
# Exercise 8.4 — Use Cloud Object Storage

## Objective

Explore cloud object storage using Supabase Storage, including buckets, access control, signed URLs, and S3-compatible API access.

## 1. Bucket Configuration

Created two storage buckets in the Supabase project:

| Bucket | Intended access | Purpose |
|---|---|---|
| `assets` | Public | Store files intended for public access |
| `backups` | Private | Store files that require controlled access |

Uploaded a test image to `assets` and opened its URL successfully in a private browser window.

Uploaded `hello.txt.txt` to `backups`.

## 2. Signed URLs

Generated a signed URL for `backups/hello.txt.txt`.

The URL used the Supabase signed-object endpoint:

`/storage/v1/object/sign/`

The minimum expiration available in the dashboard was one day (86,400 seconds), rather than the 60 seconds specified in the workbook.

Signed URLs provide temporary access to private objects without making the bucket public.

**Security note:** Signed URLs contain bearer tokens and must not be committed to Git or shared publicly.

## 3. S3-Compatible API Configuration

Enabled the S3 protocol connection in Supabase Storage.

Created an access key for the WEB01 client and configured AWS CLI using a dedicated profile named `supabase`.

Installed AWS CLI v2 on WEB01:

```bash
sudo snap install aws-cli --classic
```

Configured the profile:

```bash
aws configure --profile supabase
```

Configured the S3 endpoint:

```bash
export S3EP='https://ptbtescajqyqoiogjuei.storage.supabase.co/storage/v1/s3'
```

The region and credentials were configured locally and were not included in this repository.

## 4. S3 Connectivity Test

Executed the following command on WEB01:

```bash
aws s3 ls --profile supabase --endpoint-url "$S3EP"
```

The command successfully listed both buckets:

- `assets`
- `backups`

This confirmed that AWS CLI could authenticate and communicate with Supabase Storage through its S3-compatible endpoint.

## 5. Upload Test from WEB01

Created a local test file:

```bash
echo "hello from web01" > /tmp/web01.txt
```

Uploaded it to the private `backups` bucket:

```bash
aws s3 cp /tmp/web01.txt s3://backups/test/web01.txt \
  --profile supabase \
  --endpoint-url "$S3EP"
```

Verified the uploaded object:

```bash
aws s3 ls s3://backups/test/ \
  --profile supabase \
  --endpoint-url "$S3EP"
```

Output:

```text
2026-11-23 11:07:40         17 web01.txt
```

The upload and listing operations completed successfully.

## 6. Why Private Storage Matters for Backups

Backups may contain sensitive information, configuration files, or data required for disaster recovery.

Keeping backup buckets private prevents anonymous public access. Access should be granted only to authorized users and services through controlled credentials or temporary signed URLs.

This reduces the risk of accidental data exposure.

## 7. Comparison with Hyperscaler Object Storage

Supabase Storage provides bucket-based object storage and S3-compatible access, making it possible to use tools such as AWS CLI.

The exercise demonstrated:

- Bucket creation and organization.
- Public and private access concepts.
- Signed URLs for temporary access.
- S3-compatible authentication and object operations.

Compared with hyperscaler services such as Amazon S3, the Supabase Free plan has more limited storage-management capabilities. Features such as storage classes, lifecycle management, and object versioning are not available in the same way as in a full hyperscaler object-storage service.

The Free plan also has a limited storage quota (approximately 1 GB, according to the workbook).

## 8. Results

- [x] Created `assets` and `backups` buckets.
- [x] Uploaded a file to `assets` and tested its URL.
- [x] Generated a signed URL for an object in `backups`.
- [x] Enabled S3 protocol access.
- [x] Created S3 access credentials.
- [x] Installed AWS CLI on WEB01.
- [x] Listed Supabase buckets through the S3 API.
- [x] Uploaded `web01.txt` from WEB01 to `backups`.
- [x] Verified the uploaded object.
