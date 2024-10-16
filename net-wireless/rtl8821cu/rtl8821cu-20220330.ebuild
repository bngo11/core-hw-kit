# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod

DESCRIPTION="Realtek RTL8811CU/RTL8821CU USB wifi adapter driver"
HOMEPAGE="https://github.com/brektrou/rtl8821CU"
SRC_URI="https://github.com/brektrou/rtl8821CU/archive/de68bd50671ad8a5c09af97def3f2059b4a088aa.tar.gz -> rtl8821cu-20220330.tar.gz"

LICENSE="GPL-2"
KEYWORDS="*"

DEPEND="virtual/linux-sources"

MODULE_NAMES="8821cu(net/wireless)"
BUILD_TARGETS="all"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/rtl8821CU-* "${S}"
}

src_prepare() {
	default

	# FL-8716: Use the latest kernel instead of the currently running one.
	get_version

	sed -i \
		-e "s|\$(shell uname -r)|${KV_FULL}|g" \
		Makefile
}