Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21422215044;
	Thu, 27 Mar 2025 12:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743079975; cv=none; b=SR/fQrWqGtv2uS0PNicDtj872CyO/5PGW0SQuSXoOIqvEDVTRM/MWzIdfOpUei2Ya1h8YafArZtRdLSf1f25hcNthJz1hXbvp95aKMfpwIOr9sY1dQEeZGU2j4W9BfaWZZZU6DN1JZTpjuhMJGRYkXF0KRDpHNBUAflQD2HjKzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743079975; c=relaxed/simple;
	bh=y+dNdt31+vy08/TWIUqkOmDZKgyr9J8hDr4RBIpTPYQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S1xeBUNY13F89Qhnj2Z0swt4gfquRdKCj9L0RIiqaNa+hZJVOJ9o+KNlwwWqgLhQs/i7ZLZX6wiINEUnJRojG5nvFIDF9QsmxRB4FEJ662+ZY/bohvfk4YX1h7Vvv9PzxT51u+KxOptG3WeyXRBOmxFi/wwP2HQ8fl3+XdSpw7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=RKIxJ5+m; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="RKIxJ5+m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1743079967; x=1743339167;
	bh=PFXXGDMbpQFvQ/hQaIEg3jpMkWzB+T8hkAladjtD21o=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=RKIxJ5+msuE6Ftp1RsI3vPe9dD9+TuIKfoubfLDOeIxsRFhWtsFr8EmLRq79tWZR2
	 XntC+tRdUDlDYmm83nJLOqYEXAE6gJSWsv1fGfqQGRhgWPMq7FUh9uYEBTLpX9sArL
	 FjhgBfALPWPzBlxNrv2yC427xb45ixSvR/LxTThf+XzvmKRL/5If/Lv8fVGBmirkw3
	 99d/j+Al8iGdfNA+35+0Pq8ODTyW54EPmVu0dhlgOhH2R2tpFI2b6pRQtI2QfnAg1/
	 yFpTIIJ4WFhuzCxnfBNfW3HLLX4rkrOmvz4WRMBoelYmhMgOzdC5X0Mp+JRa6BVhZD
	 q5dtdp72mkhyg==
Date: Thu, 27 Mar 2025 12:52:42 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: mmpgouride@gmail.com, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: [[PATCH v2] 1/2] bcachefs: replace strncpy() with memcpy_and_pad in journal_transaction_name
Message-ID: <20250327125235.1958273-2-nicolescu.roxana@protonmail.com>
In-Reply-To: <20250327125235.1958273-1-nicolescu.roxana@protonmail.com>
References: <20250327125235.1958273-1-nicolescu.roxana@protonmail.com>
Feedback-ID: 136600343:user:proton
X-Pm-Message-ID: fd26c65caada514f8c5ab8f78c74d0af20dabd2c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Strncpy is now deprecated.
The buffer destination is not required to be NULL-terminated, but we also
want to zero out the rest of the buffer as it is already done in other
places.

Link: https://github.com/KSPP/linux/issues/90
Signed-off-by: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
---
 fs/bcachefs/btree_trans_commit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_com=
mit.c
index c4f524b2ca9a..794b70cc98d7 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -364,7 +364,8 @@ static noinline void journal_transaction_name(struct bt=
ree_trans *trans)
 =09struct jset_entry_log *l =3D
 =09=09container_of(entry, struct jset_entry_log, entry);
=20
-=09strncpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
+=09memcpy_and_pad(l->d, JSET_ENTRY_LOG_U64s * sizeof(u64),
+=09=09       trans->fn, strlen(trans->fn), 0);
 }
=20
 static inline int btree_key_can_insert(struct btree_trans *trans,
--=20
2.34.1


