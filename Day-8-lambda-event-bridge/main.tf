//Creating a bucket
resource "aws_s3_bucket" "name" {
  bucket = "dhsldkfslsfkjdslfj"
}

resource "aws_s3_object" "code" {
  bucket = aws_s3_bucket.name.id
  key = "lambda/dharma.zip"
  source = "dharma.zip"
}

resource "aws_lambda_function" "name" {
  function_name = "Dfunction"
  role = aws_iam_role.lambdarole.arn
  runtime = "python3.10"
  handler = "dharma.lambda_handler"
  timeout = 900
  memory_size = 128
  s3_bucket = aws_s3_bucket.name.id
  s3_key = aws_s3_object.code.key
  # s3_object_version = aws_s3_object.lambda_zip.version_id--> used like hash for s3
  # filename = "dharma.zip"
  # source_code_hash = filebase64sha256("dharma.zip")
}


//Defining a simple role with allow action for lambda
resource "aws_iam_role" "lambdarole" {
  name = "DLambdaBasicRole"
  assume_role_policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "sts:AssumeRole"
                ],
                "Principal": {
                    "Service": [
                        "lambda.amazonaws.com"
                    ]
                }
            }
        ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "name" {
  role = aws_iam_role.lambdarole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}