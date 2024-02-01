Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4900715B970
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 Feb 2024 11:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.111.4.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706786977; cv=none; b=co480aaBpCjUS9jPY8ieIu26dmeG19sohtPgnR13R0Isrf+fCn8mba1RXt1sSQtyWK1AFYGKOFSb6MGHYCc8+0JBWabaE3J9NLlVcKxbeYyq4lwX1umSsxhOrujRHxF802zPn2YIdjL9Yu+OYCVy4nKvnGxSPJuSybTeRdRrlh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706786977; c=relaxed/simple;
	bh=uUuxvfRmREwcUlMGfZN4p4/sptAyq3K5KdB2KpHRBII=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=DdH8Too/DPNeOMD6SarFD1ePdT8x7E0c6XFzKK0qQ0DtXmmrabcFgiA8yV6HGp5163FcRRy8uwfbZoe7ziEiTbcuy15oQbsxdtoYwgXCDOmwoUO0uDVxyCsGwciLpG6MkKGvM7w8HtmvLs4UVPTeAWlocAzZkQD0r9RVipQZFNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com; spf=pass smtp.mailfrom=kwiius.com; dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b=eoAupxsB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=otXwcH5/; arc=none smtp.client-ip=66.111.4.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kwiius.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b="eoAupxsB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="otXwcH5/"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 4B8A55C019A
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 Feb 2024 06:29:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 01 Feb 2024 06:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kwiius.com; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1706786974; x=1706873374; bh=uPlLiCwV3i
	loc6ZN9fTOhnmL/qXw8yivTwNP2XsjijI=; b=eoAupxsBhrJ+7Q6/h+RnBXLCIa
	fIdX5GdPJd+ZsXSj6xvSsFfEObWDJt9sw8oQJ7i7bN61zWOgt8+sOEwiPZ/W2IR2
	a8gXvpHvBXqH2WntuLxZeWPlHXM/PDBy7vBkJeIXKAVIIqraS4zOh3/VUOaj5jMp
	WkjEqc51f8uwngNlYBmH4s4qWD+HRpr3HGMwYeEUfQKoFZEnNPOpccaP19A9ZgHq
	lpTRo+X30NVamUFwjH/zRHJVlw1DTegYp8MRKeFnSCEeCBhpcg8dPxURQW42CUbj
	Jdis8YAlhVBEDgES+64UQc2vOuHz6eVxAV25BGkRYw+XRKgeVpbTxnjvmUng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1706786974; x=1706873374; bh=uPlLiCwV3iloc6ZN9fTOhnmL/qXw
	8yivTwNP2XsjijI=; b=otXwcH5/4spOCGjPvLpYBmeb+B2zFMiR3IF8XVhkf9gx
	RVliRLPE+1RjgQlhVo5tZbUoamJECI3kQ76D1w+TEkxAUiTeEyRg0q2IH+XWxus5
	xfTVsOfzWzi/03mdftFSzoZZZZZjcxxzu/ygxDKGTNDbEjn1LpPuDNYSHf38gnaG
	JSK5Uj8Bh6EqzHC7Z/w0jwj9XpVXd8bHT7PlojV8BrKj0YZuJ+iOB2Q0fj17gScP
	+5Dhn99PCg1wOxPo+q3o4ekCL16XMixsEp3hKqF/LyzGQHPnGPknfgjtp3Y83n3G
	qu9XJVtBiTj+rtbcgsHdzLgRGrEsOYOfmsbqav/OSg==
X-ME-Sender: <xms:noC7ZbrmxZPmCPo4QxlEKXWw4eUgvTKbarknr-sQ0weQwtPFoBhe0g>
    <xme:noC7ZVp1_P9LipkA2exTIlP7BcAK_lw3-6NhJ_vGzUh9-KZSbjA6CfpblZYYoKlCs
    0SOABczgG92FWTjFQ>
X-ME-Received: <xmr:noC7ZYMrRQKOiQ08LuMiOqV6BgXkaevkcNxqJlm5JtzxBy-q3oxuoWHQr9OQpoe9ONU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrfeduuddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhtgfgggfukfffvffosehtqhhmtd
    hhtddvnecuhfhrohhmpeflrghmihgvucfotgevlhihmhhonhhtuceojhgrmhhivgeskhif
    ihhiuhhsrdgtohhmqeenucggtffrrghtthgvrhhnpedtudevgeejkefhjeeuvddufeegud
    ehffefvddtgeejleejtedttdegveejhfejvdenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehjrghmihgvsehkfihiihhushdrtghomh
X-ME-Proxy: <xmx:noC7Ze6kMhhzkM6DtPlkvcg7ImFO7LUTQiYrdIme1oQPsD2U3i_Ang>
    <xmx:noC7Za7RaXnwik7DNsylbb6u2QOtN-UTTv2Tcy_yRrEbiskx7qJ5Yw>
    <xmx:noC7ZWg3v3XtEIoLP3wXJGrdzmXUDIkj6krWxGbl8SIRm3PWN2LqLQ>
    <xmx:noC7ZXU5NBh9AfqmHmj_cPeTbTYlEhONVZfJMxH2ohAW0_CMhGQXjw>
Feedback-ID: i0a19459c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Thu, 1 Feb 2024 06:29:33 -0500 (EST)
From: Jamie McClymont <jamie@kwiius.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: `bcachefs data job` -b option is unreachable
Message-Id: <5E3C162C-8918-4083-917F-200C2C7A5DE1@kwiius.com>
Date: Thu, 1 Feb 2024 22:29:21 +1100
To: linux-bcachefs@vger.kernel.org
X-Mailer: Apple Mail (2.3774.300.61.1.2)

Hello!

I was attempting to invoke drop_extra_replicas on only my metadata =
btrees by repeatedly invoking `bcachefs data job drop_extra_replicas =
/path -b $tree` for each metadata tree.

I was unsuccessful, as the `b:` flag is missing from the getopt call:

c_src/cmd_data.c:
        while ((opt =3D getopt(argc, argv, "s:e:h")) !=3D -1)
                switch (opt) {
                case 'b':
                        op.start_btree =3D =
read_string_list_or_die(optarg,
                                                __bch2_btree_ids, "btree =
id");
                        op.end_btree =3D op.start_btree;
                        break;
                case 's':
                        op.start_pos    =3D bpos_parse(optarg);
                        break;
                        op.end_pos      =3D bpos_parse(optarg);
                case 'e':
                        break;
                case 'h':
                        data_job_usage();
                }

My problem was solved by just running drop_extra_replicas over =
everything, which I assumed would be slow, but which was in fact far =
quicker than figuring out why -b was broken :)

Thanks
- Jamie McClymont=
