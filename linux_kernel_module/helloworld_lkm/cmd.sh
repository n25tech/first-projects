#!/bin/bash

create_debian_vm() {
	arch="amd64"
	arch="arm64"
	wget "https://cdimage.debian.org/debian-cd/current/${arch}/iso-dvd/debian-13.6.0-${arch}-DVD-1.iso"
	#wget https://cdimage.debian.org/debian-cd/current/arm64/iso-dvd/debian-13.6.0-arm64-DVD-1.iso
	qemu-img create -f qcow2 debian-vm.qcow2 20G
	iso_image="debian-13.6.0-${arch}-DVD-1.iso"
	qemu-system-x86_64 \
	  -enable-kvm \
	  -cpu host \
	  -smp 4 \
	  -m 4G \
	  -drive file=debian-vm.qcow2,format=qcow2 \
	  -cdrom $iso_image \
	  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
	  -device virtio-net-pci,netdev=net0 \
	  -display gtk

	echo 'update apt sources:'
	echo 'vi /etc/apt/sources.list'
	echo -e 'deb http://deb.debian.org/debian trixie main\ndeb http://security.debian.org/debian-security trixie-security main\ndeb http://deb.debian.org/debian trixie-updates main' 
	echo 'please note: ping does not work in -netdev user by default'
}

run_vm() {
	qemu-system-x86_64 \
	  -enable-kvm \
	  -cpu host \
	  -smp 4 \
	  -m 4G \
	  -drive file=debian-vm.qcow2,format=qcow2 \
	  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
	  -device virtio-net-pci,netdev=net0 \
	  -nographic
}

sync_files() {
	fswatch -o . | xargs -I{} rsync -avz --exclude='.git' --exclude='*.iso' --exclude="*.qcow2" ./ debian-vm:~/
}

print_help() {
	echo "specify one of create_debian_vm or run_vm"
}

case $1 in
	create*)
		create_debian_vm
		;;
	run*)
		run_vm
		;;
	sync*)
		sync_files
		;;
	*)
		print_help
		;;

esac
