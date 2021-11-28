#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	html_data = await hub.pkgtools.fetch.get_page("https://www.github.com/openSUSE/hwinfo/tags")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	version = None

	for link in links:
		href = link.get("href")
		if href and "tag" in href:
			parts = href.split("/")
			version = parts[-1]

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		url = f"https://github.com/openSUSE/hwinfo/archive/refs/tags/{version}.tar.gz"
		final_name = f"hwinfo-{version}.tar.gz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
