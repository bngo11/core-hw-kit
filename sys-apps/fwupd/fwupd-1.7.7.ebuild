# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit meson python-single-r1 vala xdg-utils

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://github.com/fwupd/fwupd/releases/download/1.7.7/fwupd-1.7.7.tar.xz -> fwupd-1.7.7.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="+colorhug consolekit +dell doc elogind +intel-amt +man +nvme redfish +synaptics systemd test +thunderbolt +uefi"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( consolekit elogind systemd )
	dell? ( uefi )
"

RDEPEND="${PYTHON_DEPS}
	app-arch/gcab
	app-arch/libarchive:=
	dev-db/sqlite
	>=dev-libs/glib-2.45.8:2
	dev-libs/json-glib
	dev-libs/libgpg-error
	dev-libs/libgudev:=
	dev-libs/protobuf-c
	>=dev-libs/libgusb-0.2.9[introspection]
	>=dev-libs/libxmlb-0.3.7
	>=dev-libs/libjcat-0.1.10
	$(python_gen_cond_dep '
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	')
	>=net-libs/libsoup-2.51.92:2.4[introspection]
	>=sys-auth/polkit-0.103
	virtual/libelf:0=
	colorhug? ( >=x11-misc/colord-1.2.12:0= )
	consolekit? ( >=sys-auth/consolekit-1.0.0 )
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.4.0
	)
	elogind? ( sys-auth/elogind )
	app-crypt/gpgme
	dev-libs/libgpg-error
	nvme? ( sys-libs/efivar )
	>=net-libs/gnutls-3.4.4.1:=
	redfish? ( sys-libs/efivar )
	systemd? ( >=sys-apps/systemd-211 )
	thunderbolt? ( sys-apps/thunderbolt-software-user-space )
	uefi? (
		media-libs/fontconfig
		media-libs/freetype
		sys-boot/gnu-efi
		>=sys-libs/efivar-33
		x11-libs/cairo
		app-crypt/tpm2-tss
		sys-apps/fwupd-efi
	)
"
DEPEND="${RDEPEND}
	$(vala_depend)
	x11-libs/pango[introspection]
	nvme? (	>=sys-kernel/linux-headers-4.4 )
	test? ( net-libs/gnutls[tools] )
"
BDEPEND="
	>=dev-util/meson-0.47.0
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	man? (
		app-text/docbook-sgml-utils
		sys-apps/help2man
	)
"

# required for fwupd daemon to run.
# NOT a build time dependency. The build system does not check for dbus.
PDEPEND="sys-apps/dbus"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	xdg_environment_reset
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dconsolekit="$(usex consolekit true false)"
		-Ddocs="$(usex doc gtkdoc none)"
		-Delogind="$(usex elogind true false)"
		-Dman="$(usex man true false)"
		-Dplugin_amt="$(usex intel-amt true false)"
		-Dplugin_dell="$(usex dell true false)"
		# Requires libflashrom which our sys-apps/flashrom
		# package does not provide
		-Dplugin_flashrom="false"
		# Dependencies are not available (yet?)
		-Dplugin_modem_manager="false"
		-Dplugin_nvme="$(usex nvme true false)"
		-Dplugin_redfish="$(usex redfish true false)"
		-Dplugin_synaptics_mst="$(usex synaptics true false)"
		-Dplugin_synaptics_rmi="$(usex synaptics true false)"
		-Dplugin_thunderbolt="$(usex thunderbolt true false)"
		-Dplugin_uefi_capsule="$(usex uefi true false)"
		-Dplugin_uefi_capsule_splash="$(usex uefi true false)"
		-Dplugin_uefi_pk="$(usex uefi true false)"
		-Dsystemd="$(usex systemd true false)"
		-Dtests="$(usex test true false)"
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	sed "s@%SEAT_MANAGER%@$(usex elogind elogind consolekit)@" \
		"${FILESDIR}"/${PN}-r1 \
		> "${T}"/${PN} || die
	doinitd "${T}"/${PN}

	if ! use systemd ; then
		# Don't timeout when fwupd is running (#673140)
		sed '/^IdleTimeout=/s@=[[:digit:]]\+@=0@' \
			-i "${ED}"/etc/${PN}/daemon.conf || die
	fi
}

pkg_postinst() {
	elog "In case you are using openrc as init system"
	elog "and you're upgrading from <fwupd-1.1.0, you"
	elog "need to start the fwupd daemon via the openrc"
	elog "init script that comes with this package."
}