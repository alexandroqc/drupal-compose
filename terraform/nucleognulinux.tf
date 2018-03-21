variable "digitalocean_token" {}

variable "servers_count" {
	description = "Cantidad de servidores."
}

provider "digitalocean" {
	token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "nucleo" {
	name = "nucleo"
	public_key = "${file("../nucleognulinux.org.pub")}"
#	public_key = "${file("/home/alexandro/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "web" {
	image = "debian-9-x64"
	name = "${format("nucleognulinux-%02d", count.index)}"
	region = "nyc3"
	size = "s-1vcpu-1gb"
	ssh_keys = ["${digitalocean_ssh_key.nucleo.id}"]
	count = "${var.servers_count}"
}
