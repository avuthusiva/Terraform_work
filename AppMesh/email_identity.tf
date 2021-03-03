resource "aws_ses_email_identity" "source" {
  email = "asvr410@gmail.com"
}

resource "aws_ses_email_identity" "destination" {
  email = "sivaavuthu@gmail.com"
}
