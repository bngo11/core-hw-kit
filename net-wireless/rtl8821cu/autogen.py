#!/usr/bin/env python3

from datetime import datetime, timedelta
import re
import base64

async def generate(hub, **pkginfo):
	user = "morrownr"
	repo = "8821cu-20210916"

	commits = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{user}/{repo}/commits",
		is_json=True,
		refresh_interval=timedelta(days=15),
	)
	target_commit = commits[0]
	commit_date = datetime.strptime(
		target_commit["commit"]["committer"]["date"], "%Y-%m-%dT%H:%M:%SZ"
	)
	commit_hash = target_commit["sha"]

	version = commit_date.strftime("%Y%m%d")

	url = f"https://github.com/{user}/{repo}/archive/{commit_hash}.tar.gz"
	final_name = f"{pkginfo['name']}-{version}-{commit_hash}.tar.gz"

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		github_user=user,
		github_repo=repo,
		version=version,
		sha=commit_hash,
		artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
	)
	ebuild.push()

