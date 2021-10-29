# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="tool to manipulate Intel X86 and X86-64 processor microcode update collections"
HOMEPAGE="https://gitlab.com/iucode-tool/"
SRC_URI="https://gitlab.com/iucode-tool/releases/raw/master/iucode-tool_2.3.1.tar.xz -> iucode_tool-2.3.1.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}/${PN/_/-}-${PV}"