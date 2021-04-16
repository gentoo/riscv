# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit eutils autotools

DESCRIPTION="The RISC-V ISA Simulator"
HOMEPAGE="https://github.com/riscv/riscv-isa-sim/"
SRC_URI="https://github.com/riscv/riscv-isa-sim/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""

S="${WORKDIR}/riscv-isa-sim-${PV}"
src_prepare() {
	default
	sed -i -e "/install_libs_dir/s:/lib:/$(get_libdir):g" Makefile.in || die
	sed -i -e "/<string/a#include <stdexcept>" \
		fesvr/dtm.cc riscv/devices.h || die
	eautoreconf
}
