# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Hardware detection tool used in SuSE Linux"
HOMEPAGE="https://github.com/openSUSE/hwinfo/"
SRC_URI="https://github.com/openSUSE/hwinfo/archive/21.77/hwinfo-21.77.tar.gz -> hwinfo-21.77.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	amd64? ( dev-libs/libx86emu )
	x86? ( dev-libs/libx86emu )"
DEPEND="${RDEPEND}
	sys-devel/flex
	>=sys-kernel/linux-headers-2.6.17"

src_prepare() {
	touch changelog
	default
}

src_compile() {
	tc-export AR
	MAKEOPTS="-j1"
	emake CC="$(tc-getCC)" HWINFO_VERSION="21.77"
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" HWINFO_VERSION="21.77" install
	keepdir /var/lib/hardware/udi

	dodoc changelog README*
	docinto examples
	dodoc doc/example*.c
	doman doc/*.{1,8}
}