Received: from mail-08.mail-europe.com (mail-08.mail-europe.com [57.129.93.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872A76025
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Jan 2026 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.129.93.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769253601; cv=none; b=aaIaAgSxZoSmUWw5ryPAFSbrbJTueQjownybxnKUlZP2ZNf7vkFSOJBGJPcuKA5++AwbstbVd4RWmoxF/8tczuj9PV4acSCr79ijafiJN8284klDNDvA5flIe84QL9SmvFr5kXEloXUS14+MTasy/DJ5SEw2/4gn/d5cKugdIM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769253601; c=relaxed/simple;
	bh=4QYLQSltzLeNPK2RZ2FA4brW4qRLbSOSSppqEkFBVPo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PhfE1kjPg4aKtl+0LjvtwzgA3rIv1NETUD9vcEGIbuPCfKcO7B+tZDo7eBmddNCR5O81LWoZJjV9jaMvh3gMZdVRx5vKzxVrSEQiLjktNv5JFBy77Fu/R1Y3Fdmk+N06xU9W9mKkY4BAa5Z50pJtOnc51PBL3kdxd66q3TSS3NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=A+ke/gjw; arc=none smtp.client-ip=57.129.93.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="A+ke/gjw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=txswjgikazcmlphbqjimdtki3m.protonmail; t=1769253581; x=1769512781;
	bh=8rv8o9h1+qO5DT93WUV7MLvbZJPdlApFDTbMmqo/KhA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=A+ke/gjwq+59SxigSud5p1gb94d6YHHmntCfzmm8M/9hJvyYU20GwagkyHY58UW3h
	 LN7OAYYabHEbK3VZebXcBiBRoO7yL4FzaisieRd3AnpFonvj3fA4j7t4PlVsKd82KM
	 DfyJec3X90M0fQj9AbHH19Gcigesucr9WGUX3mlzRHTI3nNj7q2SOfN2ljTYd/GNqc
	 2g8EGCC+8G1owB8UuBuPCqBRqdr1HxC/bpbO28+BYFss6ftYCmez0Qc0X/gRkKl3L5
	 Mm+1W6MYXusffOprpQIxjzL4vHxO8vrRUGwYVEJAtKrnuLOxZGU/DyQihWuszZ4eIM
	 Fk0fAVCMqft4A==
Date: Sat, 24 Jan 2026 11:19:37 +0000
To: linux-bcachefs@vger.kernel.org
From: Jul Lang <jullanggit@proton.me>
Cc: kent.overstreet@linux.dev, Jul Lang <jullanggit@proton.me>
Subject: [PATCH 1/2] docs: fix typo in bch2_trans_begin inline comment
Message-ID: <20260124111913.6263-2-jullanggit@proton.me>
In-Reply-To: <20260124111913.6263-1-jullanggit@proton.me>
References: <20260124111913.6263-1-jullanggit@proton.me>
Feedback-ID: 86367135:user:proton
X-Pm-Message-ID: b054903ace6ada9e8ca5a9703dedb718ac80a386
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Jul Lang <jullanggit@proton.me>
---
 fs/bcachefs/btree/iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree/iter.c b/fs/bcachefs/btree/iter.c
index 3270edc6f..f763449db 100644
--- a/fs/bcachefs/btree/iter.c
+++ b/fs/bcachefs/btree/iter.c
@@ -3435,7 +3435,7 @@ static void bch2_trans_srcu_lock(struct btree_trans *=
trans)
  *
  * Returns:=09current restart counter, to be used with trans_was_restarted=
()
  *
- * While iterating over nodes or updating nodes a attempt to lock a btree =
node
+ * While iterating over nodes or updating nodes an attempt to lock a btree=
 node
  * may return BCH_ERR_transaction_restart when the trylock fails. When thi=
s
  * occurs bch2_trans_begin() should be called and the transaction retried.
  */
--=20
2.52.0


