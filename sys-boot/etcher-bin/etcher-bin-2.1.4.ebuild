# Copyright 1999-2025 Gentoo Authors
# Distributed under the GNU General Public License v2

EAPI=8

DESCRIPTION="Etcher: Flash OS images to SD cards & USB drives"
HOMEPAGE="https://www.balena.io/etcher/"
SRC_URI="mirror://sourceforge/balenaEtcher/etcher-bin-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
    # Unpack the zip archive
    unzip "${DISTDIR}/etcher-bin-${PV}.zip" -d "${WORKDIR}/balenaEtcher-linux-x64"
    S="${WORKDIR}/balenaEtcher-linux-x64/balenaEtcher-linux-x64"
}

src_compile() {
    # No compilation needed; it's a prebuilt binary
    :
}

src_install() {
    # Create directories
    dodir /opt/etcher
    dodir /usr/local/bin
    dodir /usr/share/applications
    dodir /usr/share/icons/hicolor/128x128/apps

    # Copy all Etcher files to /opt/etcher
    cp -r "${S}/"* "${D}/opt/etcher/"

    # Wrapper script
    cat > "${D}/usr/local/bin/etcher" <<'EOF'
#!/bin/bash
ETCHER_DIR="/opt/etcher"
export LD_LIBRARY_PATH="${ETCHER_DIR}:${LD_LIBRARY_PATH}"
exec "${ETCHER_DIR}/balena-etcher" "$@"
EOF
    chmod +x "${D}/usr/local/bin/etcher"

    # Desktop entry for start menu
    cat > "${D}/usr/share/applications/etcher.desktop" <<'EOF'
[Desktop Entry]
Name=Etcher
Comment=Flash OS images to SD cards & USB drives
Exec=/usr/local/bin/etcher
Icon=etcher
Terminal=false
Type=Application
Categories=Utility;System;Flasher;
EOF

    # Copy icon if it exists
    if [[ -f "${S}/resources/icon.png" ]]; then
        cp "${S}/resources/icon.png" "${D}/usr/share/icons/hicolor/128x128/apps/etcher.png"
    fi
}

pkg_postinst() {
    elog "Etcher installed in /opt/etcher"
    elog "Run it via 'etcher' or from your Start Menu"
}
