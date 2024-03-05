resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "This is a test policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ec2:Describe*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      // allow elastic load balancing describe
      {
        "Action" : [
          "elasticloadbalancing:Describe*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      // allow cloud wathc, list, get and describe 
      {
        "Action" : [
          "cloudwatch:List*",
          "cloudwatch:Get*",
          "cloudwatch:Describe*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
