Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330401DB442
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Aug 2024 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723712291; cv=none; b=BD2sytYekWIrNZaqFBEFsjgmasFCJBcpBsROwa0XHwMfJSZOpwUuGsZoBEuPjWA+B0i+c0xnf2x2HpGI+F47qI/73/iNlMd41gpoFpoJT1ztr6nX8Wiv1g7j/B8hgxEREXuFapr9NjpZP5xQVq+ckwdhvs4F0ihHYN6HHCLSMTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723712291; c=relaxed/simple;
	bh=KRx7wmSdhjanM7hrHBPThs8AQLRMQFRVlPAECjcB2PM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LVmBZdwEzKmGfhzfPbnlcaCUGsKDD1WYEUKTKIvbpwT1N0ewpJpbX07MyqHcn1Kwg6ji9P7OwpEW0QpJp9yy+C/2dE2058TICJ8ll7m0kGd/FIKDWa1Rt9tPivI9BEWR9c8oz/If2IPulwbBQAVN7f/KCs4HuYhNBb8MNRHBNA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mCaUsI+2; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mCaUsI+2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723712286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oKn02HYe5r+8UUPEpvU95NDzA4gCmR2BDgfjmPF8E7Y=;
	b=mCaUsI+22EPFq7azpdaN+FYd43ubxN+CYQbKY5eStqBvnmBA4RV0z9WXziY8Zzc3Pui8XB
	IGka3fBdZhb8QySmUUJxM8iBziT20+Ix6va6NC94Lj5qTs/ngXwVj9FqWoIpFpqrj0Z5jM
	yB0F6/fA0REe+xWHg+77YzLdYFREgjk=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 1/2] bcachefs: drop unused posix acl handlers
Date: Thu, 15 Aug 2024 16:57:43 +0800
Message-Id: <20240815085744.224879-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Remove struct nop_posix_acl_{access,default} for bcachefs filesystem
that don't depend on the xattr handler in their inode->i_op->listxattr()
method in any way. There's nothing more to do than to simply remove the
handler. It's been effectively unused ever since we introduced the new
posix acl api. See [1] for details.

Link [1]: https://patchwork.kernel.org/project/linux-fsdevel/cover/20230125-fs-acl-remove-generic-xattr-handlers-v3-0-f760cc58967d@kernel.org/

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/xattr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index c11bf6dacc2c..9e77e949a29b 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -623,10 +623,6 @@ static const struct xattr_handler bch_xattr_bcachefs_effective_handler = {
 
 const struct xattr_handler *bch2_xattr_handlers[] = {
 	&bch_xattr_user_handler,
-#ifdef CONFIG_BCACHEFS_POSIX_ACL
-	&nop_posix_acl_access,
-	&nop_posix_acl_default,
-#endif
 	&bch_xattr_trusted_handler,
 	&bch_xattr_security_handler,
 #ifndef NO_BCACHEFS_FS
-- 
2.34.1

