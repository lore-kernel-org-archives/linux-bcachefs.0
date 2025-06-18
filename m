Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6784828682
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283708; cv=none; b=qKCy3erTGqBqUbYrBRCHoq0ejpysMdqpGJoFMdvNCqTMQa88stWhzCkXLy8QvSLmpNbS5149GfyIRfsYdstPeEP1p11J6EUFxSog81Iolz+hRinWmJEffqInXrwYduJU49U9aM+lzCcxBeG4/YjRjRjRKnRVxKt7CQKAEK1dZKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283708; c=relaxed/simple;
	bh=sABytz30/0ipPWV4zHIUp/lHZjMGvjcLpAZLXfIple0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5y4xJBh3TdGJBuPWwEhr/P3ahrBwrbB3b3+cHPgYwnxI55J4C2ry44ja0EGIiya4jN0ZPdboWwcOpQtN49bJv5eXNlT31TTMx0anYbl/9r1kN9MWuDMKaCFprUehjVrE5e+AROfXuKqDtw7WpowJq+rPEhKB8wlgkvtIcOBfMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TYRuC2/F; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TYRuC2/F"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k70mUizpwUhfG8eHWYKBHXCeLaA+F4CkSQarX1q5HXg=;
	b=TYRuC2/FEyaqwtoN5HzfkJkpaWXHYiJpkK2Lom7QMe6i/NqnL7luLrGef45jKyXNq4Ezpe
	YvwN5y21MWUt21SbYcB6HAQD8MQwTEfJ7sHkq4s/zcjDLTTJN3Xdxa4dsQg+MOmw9U7vrc
	38LdY8gG5nR/FifcQKo5etb6dKFM4Ic=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 24/37] bcachefs: fsck: Print path when we find a subvol loop
Date: Wed, 18 Jun 2025 17:54:15 -0400
Message-ID: <20250618215431.738317-25-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index f25d33fb3e23..0d87aa9b4f23 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2578,6 +2578,11 @@ static int check_subvol_path(struct btree_trans *trans, struct btree_iter *iter,
 	if (k.k->type != KEY_TYPE_subvolume)
 		return 0;
 
+	subvol_inum start = {
+		.subvol = k.k->p.offset,
+		.inum	= le64_to_cpu(bkey_s_c_to_subvolume(k).v->inode),
+	};
+
 	while (k.k->p.offset != BCACHEFS_ROOT_SUBVOL) {
 		ret = darray_push(&subvol_path, k.k->p.offset);
 		if (ret)
@@ -2596,11 +2601,11 @@ static int check_subvol_path(struct btree_trans *trans, struct btree_iter *iter,
 
 		if (darray_u32_has(&subvol_path, parent)) {
 			printbuf_reset(&buf);
-			prt_printf(&buf, "subvolume loop:\n");
+			prt_printf(&buf, "subvolume loop: ");
 
-			darray_for_each_reverse(subvol_path, i)
-				prt_printf(&buf, "%u ", *i);
-			prt_printf(&buf, "%u", parent);
+			ret = bch2_inum_to_path(trans, start, &buf);
+			if (ret)
+				goto err;
 
 			if (fsck_err(trans, subvol_loop, "%s", buf.buf))
 				ret = reattach_subvol(trans, s);
-- 
2.50.0

