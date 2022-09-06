# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git"
inherit git-r3 linux-info

DESCRIPTION="A lightweight tool for hosting KVM guests"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="riscv? ( sys-apps/dtc )"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

function ctarget() {
	CTARGET="${ARCH}"
	use amd64 && CTARGET='x86_64'
	echo $CTARGET
}

CONFIG_CHECK="
	SERIAL_8250 SERIAL_8250_CONSOLE
	VIRTIO VIRTIO_PCI
	VIRTIO_RING VIRTIO_PCI
	VIRTIO_BLK VIRTIO_NET
	~VIRTIO_BALLOON
	~VIRTIO_CONSOLE
	~HW_RANDOM_VIRTIO
	~FB_VESA
"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is lt 2 6 25; then
			eerror "This version of KVM requires a host kernel of 2.6.25 or higher."
		fi
		if use riscv && kernel_is lt 5 16; then
			ewarn "RISC-V KVM official support landed in kernel 5.16,"
			ewarn "and requires the hypervisor extension."
		fi

		if ! linux_config_exists; then
			eerror "Unable to check your kernel for KVM support"
		else
			check_extra_config
		fi
	fi
}

src_prepare() {
	default
	sed -e 's/^CFLAGS\t:=/CFLAGS := $(CFLAGS)/' \
		-e 's/^LDFLAGS\t:=/LDFLAGS := $(LDFLAGS)/' -i Makefile
}

src_compile() {
	V=1 ARCH=$(ctarget) emake
}

src_install() {
	dobin lkvm vm || die
	dodoc README Documentation/virtio-console.txt || die
	doman Documentation/${PN}.1
}
