output "eip" {
    value = aws_eip.my_eip.public_ip
}

output "mys3bucketdomainnanme" {
    value = aws_s3_bucket.my_bucket.bucket_domain_name
}