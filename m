Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2B911CBA;
	Wed, 30 Apr 2025 01:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745975749; cv=none; b=P/LGacxSsZIA6FMJbQjwS9X857lxS5UcobF1zpVJEUDwWl8NSMxo5yKDEQ5YsUlX5y8nU1EG9B/OOf0wbwsVrLXmV5fvKRT+Vp1PVFBdcjgSPKwvEHN/OqsXKC9NTieZxfrivo4Cyx6xI2Dr7m5UsXdiYkT22frjP+IlWpzvGUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745975749; c=relaxed/simple;
	bh=sxuS/iLDa6y63+kvsd/xKcfeV5zpkOM3spC2l/GdlKg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Z/4Rh0z5b7XMW4uvj2Jy9em+VCCvl1sFXv+lNZAjD7Km5MDPnMjhp832nhiRFWCAsY33yGUF7g97LWzsPK5ptkpCso5FnQp9UErTIuOsGR852DGsHHc9r7FFzjbB8zNXsMoVWI6gWcVlDJfeESN235yHk6VpxtBnvvNvEngBqQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuD4OJyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuD4OJyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41436C4CEE3;
	Wed, 30 Apr 2025 01:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745975748;
	bh=sxuS/iLDa6y63+kvsd/xKcfeV5zpkOM3spC2l/GdlKg=;
	h=Date:From:To:Cc:Subject:From;
	b=JuD4OJyt3vCwgBjSpGvACYtyGjjS73u4df41CESLl9cDBdeKaiGASfElrNwN4J4Dr
	 tCvZIwoWyekn4oWaJBfckFlpBK99b+UNYuYhnjj0uULxNcV3o4OJatVqiLkCJ0+31b
	 aFNQYLvHUArjBigO9Xv0fiu/wgudfY7hNjSpPA82YqnKJsQp/3CSnQErJcL0vblmLo
	 q+9QZomRmVffCC2YFqVpL4EBrx2f/ZbS0qcH77F6lpTw/ZqURBFVgFIxKfFheIjFcK
	 qaHuiiXJNbh6pY6Xaq3/FoeTLzKBiIbApZKrrUPW+2IPWemrWtYZzDDKkH1PJXPvzG
	 OmP0hAJfMmSCg==
Date: Tue, 29 Apr 2025 19:15:37 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] bcachefs: Avoid -Wflex-array-member-not-at-end warning
Message-ID: <aBF5udHEHwWvmWJw@kspp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Use the `DEFINE_FLEX()` helper for on-stack definitions of a flexible
structure where the size of the flexible-array member is known at
compile-time, and refactor the rest of the code, accordingly.

So, with these changes, fix the following warning:

fs/bcachefs/disk_accounting.c:429:51: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/bcachefs/disk_accounting.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 7be71952425c..381e666679d2 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -425,24 +425,22 @@ int bch2_fs_replicas_usage_read(struct bch_fs *c, darray_char *usage)
 
 	percpu_down_read(&c->mark_lock);
 	darray_for_each(acc->k, i) {
-		struct {
-			struct bch_replicas_usage r;
-			u8 pad[BCH_BKEY_PTRS_MAX];
-		} u;
+		DEFINE_FLEX(struct bch_replicas_usage, u, r.devs, r.nr_devs,
+			    BCH_BKEY_PTRS_MAX);
 
-		if (!accounting_to_replicas(&u.r.r, i->pos))
+		if (!accounting_to_replicas(&u->r, i->pos))
 			continue;
 
 		u64 sectors;
 		bch2_accounting_mem_read_counters(acc, i - acc->k.data, &sectors, 1, false);
-		u.r.sectors = sectors;
+		u->sectors = sectors;
 
-		ret = darray_make_room(usage, replicas_usage_bytes(&u.r));
+		ret = darray_make_room(usage, replicas_usage_bytes(u));
 		if (ret)
 			break;
 
-		memcpy(&darray_top(*usage), &u.r, replicas_usage_bytes(&u.r));
-		usage->nr += replicas_usage_bytes(&u.r);
+		memcpy(&darray_top(*usage), u, replicas_usage_bytes(u));
+		usage->nr += replicas_usage_bytes(u);
 	}
 	percpu_up_read(&c->mark_lock);
 
-- 
2.43.0

