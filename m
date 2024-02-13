Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DFB605C6
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Feb 2024 19:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707851837; cv=none; b=mNk47AbvSi/ZOBMlIu8+sY/1p66k8gn7uQEkx7yLRSeSEb/7YTJvupM4SVxHQ/7prJew66nr00YHlu1jCxJWsB1nIx+RpIOpZeKgPi3GM//aBrVSaq9IKCSsPvrlvoTx15h6KlLg4RxAMMPC+7MxwbPrMd8h0qRuYMNkHqBUhBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707851837; c=relaxed/simple;
	bh=fCr3MSuUOxA6764CzR/XBJ5u4Dh6Rw2fD8+m9h9Ezpw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HUE1OnyFRIABdYbU2VMsGjayJ0jiYgLHbVy+NStlBL2hlQwDAqIKH/Vki5n0ty2sXv/hn1+EOAlF3dexmA321plIsEbW3JrWlJpEH45pS5WswCEfGi3hJuF1/7BmK0BBE3CMG87LIxtuZP5GZ7rLHerWFXiwKdk63LXB4Av7sos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s5DpXJoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s5DpXJoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F1DC433F1;
	Tue, 13 Feb 2024 19:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707851836;
	bh=fCr3MSuUOxA6764CzR/XBJ5u4Dh6Rw2fD8+m9h9Ezpw=;
	h=Date:From:To:Cc:Subject:From;
	b=s5DpXJoDOQ/4b3+cuD/9bbXRWERKwdQ/83NzrIHXox6gBUbnJEhjFmToNdYGY+56l
	 9R19cYVE4+uFXjhgBxFZc+ma3wkzE/YRWlEdBwXOkZTwd3qCR1DHu6YxQIpN/XSPHc
	 QjNZAG8ZkdvI+P/sd2oZ3mIshwZ8LYdh8DXTrmUxbdtZGwzLvOMJ3Ys7OLk65MlupI
	 goygUsy/jG+lobEn/wyao290JDzPORxb0mtEipXc3JcGrm2iF/c4r8J6DN1f342VXN
	 jE1RQFOtEpRrP7uMkg9avDz5v+GuYDB8f70EoFT4UHbua4Ec31C2MaToEhgZ/0H2Yo
	 un3YAZR5wCUvw==
Date: Tue, 13 Feb 2024 11:17:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org
Subject: [ANNOUNCE] thread with file: twf-cleanups updated to 1737799da27ff
Message-ID: <170785143225.984170.828418190611017982.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kent,

The twf-cleanups branch of the xfs-linux repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

has just been updated for your review.

This code snapshot has been rebased against recent upstream, freshly
QA'd, and is ready for people to examine.  For the best experience, it
is recommended to pull this branch and walk the commits instead of
trying to read any patch deluge.  I'm kinda done with spraying hundreds
of patches at the lists, so now I'm trying out a method of sending email
about an entire branch to start a human-to-human discussion.

The new head of the twf-cleanups branch is commit:

1737799da27ff thread_with_file: allow ioctls against these files

4 new commits:

Darrick J. Wong (4):
[6e7de89d28959] thread_with_file: allow creation of readonly files
[3a4eae9b01b42] thread_with_file: fix various printf problems
[93a017afe3941] thread_with_file: create ops structure for thread_with_stdio
[1737799da27ff] thread_with_file: allow ioctls against these files

Code Diffstat:

fs/bcachefs/chardev.c            |  18 ++++---
include/linux/thread_with_file.h |  20 +++++---
lib/thread_with_file.c           | 107 +++++++++++++++++++++++++++++++--------
3 files changed, 111 insertions(+), 34 deletions(-)
