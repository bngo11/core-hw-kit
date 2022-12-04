# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd udev

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/usbmuxd/tarball/79c8b38d1488a6b07e1e68f39d8caec3f1a45622 -> usbmuxd-1.1.1-79c8b38.tar.gz"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	>=app-pda/libimobiledevice-1.0:=
	>=app-pda/libplist-2.0:=
	virtual/libusb:1"

RDEPEND="
	${DEPEND}
	virtual/udev
"

BDEPEND="
	virtual/pkgconfig
"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv libimobiledevice-usbmuxd* "${S}" || die
	fi
}

src_prepare() {
	default
	eautoreconf
}