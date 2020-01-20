data "archive_file" "compress" {
  type        = "zip"
  output_path = "${path.module}/temp.zip"

  source {
    filename = var.filename
    content  = var.content
  }
}

data "local_file" "compress" {
  filename = data.archive_file.compress.output_path
}

resource "local_file" "userdata" {
  filename = "userdata.txt"
  content  = <<TEMP
#!/bin/bash
userdata_zip=$(cat <<EOF
${data.local_file.compress.content_base64}
EOF
)

echo $userdata_zip | base64 -d > temp.zip
unzip temp.zip
${var.shell} ${var.filename}
TEMP
}
