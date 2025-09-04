Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D03D230BCE
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756963323; cv=none; b=RhN4MrRNmkctpgyQg3sRUIbxax5o69QF40GTuwCpiI2FhZBOm8YP8WYDun3rUgBXsCDse2/n/wFN4kt8xmEL7JeTfcYS0jsasVUJOi2eQzfWLOkhYCuq9bMRq51vE4Cy+CMpf4iPB03hkxOMHVqDctAqRb6Zsl++yiWqBaipeFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756963323; c=relaxed/simple;
	bh=yQX29juDrVhppokAxY4Z2ClyzbS+5MpXyED5GMR5XmY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K/b6WtbLaJRma8KQpXV/VB6wBExfliB3tTFYEwF1obxz7tZZq1rNbTI9GQ8eteUwJMFeQbod6OVkZeyn/8WARLhgshcj6zNAaT/jRKOwFazOBarxxGBKbLBagR/m2rlES4B1Ytg7cXwlxAImsXPW34TRct4pHOOd7ls39JU7ok0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rtM9ylz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rtM9ylz8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43266C4CEF6;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756963323;
	bh=yQX29juDrVhppokAxY4Z2ClyzbS+5MpXyED5GMR5XmY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rtM9ylz8hUa5YfKMFp876wy0z1h2Gd9m75GQOI/owKNJnaWiKSL3Wo/gW+UJTfMva
	 6qG6omc+j0KlTl6Fxe4dm82oxhvMwTaxfF7V29oTA8a4OTnfHQvwjYykSb/UYc7mPi
	 SWKR3X2s9c7WjesotaKKKRpeTfrGIrImLfIjZMYOvmytmOeEckHhrJBF+ASOHZr5SZ
	 GTMo/Fa/o85+A/UYgOQH2k8X/ZnOg4/ROkTsY6NJlNM3DJFojMxnOtsiIJdUzrBFdF
	 tC3bam5/Xfkutq1lgTOUbC22vJMlL2b6z+iPs2RNKC5oOkNZffoiZBrsw6ixnGigxc
	 ONHx00/PIUdKQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE11CA1017;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 04 Sep 2025 08:20:33 +0300
Subject: [PATCH v3 2/7] bcachefs: Fix online hidden (sb+journal) data
 accounting
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250904-better-progress-v3-2-6cc4edf543f4@gmail.com>
References: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
In-Reply-To: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3023; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=wd9BYmDrNSwQaAk+E9Fbl96RQ0Zy/3q0CxOTVWJm0wg=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWTsVPyxP+jxn+3xbKoZNnuML+2Xdo8T710pYHn/wmHzo
 yECMseMOkpZGMS4GGTFFFk+LPn6Z02m9R9Lob2GMHNYmUCGMHBxCsBE7m5n+Kft59Lx+u7Jnp8O
 BbesDJh87Y7+PLeaw+fMc/MaruI2+XeMDFfsvzY4ZrBHvdFIrO22lnn86WeZDIe+iPKVx1zfFN+
 v4gYA
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Now the c->usage->hidden counters are kept up to date by the same
trigger-based mechanism as the other ones.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/disk_accounting.c | 12 ++++++++----
 fs/bcachefs/disk_accounting.h | 10 +++++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 17408c03604547fcdff8f1cc4c8c40cf818eabfd..f09e43f78f13fc424d9bf22d94566d4961c8ca8e 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -1097,13 +1097,17 @@ void bch2_verify_accounting_clean(struct bch_fs *c)
 		case BCH_DISK_ACCOUNTING_dev_data_type: {
 			{
 				guard(rcu)(); /* scoped guard is a loop, and doesn't play nicely with continue */
+				const enum bch_data_type data_type = acc_k.dev_data_type.data_type;
 				struct bch_dev *ca = bch2_dev_rcu_noerror(c, acc_k.dev_data_type.dev);
 				if (!ca)
 					continue;
 
-				v[0] = percpu_u64_get(&ca->usage->d[acc_k.dev_data_type.data_type].buckets);
-				v[1] = percpu_u64_get(&ca->usage->d[acc_k.dev_data_type.data_type].sectors);
-				v[2] = percpu_u64_get(&ca->usage->d[acc_k.dev_data_type.data_type].fragmented);
+				v[0] = percpu_u64_get(&ca->usage->d[data_type].buckets);
+				v[1] = percpu_u64_get(&ca->usage->d[data_type].sectors);
+				v[2] = percpu_u64_get(&ca->usage->d[data_type].fragmented);
+
+				if (data_type == BCH_DATA_sb || data_type == BCH_DATA_journal)
+					base.hidden += a.v->d[0] * ca->mi.bucket_size;
 			}
 
 			if (memcmp(a.v->d, v, 3 * sizeof(u64))) {
@@ -1131,7 +1135,7 @@ void bch2_verify_accounting_clean(struct bch_fs *c)
 		mismatch = true;								\
 	}
 
-	//check(hidden);
+	check(hidden);
 	check(btree);
 	check(data);
 	check(cached);
diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
index 438628b63a8065e22ec76aebcd69e285f84f41ef..c3f2dc5d0c14241f3c0ae2d367d6da504df2e1ab 100644
--- a/fs/bcachefs/disk_accounting.h
+++ b/fs/bcachefs/disk_accounting.h
@@ -186,11 +186,15 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
 			break;
 		case BCH_DISK_ACCOUNTING_dev_data_type: {
 			guard(rcu)();
+			const enum bch_data_type data_type = acc_k.dev_data_type.data_type;
 			struct bch_dev *ca = bch2_dev_rcu_noerror(c, acc_k.dev_data_type.dev);
 			if (ca) {
-				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].buckets, a.v->d[0]);
-				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].sectors, a.v->d[1]);
-				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].fragmented, a.v->d[2]);
+				this_cpu_add(ca->usage->d[data_type].buckets, a.v->d[0]);
+				this_cpu_add(ca->usage->d[data_type].sectors, a.v->d[1]);
+				this_cpu_add(ca->usage->d[data_type].fragmented, a.v->d[2]);
+
+				if (data_type == BCH_DATA_sb || data_type == BCH_DATA_journal)
+					trans->fs_usage_delta.hidden += a.v->d[0] * ca->mi.bucket_size;
 			}
 			break;
 		}

-- 
2.50.1


