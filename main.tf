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
  filename = "${path.module}/userdata.txt"
  content  = <<TEMP
#!/bin/bash
if ! $(command -v unzip); then
  if $(command -v apt-get); then
    sudo apt-get update -y
    sudo apt-get install -y unzip
  elif $(command -v yum); then
    sudo yum update -y
    sudo yum install -y unzip
  else
    echo "Could not find apt-get or yum"
    exit 1
  fi
fi
userdata_zip=$(cat <<EOF
${data.local_file.compress.content_base64}
EOF
)

echo $userdata_zip | base64 -d > temp.zip
unzip temp.zip
${var.shell} ${var.filename}
TEMP
}

