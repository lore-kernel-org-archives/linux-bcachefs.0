Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02A22AF07
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 01:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805353; cv=none; b=PNOe6nZEcioBbkaGuWxAUjDkkQoA26xunSG01G0ifEh7nRcQ5YKLZZXscjo4Ec6fuGQKmDn7CzZe1Ud6YTGn3w3NgeIT+HYw+NJ8z16u1DXY67BKu8dLwYyUCrdQodotxEeEF17r0P3aqycHM8TytnfWaqJwf2krXDtN12zratE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805353; c=relaxed/simple;
	bh=wVboeD0AxkPKctM4H9j/jIMesckJxXXj+0SVQziEUMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HwwqQ3aZ8g18txhaUuUdJ0e/ZmoY+ViwIa5mTqvyJqomStjKNW4t1F5P3gfu6gA+b5PyNTj4YZO6xicEtHwPTT80dsbrjTEc/7E0qAdfDcNWk6lMKNQE3bIf/xpYA+RzM8V+Y3dPHhfE7CXRKEjwaRhwMB1TcUQSeE0gG8hVWFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uGMcdGUU; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uGMcdGUU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738805344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OQsBR1R9mGSFxaDnJIzJtbLQ8QIhYBEwOO7XEx1/iuE=;
	b=uGMcdGUUSyBOqMyD4rD8asQDWvjlsqg8d7kIQKIfZYhOPJKstElhxXANhOToFfaP+8Q/3r
	sOYg2s8Ovo6SDnviIVyL7vnxp9zyYOT/ZzQolYhV9AaGLq9CypX6ICAVdtIT1hwk6aVVtX
	zy+27qFYLD9pdrdxlwABYZO/7aepIec=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/5] improve journal pipelining
Date: Wed,  5 Feb 2025 20:28:45 -0500
Message-ID: <20250206012852.1658754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

this series makes the journal code even more complicated for the
purposes of improving journal pipelining, which yet again is turning up
as an issue in performance testing

previously, there could be at most 4 journal writes in flight at a time
(each up to ~2MB); the new limit is 16.

there are two different "outstanding journal buf" limits which now have
to be split: journal bufs with outstanding reservations, and journal
bufs with writes in flight. journal reservation state can only address
up to 4 journal bufs - that's the max for "bufs with outstanding
reservations" (and 2 would likely be fine there, now that they're split,
but it's not necessary).

with JOURNAL_BUF_NR going up, they can't be hanging onto data buffers
when not in use anymore - that would pin 16 * 2 = 32MB of ram; so we add
a single element open coded mempool (because the element size is not
fixed), which also will help performance because it'll cut out a lot of
system allocator calls and high order page allocations can be slow.

re: journal pipelining being a performance limit - the reason this is
coming up is because the amount of data we're journalling for a simple
extents btree update has been going up, and up, and up. nowadays, there
are backpointer updates and a whole bunch of accounting updates - check
__trigger_extent() for the full list or look at 'bcachefs list_journal
-a' output, there's compression type accounting, snapshot accounting,
per inode accounting, per replicas accounting...

so, one thing I've been considering is not journalling
backpointers/accounting updates since they're strictly dependent on keys
in the same transaction, i.e. journal replay can correctly regenerate
them. have not seen a perf increase from it in testing yet though, may
have to kill other bottlenecks first.

Kent Overstreet (5):
  bcachefs: Kill journal_res_state.unwritten_idx
  bcachefs: Kill journal_res.idx
  bcachefs: Don't touch journal_buf->data->seq in journal_res_get
  bcachefs: Free journal bufs when not in use
  bcachefs: Increase JOURNAL_BUF_NR

 fs/bcachefs/bcachefs.h      |  1 +
 fs/bcachefs/journal.c       | 97 ++++++++++++++++++++++++++++++-------
 fs/bcachefs/journal.h       | 38 ++++++++++-----
 fs/bcachefs/journal_io.c    | 28 ++++++-----
 fs/bcachefs/journal_types.h | 19 +++++---
 5 files changed, 135 insertions(+), 48 deletions(-)

-- 
2.45.2

