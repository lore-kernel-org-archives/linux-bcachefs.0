Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F95156F45
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Sep 2025 23:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757632790; cv=none; b=K6lY4idftwNl49/xLkKca6duex/eoS6wzxxRlea93bvPXBUrqAkz2RTcC0/JU1KS1oozebUyjQQ7gq5oQokIWvJ+0MczkOcOyMCq3SkfCD2SSejGKoSZ6P47ynCJ6RYwZ+wpJPGs3ynJdJFK7qgCFi20rPbpySjIcwKJzASouVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757632790; c=relaxed/simple;
	bh=Av6/z8hs6bLVbIzUXGJ67XwwTFsbQRRqZUzxwb5Beww=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=N7l/OK56YliOVr18zdVAxAOCAvRetYxNJohSScz1G5QMMcj4WlO+U+S8+J0rI99qPiSgX6g/KxDVvDZZvwShK5+ThI+tzrXbxVmEZ0oq5MmWjIgEXH5o12vLpXu8hyluk3KNLtB1lHIpn96BuIySiz7hmrTsOrj7WC/qqeubhHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XaPgLm/k; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XaPgLm/k"
Date: Thu, 11 Sep 2025 19:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757632785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=YcAt/7Go/PBZ+F/f8oRYRxWymp9ZTqIhmm5xfo1Lu7M=;
	b=XaPgLm/klzu1IFpMi6Ugwepy4OYIQsZyX9F7FgRnGuK/eRLRT32FKjbXs1z5GOz5H3ATxI
	IZfRLmCmlG+Q62xVVLfBg82wR9yHqyy6zS/zpLoWgB6USkAB/LmqS/igdGW5gwVVZVy7gF
	7B2oA1xoyYzzvCJtJQJxo0+pS0fX/A0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Subject: Upcoming changes for bcachefs; notes for users distributions
Message-ID: <yokpt2d2g2lluyomtqrdvmkl3amv3kgnipmenobkpgx537kay7@xgcgjviv3n7x>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

As many of you are no doubt aware, bcachefs is switching to shipping as
a DKMS module. Once the DKMS packages are in place very little should
change for end users, but we've got some work to do on the distribution
side of things to make sure things go smoothly.

Good news:

- The community has been stepping up to help out, and distributions so
  far have been helpful in making sure this goes smoothly. This is
  important because there are a lot of people using bcachefs on major
  distributions who've been getting it from their normal stock kernel;
  we'll need their help to make sure this all goes well, but I think we
  can do it.

- Yes, you'll still be able to use your root filesystem :) DKMS modules
  can be included in an initramfs just like any other module.

- My git trees are still there, and I'm going to switch to basing them
  on .0 releases. For people who are comfortable with compiling kernels
  or want to avoid DKMS hassle, this is something to keep in mind.

- Expect no change in QA, stability of releases, etc. We've got our QA
  processes ironed out, and we'll still be staging changes before they
  go into releases that users see - we have plenty of people that test
  the nightlies and we have an amazing community of people doing the
  hard work of testing and QA that works well together.

- 6.16 has turned out to be a very solid release, and bcachefs (so far)
  isn't being deleted from the kernel. This is important because it's
  going to take a bit to get all the packaging issues sorted out, and
  DKMS needs distribution specific testing, so it looks like most users
  will be still be running the 6.16 release when 6.17 comes out.

  All that bug grinding has paid off - and a thank you to all the people
  who've been reporting bugs and working with me to debug issues, people
  have been very responsive and helpful. We're getting very close to
  lifting the experimental label.

  For some specifics, since the 6.16 release there have been zero new
  critical bug reports. The bug fixing activity has mainly been
  performance bugs, test dashboard bugs (low severity stuff that's
  unlikely to ever affect users), and the highest severity bug was a
  repair bug, where we still repair and mount successfully with zero
  user intervention - just via a more expensive codepath than normal. So
  a minor annoyance, not severe.

  I've been communicating with both Debian and OpenSUSE kernel
  maintainers who were initially under the impression that bcachefs
  would no longer be supported and were flipping it off in their kernel
  config, and they're holding off so we can have the DKMS stuff ready.

What still needs to happen - distribution support:

- The big issue we're going to run into has been that previously, having
  an up-to-date bcachefs-tools was not critical. We've got good
  compatibility between kernel/userspace and we don't depend on
  userspace fsck (userspace and kernelspace are equally well supported,
  with an automatic fallback to the kernel fsck implementation on
  version mismatch).

  This has meant that distribution bcachefs-tools packages were low
  priority, and people on e.g. Debian have generally been compiling from
  git and updating infrequently.

  bcachefs-tools in Debian was orphaned and then removed, so we
  (preferably) need to get it back into experimental, or alternatively
  get a PPA going. We reopened an ITP today:

  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1080344

  The situation should be good on Arch and NixOS, we frequently work
  with those distributions (and the DKMS support that just landed in
  bcachefs-tools came from an Arch user). Fedora has a maintained
  bcachefs-tools package; there are other distributions that have
  bcachefs usage I'm aware of but we haven't ascertained the packaging
  situation. (e.g. OpenSUSE; I was informed in the discussion for the
  kernel package that DKMS there will likely need special attention).

- If you're aware of a distribution with bcachefs users that needs
  attention, please contact me or the community.

- We'll need people testing the DKMS packages on various distributions,
  please get in contact if you can help with that

- Or even better, if you're experienced in packaging, we can use you!

With debugging and stabilization slowing down, I've also got more time
available to devote to distribution and packaging issues, and we have
more people helping out than we did in the past. If you're a packager
who I was short with in the past, apologies; filesystem development is
hectic and tense at times, but the really crazy part is slowing down
(and another crazy part commencing! woohoo!).

Cheers,
Kent
