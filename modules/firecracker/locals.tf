locals {
  kernel_version = "6.1.155"

  kernel = lookup({
    hello = "hello"
  }, var.os, local.kernel_version)
}