# Lambda Functions
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "clock_in" {
  function_name = "clock_in"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = data.archive_file.clock_in.output_path
  source_code_hash = data.archive_file.clock_in.output_base64sha256
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.events.name
    }
  }
}

resource "aws_lambda_function" "clock_out" {
  function_name = "clock_out"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = data.archive_file.clock_out.output_path
  source_code_hash = data.archive_file.clock_out.output_base64sha256
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.events.name
    }
  }
}

resource "aws_lambda_function" "break_toggle" {
  function_name = "break_toggle"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = data.archive_file.break_toggle.output_path
  source_code_hash = data.archive_file.break_toggle.output_base64sha256
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.events.name
    }
  }
}

data "archive_file" "clock_in" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/clock_in"
  output_path = "${path.module}/clock_in.zip"
}

data "archive_file" "clock_out" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/clock_out"
  output_path = "${path.module}/clock_out.zip"
}

data "archive_file" "break_toggle" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/break_toggle"
  output_path = "${path.module}/break_toggle.zip"
}

# DynamoDB Table for events
resource "aws_dynamodb_table" "events" {
  name         = "work_events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"
  attribute {
    name = "PK"
    type = "S"
  }
  attribute {
    name = "SK"
    type = "S"
  }
}

# API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = "work-tracker-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "clock_in" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.clock_in.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "clock_out" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.clock_out.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "break_toggle" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.break_toggle.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "clock_in" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /clock_in"
  target    = "integrations/${aws_apigatewayv2_integration.clock_in.id}"
}

resource "aws_apigatewayv2_route" "clock_out" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /clock_out"
  target    = "integrations/${aws_apigatewayv2_integration.clock_out.id}"
}

resource "aws_apigatewayv2_route" "break_toggle" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /break_toggle"
  target    = "integrations/${aws_apigatewayv2_integration.break_toggle.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw_clock_in" {
  statement_id  = "AllowAPIGatewayInvokeClockIn"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.clock_in.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_clock_out" {
  statement_id  = "AllowAPIGatewayInvokeClockOut"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.clock_out.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_break_toggle" {
  statement_id  = "AllowAPIGatewayInvokeBreakToggle"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.break_toggle.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
