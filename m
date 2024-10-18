Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1520E33E
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 23:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729295409; cv=none; b=qOT7iUn77yosnw+dfEpAValBz0amNKkALsZyFRvLexnZBVr0kSo+jDRRUdowlqH96NnqhYPEJkOYGK10bIgEetqJ93nUZ7y7r/AW81G60Iv4HWGH61d/9HurxIUfo811cLfTSioyGEWE/oO8s05FrnM6Nnzt2GSQAwYwNaU1BwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729295409; c=relaxed/simple;
	bh=HsEG6Iu8yauhZwix3zTx/fRiGSwC4B9riLlKK7/Pjdc=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=WuygBr9GGXjW5rnfiZ3K6m3HNlg33tKCELMRXm2DTZGSiTC2r4SR57D58AIWyvlF+lzOJc/zMYzaCdmXeZHRn9Qe22uFRqcDy3HTXO6+Rc7O5AyogSX3wrPrtEvaYtU4ItSAQHPEi2hhs5tOxJ1jvOLXonfPQbtppFL1VhyR+rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com; spf=pass smtp.mailfrom=kwiius.com; dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b=Uvjl9f5W; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FQwnD6l6; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kwiius.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b="Uvjl9f5W";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FQwnD6l6"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id BEA011380277
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 19:50:05 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 18 Oct 2024 19:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kwiius.com; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1729295405;
	 x=1729381805; bh=HsEG6Iu8yauhZwix3zTx/fRiGSwC4B9riLlKK7/Pjdc=; b=
	Uvjl9f5WFfO7zgITRCjN4BbhdM3T9l7NFISbKQY7MJEHTnFSwfLE2loIfwwsVGs9
	uq+eHoI53MxdInHrBQkdTkgx012IIyVdSsDTdL0yxQGsUCUhx+XMxQ7g7E1SSrQV
	0TLN3OZxlnpI1UIUhQNNyLhvrICCo+GC3LLFmOvzkfz/mzozauD+LM8A2Ba2cG82
	cNdZM2B4m3TuPS/suK+mJCqA3RpNQDLYIJU1f5k3OB52PTSqlhgQCTjEumXHxj7m
	fndgjVroprv4/bnwFZSvV54upEV2DwJehkGPtnyRRohJNRhsHYBuY4yXHip1K90j
	9C8zBQywlmJoGPkDt9Pgdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1729295405; x=
	1729381805; bh=HsEG6Iu8yauhZwix3zTx/fRiGSwC4B9riLlKK7/Pjdc=; b=F
	QwnD6l6T1Rp9TR9+f+3fE7X9OsZcZJgUDkMJYcSDwPnda9L8Qft51AkWVMgZ4Gj3
	cSKM2IxtbUGSfn1RDfAsM3BYnMMFv2QYFWLo5RZmRY8mA2/7a0t8BYNlaDit0bIF
	WPwFnlUeQukIH+8YJA2Cmjy0jU00ncvZsO7t7SdgfY6jNRoUflAyXcY2Sy2XaQ//
	bIN/QbdPPEOkBf8WS/giU+ygOVmSUcCOtWXlfTXzOOZsmMlKQ63WHcbS+Gf1emIz
	A7TWl7D40OszwZVUHKybJzknH9mP5MYBdzJu/eXDaS76vka9omgWn2NLzUzKd2AQ
	xh4/ToID9lWSInA7szrag==
X-ME-Sender: <xms:LfQSZ7zgFKfSFySxo0xw4WEbgIPRQnJezsf-HUDxRjvElTyv1gKgxw>
    <xme:LfQSZzS0EmOQcSaZNTAU0Vt1UjiHOhCxjxD8BIC6Jqg2uQlZU1NG-IAvU9mMcUb6J
    tvN7OLpN_N945dDsQ>
X-ME-Received: <xmr:LfQSZ1XKLSyZUGLhocfmTXk9DrmXfaM-mOD8ByGvxAXI-axvAgk3rOpDq6051EREntQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehgedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefhtgfggg
    fuffhfvfgjkffosehtqhhmtdhhtdejnecuhfhrohhmpeflrghmihgvucfotgevlhihmhho
    nhhtuceojhgrmhhivgeskhifihhiuhhsrdgtohhmqeenucggtffrrghtthgvrhhnpeffle
    dtjeeggfegtdeggeegudeugfetteeuvdeitedvhfekudehffdthfffffefffenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjrghmihgvsehkfi
    hiihhushdrtghomhdpnhgspghrtghpthhtohepuddpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:LfQSZ1jwhnQP81tkIZFtruVvODX1q45wgwjESuWo9lTUbrPV7eSj6g>
    <xmx:LfQSZ9Apx_Z3w2BTfKyXw_vCbrZ2d5D9AvXS4CzrJLMY3I8Vy0-C7w>
    <xmx:LfQSZ-JJBG9nGRUun9yRTW67GGHVvj69ENu_WjLo5MEqNRNdJ1VNqQ>
    <xmx:LfQSZ8ASKqoxwr5YsM9h1zRvziSWm_qRQhGO0gbPZ4mzzFpRq5Mlfg>
    <xmx:LfQSZ66uulT9WBD6qA-ssyXCbJ2Q3meqwbj6kPr2CEl71aNzAvu1CB79>
Feedback-ID: i0a19459c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 19:50:04 -0400 (EDT)
From: Jamie McClymont <jamie@kwiius.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: "accounting not marked in superblock replicas"
Date: Sat, 19 Oct 2024 10:49:52 +1100
References: <2C607C54-0D65-458B-83B2-9C769216CC23@kwiius.com>
To: linux-bcachefs@vger.kernel.org
In-Reply-To: <2C607C54-0D65-458B-83B2-9C769216CC23@kwiius.com>
Message-Id: <B33B574D-B679-4C8D-B7CB-317A0AFF0C17@kwiius.com>
X-Mailer: Apple Mail (2.3818.100.11.1.3)

Nevermind, looks like this is something userspace fsck can fix =E2=80=93 =
I had falsely come to the understanding that the kernel could now fix =
all the same errors :)

Thanks
- Jamie=
