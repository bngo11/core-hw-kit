# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Library handling the communication with Apple's Tatsu Signing Server (TSS)."
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/libtatsu/releases/download/1.0.3/libtatsu-1.0.3.tar.bz2 -> libtatsu-1.0.3.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=">=app-pda/libplist-2.6.0"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( NEWS README.md )
