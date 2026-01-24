Received: from mail-05.mail-europe.com (mail-05.mail-europe.com [85.9.206.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE376025
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Jan 2026 11:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.206.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769253595; cv=none; b=S1MzmynyAQPPvbo+lCxDSikr1Y+lFtQPxBNSgEfPM0rue/lDP312sVCni1iKyMOB1E6W23QdQmUmvVrUuLNr1r51yUPW50uBnWzwXDM17EkcsVRgo0lXMwnaxxmOHLIl5jDoGIL01qeyVn1OHcjnWisD07/KP7F1Y5D6uxc7/j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769253595; c=relaxed/simple;
	bh=UhjyEjIcQZ+UjacPzM9Htp9NaTaFx7uPJ2aRuGJx5F8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=RABic5LNx5VVPENAKIPeF+wiyWlubTCuELMKtXjh0v+g3Fl8KMYC6p3t0GaiQfL32LOk8mqx9svSqPrCqM+hxtGVTJO7o0i+AYGMYqCFjaYT0G4ZY5L+4SkASBS/lmto/T8/BTMho+v160MERltki0ALmFlGp6GPT46sg/3QKxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=XZNW58oW; arc=none smtp.client-ip=85.9.206.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="XZNW58oW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1769253575; x=1769512775;
	bh=eYbHyCmN/BuXG/Tkrwj4q+cGrnIWVpbdRyjehKfUZpk=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=XZNW58oW8+A8jIfg0tqr1Yx4x1q5mi1kVCfdpUaNQzmf4v0cO6PYaV3cu/3flb29Z
	 0HzA3WG2YgrQmKcp+dskYsHSHs7ray6knZ+Cv8MykDiUDg1e21KRopOXKknBphoWXH
	 nJGOxaqrJsOSchtUSrwxlaSeNMtdEPRvn7WWJKB+Ni280rkXsEEad9iwOJW4lNepTA
	 zzJAg48S3T4LH27snQ8xWdApW/eXOtn0hUqPjvMT2E21k6qLByjvsKG5Jzpof+XKVQ
	 SiNW2r5fy0ROz8GOkB68/XxSAxl9EOOFrJOVpzIvCD9WhCi4h0duZHXFSK5RMsbTxA
	 FsKep7282sTfQ==
Date: Sat, 24 Jan 2026 11:19:33 +0000
To: linux-bcachefs@vger.kernel.org
From: Jul Lang <jullanggit@proton.me>
Cc: kent.overstreet@linux.dev, Jul Lang <jullanggit@proton.me>
Subject: [PATCH 0/2] Various typo fixes
Message-ID: <20260124111913.6263-1-jullanggit@proton.me>
Feedback-ID: 86367135:user:proton
X-Pm-Message-ID: 0b82b8a9783ff546473b8e338ae637b00ea274e9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This series fixes various typos across the bcachefs source tree.

Patch 1 fixes an article typo in a function comment.
Patch 2 is a manually curated run of [typos](https://github.com/crate-ci/ty=
pos) on the codebase.

Jul Lang (2):
  docs: fix typo in bch2_trans_begin inline comment
  fix typos

 fs/bcachefs/alloc/accounting.c            |  2 +-
 fs/bcachefs/alloc/buckets.c               |  2 +-
 fs/bcachefs/alloc/check.c                 |  2 +-
 fs/bcachefs/alloc/foreground.c            |  6 +++---
 fs/bcachefs/bcachefs.h                    |  2 +-
 fs/bcachefs/bcachefs_format.h             | 10 +++++-----
 fs/bcachefs/bcachefs_ioctl.h              |  4 ++--
 fs/bcachefs/btree/bkey_methods.c          |  4 ++--
 fs/bcachefs/btree/bkey_methods.h          |  2 +-
 fs/bcachefs/btree/bset.h                  |  4 ++--
 fs/bcachefs/btree/cache.c                 |  2 +-
 fs/bcachefs/btree/interior.h              |  2 +-
 fs/bcachefs/btree/iter.c                  |  6 +++---
 fs/bcachefs/btree/update.c                |  4 ++--
 fs/bcachefs/data/checksum.c               |  2 +-
 fs/bcachefs/data/reconcile/work.c         |  2 +-
 fs/bcachefs/debug/async_objs.c            |  2 +-
 fs/bcachefs/fs/check.c                    |  2 +-
 fs/bcachefs/fs/inode.c                    |  2 +-
 fs/bcachefs/init/passes.c                 |  2 +-
 fs/bcachefs/init/progress.h               |  2 +-
 fs/bcachefs/journal/journal.c             |  4 ++--
 fs/bcachefs/journal/types.h               |  4 ++--
 fs/bcachefs/journal/write.c               |  2 +-
 fs/bcachefs/sb/io.c                       |  2 +-
 fs/bcachefs/sb/members_format.h           |  2 +-
 fs/bcachefs/snapshots/format.h            |  4 ++--
 fs/bcachefs/util/eytzinger.h              |  2 +-
 fs/bcachefs/util/mean_and_variance.h      |  4 ++--
 fs/bcachefs/util/mean_and_variance_test.c |  2 +-
 fs/bcachefs/util/printbuf.c               |  2 +-
 fs/bcachefs/util/printbuf.h               |  4 ++--
 fs/bcachefs/util/rcu_pending.c            |  2 +-
 fs/bcachefs/util/siphash.h                |  2 +-
 fs/bcachefs/util/six.c                    |  6 +++---
 fs/bcachefs/util/six.h                    |  4 ++--
 fs/bcachefs/util/time_stats.h             |  2 +-
 fs/bcachefs/util/util.c                   |  2 +-
 fs/bcachefs/vfs/io.c                      |  2 +-
 39 files changed, 59 insertions(+), 59 deletions(-)

--=20
2.52.0


