# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit meson python-any-r1 toolchain-funcs

DESCRIPTION="EFI executable for fwupd"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://github.com/fwupd/fwupd-efi/tarball/eb79ba8d3c35549f023a9d5fd2fe4c1c70c084d2 -> fwupd-efi-1.4-eb79ba8.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE=""

BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

DEPEND="sys-boot/gnu-efi"

RDEPEND="!<sys-apps/fwupd-1.6.0"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv fwupd-fwupd-efi* "${S}" || die
	fi
}

src_prepare() {
	default
	python_fix_shebang "${S}/efi"
}

src_configure() {
	local emesonargs=(
		-Defi-cc="$(tc-getCC)"
		-Defi-ld="$(tc-getLD)"
		-Defi_sbat_distro_id="funtoo"
		-Defi_sbat_distro_summary="Funtoo GNU/Linux"
		-Defi_sbat_distro_pkgname="${PN}"
		-Defi_sbat_distro_version="${PVR}"
	)
	meson_src_configure
}