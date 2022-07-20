resource "aws_key_pair" "publickey" {
  key_name = "datnt-publickey"
  public_key = file("publickey")
}