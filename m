Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB3A1805A
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728749127; cv=none; b=MJisGy0ojQ9VPK+A2lFO0TIIQB4om9usyztCGU6HhfwSj3WCXz3PS66iRkxIYcQBmtN5b+b2NttnSDr8Xt7uMazNluw8Rx5MgjCqG8+CmupnPzneIkYjCEabqlzmq0YtvxBOKPV8BxXHY6JHx051D+ycdE1Fah/lS0H2SXr1LGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728749127; c=relaxed/simple;
	bh=DPtLE54kzLpFrHWIKNkTeRdEPoZWKS4VWUdS+vjudio=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HvdjZrAmRL3a6nf5gieccHOsjNInBTrZCOQrhQC9XN9L9D7ZCi6rUJ07DFYQbANJY+lBwMOgihiDoR43WIrsuPheiqEcxpuS+CoEgHZZgUBFsrsXukAmsfj+TldR/ndM06XREVpuQ0FlESRbEO9Vdm8B1IZfBdvbFYG9JLWnFuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=miNP1/e6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Y0YL0oON; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="miNP1/e6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Y0YL0oON"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 2D38D138006B
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 12:05:23 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sat, 12 Oct 2024 12:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1728749123; x=1728835523; bh=NCLI39LosraG2dPuC18P9
	FGw7KSR9F0hiDXN6ULHFro=; b=miNP1/e6HSjC27vbLYY/sDIHoOWOR8HTtDWb8
	JMM9SeeW/mfqkMoUXlFh9lV6dQs7KK92H43IszPPu0WKKVZmnb5cKMcCWbFt4m0c
	CO6ZH92Rr0E6XzIQLHm5kQ8yLEu9XMxT5HHiJ5uf+9mSUxGoR62RebqwTQoKBzrZ
	+IUsC2ChbwGPYuhDrdPb4Y2Lxn00eV2eizY7Z9NfaOUR+qBt3UH4/1nWDpnlySYv
	l8r6LVIgQ1KDkVBAbEF+xd8UDTnusXRNVAysJJ0dHLvgecAs+q1VDIE08xm4NmAW
	3ZpkkkCHpwOqb5n8MpV0tGM4xO8XGaplOw8xfiKlob24RpF/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728749123; x=1728835523; bh=NCLI39LosraG2dPuC18P9FGw7KSR
	9F0hiDXN6ULHFro=; b=Y0YL0oONeeRY1MPIBXRWoZgP143v8uMOl8/eO5JhGphN
	YPbxfACrRNLzyEnePtwT8LI8mosV5lGwaUdL1WyI25+uv5f8aS36WUvsDTyzTxoV
	7AW0RUPrpXOQIvwSp7s7WQo2htCyNq5rk2mWoW5+fzZDya5HmCntbBa5dHFvxnoL
	HlPRXfk4KOOnXg4PA8rIVkoe1+KZf6kzRSEYsOjcTd23GA83TF+u23tLv59enCvW
	VomwUv7HlfWPKLSbw1s8eIkeWRzMQbG6Y3P2g1cGT6ZlL9fAYfLSJn3l/EDnRL1H
	+pKrMUIJougowptoHG5EB0rgzKxYwO9hH9ov9exx4A==
X-ME-Sender: <xms:Qp4KZ1plHKAF1PwvPcoNOTySM9ASv9SHrCNMtZZgnBJVfUVQIKPCeg>
    <xme:Qp4KZ3ofFHJcTw67DWyjEV82xx11kgHALv7yonQwNDAC1VPlOoIWn7KE2ZKCbc41T
    0-BY4k8dwXu66szaA>
X-ME-Received: <xmr:Qp4KZyNbsW6eSTAs_ZGfbTEYG41b4yurnRFHQcWeIKhkyKkoB0ssEwG9qCYNBcHxtdCM4U17hsCt4pAU-PDVpBiM3to>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeguddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefhvffuff
    fkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgrucftohhsshcuoehhihes
    rghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepleejtdeiffegveejuedvkeevie
    etkefgleeuleehfeduleekueejffeikeeggfeinecuffhomhgrihhnpehgihhthhhusgdr
    tghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepuddpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhg
X-ME-Proxy: <xmx:Qp4KZw6sjBxc3k_lSnNZXw1PZIzbFMAuPvMub5MZuL3o27Y98pe_bA>
    <xmx:Qp4KZ06apYe11SN0ZWCAkkKZLH-5DCPInarxEny3GPe6_TXeXsPNlw>
    <xmx:Qp4KZ4hj8-5MbM90DqVmZKz-F-n66GM-jOYsuFkN0Wi7ZFPoCEHXKQ>
    <xmx:Qp4KZ24iC432y4BaYyg6gwMtDGxifvRi_ukCKrxqdINBQXQSKW7SBg>
    <xmx:Q54KZyTrW7jJnHH3LAMneM-i8dqf_ruTtgkGkP-OImRDoYbzh6qCx9IX>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 12:05:22 -0400 (EDT)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id F255B382357FE; Sat, 12 Oct 2024 18:05:19 +0200 (CEST)
From: Alyssa Ross <hi@alyssa.is>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH bcachefs-tools] Avoid static linking conflicts with libblkid
Date: Sat, 12 Oct 2024 18:03:44 +0200
Message-ID: <20241012160343.239143-2-hi@alyssa.is>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When static linking, it's not possible to have two functions with the
same name in different libraries:

	= note: /nix/store/s2cjhni3s6shh0n35ay1hpj8d85k44qk-x86_64-unknown-linux-musl-binutils-2.43.1/bin/x86_64-unknown-linux-musl-ld: /nix/store/zwid05lzfy46k32xljb2alh0gq7ys58a-util-linux-minimal-static-x86_64-unknown-linux-musl-2.39.4-lib/lib/libblkid.a(libcommon_la-crc32c.o): in function `crc32c':
	        (.text+0x0): multiple definition of `crc32c'; ./libbcachefs.a(tools-util.o):/build/source/c_src/tools-util.c:484: first defined here
	        collect2: error: ld returned 1 exit status

Work around this by avoiding a known name collision with a function in
libblkid.

Closes: https://github.com/koverstreet/bcachefs-tools/issues/311
Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
If this is too clever we could also just rename the function without a 
macro, but I thought it would be confusing if callers had to remember 
that this one function needs a bch_ prefix but none of the others do.

 c_src/tools-util.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/c_src/tools-util.h b/c_src/tools-util.h
index 269d589b..572aca05 100644
--- a/c_src/tools-util.h
+++ b/c_src/tools-util.h
@@ -174,6 +174,8 @@ struct fiemap_extent fiemap_iter_next(struct fiemap_iter *);
 
 char *strcmp_prefix(char *, const char *);
 
+/* Avoid conflicts with libblkid's crc32 function in static builds */
+#define crc32c bch_crc32c
 u32 crc32c(u32, const void *, size_t);
 
 char *dev_to_name(dev_t);

base-commit: b34d1341919c4edd3251c7f69c2588acd1196d71
-- 
2.45.2

