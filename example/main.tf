module "compress" {
  source   = "../"
  filename = "userdata.sh"
  shell    = "bash"
  content = templatefile("${path.module}/userdata.tpl", {
    user = var.user,
    }
  )
}
