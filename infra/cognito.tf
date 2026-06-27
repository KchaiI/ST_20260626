resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = false
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = "ON"

  email_mfa_configuration {
    message = "認証コード：{####}"
    subject = "ログイン認証コード"
  }

  software_token_mfa_configuration {
    enabled = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "メールアドレス確認"
    email_message        = "確認コード：{####}"
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address    = var.ses_from_email
    source_arn            = var.ses_source_arn
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
  ]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 60
}