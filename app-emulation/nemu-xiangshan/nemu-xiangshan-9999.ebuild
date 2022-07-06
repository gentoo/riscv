# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS='
		nemu-xiangshan mini config HOWTO

Note: nemu-xiangshan is configurable via mconf, like the linux kernel.
Without user config, this ebuild will target minimum riscv64
You are encouraged to configure it on your own. Here are a couple of ways:

1) USE="-savedconfig" and set/unset the remaining flags to obtain the features
you want, and possibly a lot more.

2) You can create your own configuration file by doing:

FEATURES="keepwork" USE="savedconfig -*" emerge nemu-xiangshan
cd /var/tmp/portage/app-emulation/nemu-xiangshan*/work/nemu-xiangshan*
make menuconfig

Now configure nemu-xiangshan as you want.  Finally save your config file:

cp config/.config /etc/portage/savedconfig/app-emulation/nemu-xiangshan-${PV}

where ${PV} is the current version.  You can then run emerge again with
your configuration by doing:

USE="savedconfig" emerge nemu-xiangshan
'

inherit savedconfig readme.gentoo-r1

DESCRIPTION="NJU EMUlator, a full system x86/mips32/riscv32/riscv64 emulator for teaching"
HOMEPAGE="https://github.com/OpenXiangShan/NEMU"

LICENSE="MulanPSL-2.0"
SLOT="0"
IUSE="savedconfig"

EGIT_REPO_URI="https://github.com/OpenXiangShan/NEMU.git"
EGIT_SUBMODULES=(
	ready-to-run
)
inherit git-r3

DEPEND="
	sys-apps/dtc
	media-libs/libsdl2
	sys-libs/zlib
	sys-libs/readline:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-disable-git-tracking.patch
	"${FILESDIR}"/${PN}-add-syncconfig.patch
)

QA_PREBUILT="
	usr/share/${PN}/ready-to-run/coremark-2-iteration.bin
	usr/share/${PN}/ready-to-run/linux.bin
	usr/share/${PN}/ready-to-run/riscv64-nemu-interpreter-dual-so
	usr/share/${PN}/ready-to-run/linux-0xa0000.bin
	usr/share/${PN}/ready-to-run/microbench.bin
	usr/share/${PN}/ready-to-run/riscv64-nemu-interpreter-so
"

src_prepare() {
	default
	sed -i -e "/^CCACHE/d" scripts/build.mk || die
}

src_configure() {
	export NEMU_HOME="${PWD}"
	if use savedconfig; then
		restore_config .config
		if [[ -f .config ]]; then
			ewarn "Using saved config"
		else
			die "No saved config, please consider generate one with 'make menuconfig'"
		fi
	else
		elog "No saved config, seeding minimum riscv64"
		cp configs/riscv64-xs_defconfig .config || die
	fi

	emake -j1 syncconfig < <(yes '') > /dev/null
}

src_compile() {
	export NEMU_HOME="${PWD}"
	emake
	# TODO: require cross-compilation
	# cd resource/gcpt_restore || die
	# emake
}

src_install() {
	dodoc README.md
	dodoc -r resource/debian
	dodoc -r resource/sdcard
	readme.gentoo_create_doc

	insinto "/usr/share/${PN}/"
	rm -r ready-to-run/.git || die
	doins -r ready-to-run
	# Disallow stripping of prebuilt images
	dostrip -x ${QA_PREBUILT}

	cd build || die
	for binary in $(ls -1 2>/dev/null); do
		IFS='-' read -a name <<<"${binary}" || die
		if [[ "${name[1]}" == 'nemu' ]]; then
			newbin "${binary}" "${name[0]}-nemu-xiangshan-${name[@]:2}"
		fi
	done
}

pkg_postinst() {
	readme.gentoo_print_elog
}
