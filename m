Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C1E22087
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Aug 2025 03:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754709599; cv=none; b=boQ9/G+ekqK47fOPS9LH18Pp4CQOKR5FfqyzxMAym7o7ClKBiDw1oD7AXLVV6CcmL4WazhmglEyIygf0q5dy7rYHgTrKJXn0v//gsLJei5zq81u5Y0O9N9xG+aobKZGC3z0ZNw0vFiSIdQ9utdS0BRObdK+V5xxnoO9DClFaHq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754709599; c=relaxed/simple;
	bh=mY3TLGZbMkSoYYE0DGIkn6HRqEvPgJdZgudTrYrJrOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ExfOe0Xfx7r0wiLY7jbTNHvo5BRpvmycB4wCZMaY5/UO06kRo3F5hlQKKMmlBzXnaOHqlwmR4hM4TxmWQTFoJeokR/k8K2pP6pxtrf3Cc0hhcneprhXdWc/DUn7VMW3LiOYeyruV9foJudOZM85m+/j/SdiFFE/l+FL0ljB34Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CnYlz5gi; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CnYlz5gi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754709593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HVJPaBr5969xuOuN4Bc1FTTY1Li7hKdeGwmNfcRxo4o=;
	b=CnYlz5gioIUFXlLXnecOg+X/NOQ4AYXVwuFpFfH6rWQsgLyyWojZMFPbYPlfFcZq35a8Ni
	hiud0j3RU28NSxaOHpwE07QODzwcQUlCMLs5nm75QNstkw84PYvo1eoc01RYWURKxVJfAV
	/nDoeHoB3arnawjse5tSkwe31dwOS24=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] bcachefs: fix build on sh4
Date: Fri,  8 Aug 2025 23:19:44 -0400
Message-ID: <20250809031944.1579293-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

put_user() with a 64 bit value causes an ICE on sh4.

Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/sb-counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb-counters.c b/fs/bcachefs/sb-counters.c
index 2b4b8445d418..9fa2c568c985 100644
--- a/fs/bcachefs/sb-counters.c
+++ b/fs/bcachefs/sb-counters.c
@@ -136,7 +136,7 @@ long bch2_ioctl_query_counters(struct bch_fs *c,
 				? percpu_u64_get(&c->counters[i])
 				: c->counters_on_mount[i];
 
-			ret = put_user(v, &user_arg->d[stable]);
+			ret = copy_to_user_errcode(&user_arg->d[stable], &v, sizeof(v));
 			if (ret)
 				return ret;
 		}
-- 
2.50.1

