resource "aws_lambda_function" "name" {
  function_name = "Dfunction"
  role = aws_iam_role.lambdarole.arn
  runtime = "python3.10"
  handler = "dharma.lambda_handler"
  timeout = 900
  memory_size = 128
  filename = "dharma.zip"
  source_code_hash = filebase64sha256("dharma.zip")
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