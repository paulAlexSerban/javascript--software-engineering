resource "aws_lambda_function" "hello_lambda" {
  function_name = var.function_name
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  role          = aws_iam_role.lambda_exec.arn
  s3_bucket     = "packages-lambda"
  s3_key        = "${var.function_name}/${var.function_sha256sum}.zip"
}
