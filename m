Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7695223C8A4
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 May 2025 09:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746694972; cv=none; b=JAg6gbx0gT1Mg9O23RyPUXosB3ngTaYAqK34xnFzVzPpmgdjl7gUf3DjRlky6KZVZXXAmDTrTCfqSIfD+XCP/kJxAS/P8Xzk2O8T+En8N0lKVKJG0ByAkfpz5k7K4SWkH7yEWny9e1BtUOuj+y8qVkf8ecPETOQj56WlPG2HrW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746694972; c=relaxed/simple;
	bh=0hZK7NCA+lZsMxzz6tVBNgb1As3Sn6Gt7Q4DysYI0v0=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=miQj/T/Bk8Yq4bl7jub6FEIkhyD5yjiGIdicTo0TNKomI86qzdcvlm4oxtIrqHrz9/tSNKhSgszsm8861IU+YAgnhyJuIgLuLQPylrPGErZ2YzubN2oCB/6NxXYc+eU8dfapqPBdoTdxmKj3C98w6iToO0gWZlQHKLaahNCm6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com; spf=pass smtp.mailfrom=kwiius.com; dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b=aRzTIUQB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mRwIynxx; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kwiius.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b="aRzTIUQB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mRwIynxx"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 33F021140109
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 May 2025 05:02:48 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 08 May 2025 05:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kwiius.com; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1746694968; x=1746781368; bh=GyWNgQX36J
	o1kIeAn2VIraZW9T3Z9XJkuHPFkwge+eg=; b=aRzTIUQByD2NZyA0ofGI9IYYcl
	s3iL8sGBuBU8iF7lm0E7RWzNY2DQDS04TcMi5rMVsR7FcnPJWdHuiK0DRmEKHMwc
	qOEJ5c51he8o9AOv9/OCcmeXoqPEdKyoDJUgUq5bUlfJBm/OOnkEt+uAfDVJ8t5O
	sk/qi9V4VJdSsmbqAUF9eNNdXhiqYHK0Yv83aCCZVXo05zsmX4p4hloA9B4rxvgq
	qDSpEKboWPe1PpXE2agm1dYONindLg29FN7WA4V0HFC6yt/n0X0jVnNb/pw2ECNs
	8p0TFGKUpNibMtvkP42wTCvAMe1ge6jZ/DAx5n+pQfaGd7NxUjPvxkHL1gzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746694968; x=1746781368; bh=GyWNgQX36Jo1kIeAn2VIraZW9T3Z9XJkuHP
	Fkwge+eg=; b=mRwIynxxc7mzaizFWxqkD0oCGIPQVWxYik0byrIzc5VcZrox7cT
	49dYRmTx/MBROkE549wRIQVi3hKVLG+/PBV72jBXhMiAbEQbnpqZiz4LJB4nFhMF
	0YqwkbvJaJ/BaVLVZOmX8mJdUibdZsQYljMRZk07kVzP0vk8ch3wPEbQNGUHh2Go
	XibS23UhQqDlQvLfBX4cO392jH0OZasbeL99EHorgeqRuIrA2ER0hwUNFz1sEMI3
	yCbZRzZNOJFMZrd3HImYY1DQ3nX0l1xUbJQ3scYARD1DMOoFXP5pz5dNTu9QJ2o4
	Yda5ynzd5Jkn4vSB/+dk4VsndTDPSP+03zw==
X-ME-Sender: <xms:N3McaEsv6Ai-h8s6QJfT9DOCotS5hom0ghj3g6oL3UfXUk3dBG9Q6w>
    <xme:N3McaBehc1AkzPO0a_7vpdFfWahiDvRTe2v0aRUjOn_EfqppUKmGEUUspfadVDbIo
    nUmp2Q1IY2HiC0j0w>
X-ME-Received: <xmr:N3McaPyYio4jo2zs77I1iz4Lhz6P0pAT1p5aU1nTS6nJWLEmOjHq2Aie30Q-tZI15m0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvkeelfeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefhtg
    fgggfukfffvffosehtqhhmtdhhtdejnecuhfhrohhmpeflrghmihgvucfotgevlhihmhho
    nhhtuceojhgrmhhivgeskhifihhiuhhsrdgtohhmqeenucggtffrrghtthgvrhhnpeeigf
    ekvedtffdvieeugfdttddvuddtueefkedtffdtvdfhtdduvedvtdeuudetkeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjrghmihgvsehkfi
    hiihhushdrtghomhdpnhgspghrtghpthhtohepuddpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:N3McaHP3qAtd7jhxi9pTkGYIYgDbwxLphuZbPSPSssR0m-PPcTqI9Q>
    <xmx:N3McaE9yitnglaa6m7uJAZLKKUaS4WupjWASXi_MYTyIOlqHKRpBeg>
    <xmx:N3McaPVBYGZlPKtzdGBikbvvJYjqxyWJSWHPUH6gtNjatA7sBkUxVQ>
    <xmx:N3McaNfEt8j5QybmZMLKX5azWCExeawwgk8S129v1LyRJaX2pBdFMQ>
    <xmx:OHMcaPbaBqXWpczf5bSgPe3bjU4Z_n-9DxJqUAztWcgvgFeoBeVNL3_5>
Feedback-ID: i0a19459c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Thu, 8 May 2025 05:02:47 -0400 (EDT)
From: Jamie McClymont <jamie@kwiius.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.2\))
Subject: Sanity check request: reduced replication of alloc btrees
Message-Id: <9C75AB03-4EC9-4482-AA6C-539626A28244@kwiius.com>
Date: Thu, 8 May 2025 19:02:34 +1000
To: linux-bcachefs@vger.kernel.org
X-Mailer: Apple Mail (2.3826.300.87.4.2)

Hello,

Would it be a sane idea to support a reduced metadata_replicas value for =
the types of btrees that fall under btree_id_is_alloc, and could thus be =
recreated by `-o reconstruct_alloc` (or, I think, automatically via =
bch2_btree_lost_data) if lost?

For context, my filesystem (2x280GB SSDs for metadata + caching, 4x16TB =
hard drives for data, all types of replicas=3D2), reports around 220GB =
of Btree usage:

extents:             104 GiB
inodes:             8.11 GiB
dirents:            1.78 GiB
xattrs:              512 KiB
alloc:              26.5 GiB
quotas:              512 KiB
stripes:             512 KiB
reflink:            12.0 MiB
subvolumes:          512 KiB
snapshots:           512 KiB
lru:                 763 MiB
freespace:          6.50 MiB
need_discard:        389 MiB
backpointers:       86.6 GiB
bucket_gens:         299 MiB
snapshot_trees:      512 KiB
deleted_inodes:      512 KiB
logged_ops:         1.00 MiB
rebalance_work:      855 MiB
subvolume_children:  512 KiB
accounting:         1.00 MiB

I figure reducing alloc replicas to 1 would save 55GiB of btree space on =
the fast SSDs, which could be better used for user-data caching, without =
sacrificing any durability =E2=80=93 just a one-off recovery-pass =
penalty in the event of an SSD failure (or a one-off read/checksum =
error, but I have thankfully had none of those from these drives).

Am I missing a situation where this could lead to data loss? If not, I =
might look at implementing it.

Thanks,
- Jamie McClymont=
