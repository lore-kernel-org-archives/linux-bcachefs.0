Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EF842065
	for <linux-bcachefs@vger.kernel.org>; Sun, 28 Sep 2025 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759086088; cv=none; b=hD/J80K+ake+laitx5V8rqAF0/TXDj7tmDMEKsrgQNuLAfwEtq78k2yJSA17qT7uFnka2lI/i2p+5RispTlyZCreOc7ShFv8upYUjT7r9dLkP3Z8tQz5j3byHBjJF4Sq7EIoQnxrsp1TG0RvYq0/s5whaEIto4wDvi4B3PVUUuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759086088; c=relaxed/simple;
	bh=FxSRWKHWUz0rP0m+0bLcrdqRhXl1lMdln+0yjOkTxdU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Tnz3AVPxhyNWeW8aoKJT7bc24e3WZZDYvHMaXK/RkqskkeIsCiq21lnvMdwhI+0ZDeLn7sMcK3In/zt0VtACSBLox1QAxcSxGmjWdphEMHq6/LHpXCHiszqd/cTJasKEKei3iqbIQy7nApJnGg9EqJfhYBztR2KPXvmiVO4jXi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OHLy7IW3; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OHLy7IW3"
Date: Sun, 28 Sep 2025 15:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759086082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=FxSRWKHWUz0rP0m+0bLcrdqRhXl1lMdln+0yjOkTxdU=;
	b=OHLy7IW3BMdfhACz1pnLSXQsQEMbBwyoNn86HPOYd1coTJMlTic1gv73CkDEsUJ95yeBb6
	YF7qldaQAnNb07pV6dlVtlT2PUyRCXGj73NxCD8IJ3wNygHW3BX0mSFcwV/Xw2tWX8BUSo
	1qjIaPsm6JMaMPc49W5gKsds8NKS6EM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Subject: bcachefs: DKMS availability/migration general announcement
Message-ID: <wpunhwfhumd76tzitnd3zoxnpwq6ipxxzq7rx2igxmtpsr6jns@k3ip5mm6mxtj>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

As of Linux 6.17 and bcachefs-tools 1.31.5, bcachefs is switching to
distributing as a DKMS module. This means a normal 'make && make install' of
bcachefs-tools will also install the kernel module sources, which on a system
with a normally functioning DKMS package will be then be built and available as
any other kernel module.

Generally, this will all be handled by your distribution or appropriate
packaging for your distro.

A lot of people have contributed to distro packaging to make this go as
smoothly as possible - a big thank you to everyone involved.

The mainline version of bcachefs is still available but no longer receiving
updates, so users need to be aware of the migration and depending on
distribution may have a bit of configuration to do, but overall the migration
is expected to be fairly seamless.

You can still use bcachefs as your root filesystem provided you're using an
initramfs; DKMS has been well integrated with the distribution tooling for many
years.

The DKMS version supports Linux 6.16 and newer, and development will continue
to track prereleases of the main kernel so we'll have support ready in advance
of each .0 release.

It's important to note that in the past having an up-to-date bcachefs-tools
hasn't been particularly important (we have good compatibility mechanisms on
version mismatch), so users who were previously compiling from source on e.g.
Debian will need to switch to a packaged version of bcachefs-tools to get
regular updates. We should have these available for almost all the major
distributions.

RELEASE CADENCE, CHANNELS:
==========================

For now we're providing two channels users can choose from: nightly and
release.

The nightly channel provides frequent builds for users who are willing
to live a bit dangerously and want to get the latest and greatest and help QA:
you should know how to report a bug if you run this and you should stay up to
date on what's coming down the pipeline (via IRC or reddit); when big changes
are coming I put out the call for testers and gather feedback before features
are released. But code only moves to nightlies after passing all the automated
testing, so users should not expect significant breakage.

The release channel - latest tagged release - has code that has been deemed
stable. There is no fixed release cadence - bugfix releases are frequent,
bigger features take longer to make their way from nightlies to release.

