# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake

DESCRIPTION="Raspberry Pi Imaging Utility"
HOMEPAGE="https://github.com/raspberrypi/rpi-imager"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/raspberrypi/${PN}.git"
else
	SRC_URI="https://github.com/raspberrypi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

RESTRICT="mirror network-sandbox"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug"

RDEPEND="
	app-arch/libarchive
	app-arch/xz-utils
	net-misc/curl
	net-libs/gnutls
	sys-fs/udisks:2
	dev-qt/qtbase:6
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
"

BDEPEND="
	dev-build/cmake
	dev-qt/qttools:6
        dev-qt/qtshadertools:6
        dev-vcs/git
"

DEPEND="${RDEPEND}"

# CMakeLists.txt is under src/
S="${WORKDIR}/${P}/src"

src_configure() {
	local CMAKE_BUILD_TYPE
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake_src_configure
}
