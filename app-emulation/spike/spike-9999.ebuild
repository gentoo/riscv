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
	SRC_URI="https://github.com/riscv-software-src/riscv-isa-sim/archive/${COMMIT}.tar.gz -> ${P}.gh.htar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi

DEPEND="sys-apps/dtc"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e "/install_libs_dir/s:/lib:/$(get_libdir)/spike:g" \
		Makefile.in || die
}
