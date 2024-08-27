resource "aws_s3_bucket" "lb" {
  bucket = "myapp-bucket-813298391823"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "lb" {
  bucket = aws_s3_bucket.lb.bucket
  policy = data.aws_iam_policy_document.lb.json
}

data "aws_iam_policy_document" "lb" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::600734575887:root"]
    }
    
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.lb.arn}/*"
    ]
  }
}