In the future (post experimental) I'll be looking at adding a third channel -
stable - which will lag behind the release channel by perhaps 1-3 months for
bigger feature work and receive backported bugfixes.

I'm asking distributions to also provide packages for the nightly channel in
addition to release, because we really need as broad a base of testers as we
can get - having tinkerers who like to screw around and break things run the
absolute latest code is how we bring people into the community, teach them to
QA and report bugs and how the system works.

As we get closer to lifting the experimental label it's important to keep doing
everything we can to improve our ability to QA code: and QA needs both
automated testing (which we have well covered) as well as users in the wild
doing all the crazy things we developers didn't think of or plan for. So - if
you want to help out the project, running the nightlies is a great place to
start.

DISTRIBUTION SUPPORT:
====================

- NixOS, Arch: First tier support

Users shouldn't have to do anything for the DKMS migration, they've been
shipping and supporting bcachefs for quite some time and their bcachefs-tools
packages have already been updated to the DKMS release.

We do not yet have a packaged version of the nightlies for Arch. We also don't
for NixOS, but NixOS makes it much easier to pull in packages from different
sources, and bcachefs-tools provides a flake.nix for easy integration into your
configuration.nix.

A lot of distributions that users run these days are Arch variants; these users
should expect things to continue to just work.

- Debian, Ubuntu

We're providing an external repository that has both release channels (note:
the debian packaging refers to nightly as snapshot). A big thank you to Roman
Lebedev who did nearly all the work here and put a ton of effort into making
this clean and well automated.

https://apt.bcachefs.org/

We're also starting to look at getting bcachefs-tools back into Debian proper;
we've reopened an ITP and initial conversations with Debian developers have
been going in a fairly positive direction.

The previous Debian packaging effort suffered from insufficient attention given
to process practicalities and insufficient bandwidth to discuss the impedence
mismatches between what distribution packagers want and the needs for shipping
and supporting a filesystem; I'm hopeful that this time around we can take our
time and avoid the acrimony that derailed the previous effort - and with our
own repository in place we can have those discussions without the time
pressures we had before.

- Fedora:

Fedora has long had a well supported bcachefs-tools package (thanks to Neal
Gompa), so Fedora users should continue to expect a smooth experience. The one
caveat is that the bcachefs-tools package can no longer be shipped as part of
the main Fedora distribution, due to Fedora policy on out of tree kernel
modules. Instead, it's now available via a COPR:

https://copr.fedorainfracloud.org/coprs/ngompa/bcachefs/builds/

We're also talking about providing an https://rpm.bcachefs.org in the near future.

- Opensuse: !?!?!?!?!?!?

The OpenSUSE bcachefs-tools maintainers have not been communicative; there is a
bcachefs-tools package in OpenSUSE but it's not clear if it will be receiving
updates. Unfortunately, slow communication meant that we weren't able to
provide anything in time for the 6.17 kernel release, but if the package in
OpenSUSE proper is in fact not going to be receiving updates we should be able
to provide packages soon via rpm.bcachefs.org.

- Slackware:

We had a user contribute a slackbuild! Unfortunately, the link got lost in my
billions of Firefox tabs, so please chime in if you know so we can get it documented :)

For users not wishing to bother with DKMS but who don't mind compiling kernels,
my kernel repository is still available:

https://evilpiepirate.org/git/bcachefs.git

Status, experimental label:
===========================

We still look to be on track to lift the experimental label at the end of the
year; most of the activity until then should be hunting down and closing
remaining bugs.

We do have some feature work landing soon, rebalance_v2. This is being
prioritized because it's also hardening - more details here:

https://lore.kernel.org/linux-bcachefs/20250824123800.1617669-1-kent.overstreet@linux.dev/

This will be another required upgrade, with an upgrade/downgrade step - but
it's well worth it for the features and hardening it gets us.

But the focus remains on hunting down and fixing remaining bugs, and polish -
so keep testing and feeding us your bug reports. This is a community effort,
and watching the community grow and learn is a good feeling. The more, the
merrier!

Cheers,
Kent
