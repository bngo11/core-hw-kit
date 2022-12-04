# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/libusbmuxd/tarball/ce98c346b7c1dc2a21faea4fd3f32c88e27ca2af -> libusbmuxd-2.0.2-ce98c34.tar.gz"
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/2.0-6" # based on SONAME of libusbmuxd-2.0.so
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libplist-2.2.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv libimobiledevice-libusbmuxd* "${S}" || die
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(usex kernel_linux '' --without-inotify)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}