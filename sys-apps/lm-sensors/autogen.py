#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://api.github.com/repos/lm-sensors/lm-sensors/tags", is_json=True)
	version = None

	for item in json_data:
		try:
			vername = item['name']

			if vername.startswith("V"):
				version = vername.strip('V').replace('-', '.')
				list(map(int, version.split(".")))
				break

		except (KeyError, ValueError):
			continue

	if version:
		url = f"https://github.com/lm-sensors/lm-sensors/archive/{vername}.tar.gz"
		final_name = f"lm-sensors-{version}.tar.gz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)]
		)
		ebuild.push()

# vim: ts=4 sw=4 noet
