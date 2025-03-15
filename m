Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F97AD51
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741996994; cv=none; b=ZT8zKqCId2QHP0HxyQCxgq1RVaSlwS186ttK9d8kGmoTGinvlp68KghAux6cAnlAd5c2z1BcQX70fmXVpFreVhvmDbH/l0juyDbatc4T5nmhEVsQYYoe7RvtoUr20p9oUTXkUyFW1HlhaA/YpUwj2jSO0M+d6U6fqtBkLqBqBvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741996994; c=relaxed/simple;
	bh=SvOXA2p+/PRAuWrQkjWb/jZQJGKKE9OND9HPQrQ4k1c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QEVX+eyM/u/2sNcd3f/bd/s8VrgHQUtWP8gOlzTUciShYUUTGCqpQrQNZeeinfP7AdE5fg1NVA8kP3I26Wl4o63e0ZtwCtNurDQ0+Ih7ItuwE0PvFVQ0usyKJwejx8OMqFxE/4EH/sOo1DRq9CnrZJOx7CTMwIeM2UhKJJ3wGWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uJCfd8Xn; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uJCfd8Xn"
Date: Fri, 14 Mar 2025 20:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741996980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ZXAi8mk59ja0n8uFit/KogLV8pXjQxSe60D7nsen6Ow=;
	b=uJCfd8XnHEiPIZl7AQKo0O1xN7S7T56AVQgFCDcPipgRTbEFy192walRtutZJKvS1QSyoo
	A8tK5NASML9WMiAcLhs5oTxX4sjl+sz5v6Z8Q3Gc5SpWCZgTfiRqt18x1uPQ0j066IzZDA
	+QZx8LBRK+xnzV2M8echKqBlrG2IfKc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs hotfixes for 6.14-rc7 v2...
Message-ID: <r6wusnyqqcmnamampwguyscjpvgwrnwhipsglryaltnofmmkf3@7b4fixf5q2qg>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

You'll be wanting this one too...

The following changes since commit 9c18ea7ffee090b47afaa7dc41903fb1b436d7bd:

  bcachefs: bch2_get_random_u64_below() (2025-03-13 12:40:22 -0400)

are available in the Git repository at:

  git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-03-14.2

for you to fetch changes up to 1a2b74d0a2a46c219b25fdb0efcf9cd7f55cfe5e:

  bcachefs: fix build on 32 bit in get_random_u64_below() (2025-03-14 19:45:54 -0400)

----------------------------------------------------------------
bcachefs hotfixes for 6.14-rc7

- change an assertion to an ERO that a user hit doing the 6.14 upgrade
- fix 32 bit build breakage

----------------------------------------------------------------
Kent Overstreet (2):
      bcachefs: Change btree wb assert to runtime error
      bcachefs: fix build on 32 bit in get_random_u64_below()

 fs/bcachefs/btree_update.h       |  8 ++++++++
 fs/bcachefs/btree_write_buffer.c | 21 ++++++++++++++++++++-
 fs/bcachefs/util.c               |  3 ++-
 3 files changed, 30 insertions(+), 2 deletions(-)
