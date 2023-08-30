# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
inherit autotools git-r3 multilib

DESCRIPTION="The RISC-V ISA Simulator"
HOMEPAGE="https://github.com/riscv/riscv-isa-sim/"
EGIT_REPO_URI="https://github.com/riscv-software-src/riscv-isa-sim"

LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""

DEPEND=""

src_prepare() {
	default
	sed -i -e "/install_libs_dir/s:/lib:/$(get_libdir):g" Makefile.in || die
	eautoreconf
}
