#!/usr/bin/env python3

from bs4 import BeautifulSoup

revisions={
	"20211027": "2",
	"20220209": "1"
}

masked_versions={
	"20240220" : "FL-12114 (amdgpu regression)"
}

async def generate(hub, **pkginfo):
	url = f"https://git.kernel.org"
	html_data = await hub.pkgtools.fetch.get_page(
		url + f"/pub/scm/linux/kernel/git/firmware/linux-firmware.git/refs/tags/"
	)
	soup = BeautifulSoup(html_data, "html.parser")
	
	# generate the three most recent versions:
	best_archives = []

	for link in soup.find_all("a"):
		href = link.get("href")
		if 'tag' in href:
			best_archives.append(href)
		if len(best_archives) >= 3:
			break

	for best_archive in best_archives:
		version = best_archive.split("=")[-1]
		url = f"https://mirrors.edge.kernel.org/pub/linux/kernel/firmware/linux-firmware-{version}.tar.xz"
		masked = version in masked_versions
		mask_reason = masked_versions[version] if masked else ""
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
			revision=revisions,
			masked=masked,
			mask_reason=mask_reason
		)
		ebuild.push()


# vim: ts=4 sw=4 noet
