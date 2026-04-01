//Creating a bucket to have the code 
resource "aws_s3_bucket" "name" {
  bucket = "dhsldkfslsfkjdslfj"
}

//create object inside s3 bucket
resource "aws_s3_object" "code" {
  bucket = aws_s3_bucket.name.id
  key = "lambda/dharma.zip"
  source = "dharma.zip"
}

//create a lambda function 
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

//attach the lambda basic execution policy to the created role
resource "aws_iam_role_policy_attachment" "name" {
  role = aws_iam_role.lambdarole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

//For Event bridge

//1) create an event bridge and schedule
resource "aws_scheduler_schedule" "lambda_timer" {
  schedule_expression = "cron(0/5 * * * ? *)"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = aws_lambda_function.name.arn
    role_arn = aws_iam_role.event_bridge_role.arn
  }
}
//2) create a role for event bridge to access lambda

resource "aws_iam_role" "event_bridge_role" {
  name = "scheduler_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "scheduler.amazonaws.com"
                ]
            }
        }
    ]
  })
}
//3) Create a custom policy for event_bridge
resource "aws_iam_policy" "scheduler_policy" {
  name = "TDinvoke-lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "lambda:InvokeFunction",
      Resource = aws_lambda_function.name.arn
    }]
  })
}

//4) attach the policy to the role
resource "aws_iam_role_policy_attachment" "event_role_att" {
  role = aws_iam_role.event_bridge_role.name
  policy_arn = aws_iam_policy.scheduler_policy.arn
}