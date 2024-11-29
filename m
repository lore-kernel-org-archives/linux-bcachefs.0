Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3D5156C5E
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912071; cv=none; b=sJmmSnKIqeIIJ50o7gfD9VZ+SaMMQXzqOjTDNVcGq6maWI0V1e5Lf4f1xnEsjlfTEZlMvTb9ZJjNoy8njQWcLS0Z+86Wm+QDUneMgDln2EyXL7xJAmDnojiVM63Cz4pu8y9IbqOL+VohXv58EBxuHTC7YqTqPSoobPL2Wpk0OL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912071; c=relaxed/simple;
	bh=X1dQ3xN1+FbcYM4eZeVaBypxrJMIBEltjTumSgI/ekE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r30oe8qFmPyBCKlwZ79PhTTfcQikWMAvLKYb7qYIK9KEJdsaM1kRgLa7TyGGEvk4sRXJRvlmyzmmR9gaSc4EKZsrkcPsCjH/R0JE7586YPFV2eJevqqAWl5jdrtqtoFkVMhade6aK5DVYTJ/ph8wGLJNwQYzg0w3hZOz7VT+USs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/34] bcachefs: disk_accounting: bch2_dev_rcu -> bch2_dev_rcu_noerror
Date: Fri, 29 Nov 2024 15:27:03 -0500
Message-ID: <20241129202736.2713679-5-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Accounting keys that reference invalid devices are corrected by fsck,
they shouldn't cause an emergency shutdown.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/disk_accounting.c | 4 ++--
 fs/bcachefs/disk_accounting.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 55a00018dc8b..fa821d278c45 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -805,7 +805,7 @@ int bch2_accounting_read(struct bch_fs *c)
 			break;
 		case BCH_DISK_ACCOUNTING_dev_data_type:
 			rcu_read_lock();
-			struct bch_dev *ca = bch2_dev_rcu(c, k.dev_data_type.dev);
+			struct bch_dev *ca = bch2_dev_rcu_noerror(c, k.dev_data_type.dev);
 			if (ca) {
 				struct bch_dev_usage_type __percpu *d = &ca->usage->d[k.dev_data_type.data_type];
 				percpu_u64_set(&d->buckets,	v[0]);
@@ -911,7 +911,7 @@ void bch2_verify_accounting_clean(struct bch_fs *c)
 				break;
 			case BCH_DISK_ACCOUNTING_dev_data_type: {
 				rcu_read_lock();
-				struct bch_dev *ca = bch2_dev_rcu(c, acc_k.dev_data_type.dev);
+				struct bch_dev *ca = bch2_dev_rcu_noerror(c, acc_k.dev_data_type.dev);
 				if (!ca) {
 					rcu_read_unlock();
 					continue;
diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
index 6639535dc91c..8b2b2f83e6a4 100644
--- a/fs/bcachefs/disk_accounting.h
+++ b/fs/bcachefs/disk_accounting.h
@@ -142,7 +142,7 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
 			break;
 		case BCH_DISK_ACCOUNTING_dev_data_type:
 			rcu_read_lock();
-			struct bch_dev *ca = bch2_dev_rcu(c, acc_k.dev_data_type.dev);
+			struct bch_dev *ca = bch2_dev_rcu_noerror(c, acc_k.dev_data_type.dev);
 			if (ca) {
 				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].buckets, a.v->d[0]);
 				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].sectors, a.v->d[1]);
-- 
2.45.2

