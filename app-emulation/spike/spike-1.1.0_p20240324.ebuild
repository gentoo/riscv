# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The RISC-V ISA Simulator"
HOMEPAGE="https://github.com/riscv-software-src/riscv-isa-sim"

LICENSE="BSD"
SLOT="0/${PV}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/riscv-software-src/riscv-isa-sim.git"
else
	MY_COMMIT=3427b459f88d2334368a1abbdf5a3000957f08e8
	if [[ -v MY_COMMIT ]]; then
		SRC_URI="https://github.com/riscv-software-src/riscv-isa-sim/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/riscv-isa-sim-${MY_COMMIT}"
	else
		SRC_URI="https://github.com/riscv/riscv-isa-sim/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
	KEYWORDS="~amd64"
fi

DEPEND="sys-apps/dtc"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e "/install_libs_dir/s:/lib:/$(get_libdir)/spike:g" \
		Makefile.in || die
}
