# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="U-boot binary firmware which can be used by qemu as bios"
HOMEPAGE="https://www.denx.de/project/u-boot/"
SRC_URI="https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
