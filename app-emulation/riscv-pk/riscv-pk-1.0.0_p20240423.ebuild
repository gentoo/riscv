# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="RISC-V Proxy Kernel"
HOMEPAGE="https://github.com/riscv-software-src/riscv-pk"

LICENSE="BSD"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/riscv-software-src/riscv-pk.git"
else
	MY_COMMIT=9637e60b96b21a7f85a85bf033b87f64fb823b6c
	if [[ -v MY_COMMIT ]]; then
		SRC_URI="https://github.com/riscv-software-src/riscv-pk/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/riscv-pk-${MY_COMMIT}"
	else
		SRC_URI="https://github.com/riscv-software-src/riscv-pk/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
	KEYWORDS="~amd64"
fi

pkg_setup() {
	if ! has_version cross-riscv64-linux-gnu/gcc && [[ ! -v I_HAVE_RISCV_LINUX_GNU_GCC ]]; then
		die "Building the RISC-V Proxy Kernel (pk) requires cross-riscv64-linux-gnu/gcc"
	fi
}

src_prepare() {
	default

	# TODO: consider using filter-flags instead.
	unset CFLAGS CXXFLAGS
}

src_configure() {
	mkdir build || die
	cd build || die

	../configure --prefix="${EPREFIX}"/usr/share --host=riscv64-linux-gnu || die
}

src_compile() {
	emake -C build
}

src_install() {
	emake -C build DESTDIR="${D}" install
}
