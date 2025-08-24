Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E6F2749D9
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039092; cv=none; b=DQtL0Jvdt3Uh0jczdB4zHDmVIFXtP/8ECWqFqHz3V3lq1qEAArSemGF0r43XDWjJHsoDPgMs0JxmLYdyycJoZiXhz350HSNPwPJKAd3U6oPOq2CdO9W+LFeTPR1eY1yjUFo91QFL/7qta+aqHjfainfW3kRcRMrdI6vwWrbTYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039092; c=relaxed/simple;
	bh=y3hq6GKZHhqiXrr61T9nFlXBjizBwMD6kFUKTObThIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfowYEBhzXlrNxO1Hdr49ID8WTwg6VYhGEcNJzg6zJze5rxyrERpHVJhIDwWoVZwNlnDaAhx6n1Od85MDjucOvYQGpx3ma2GB5erjUVgCorrzgCwl53ETgWy+gj6EYdRS5dq3b0zScXJKcQExrzIJGtrY2gRFEFVFFikvS6HacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kBPXeiqs; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kBPXeiqs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+xWX3+o8MeepWfdkYY56uv05e/jkva0ZlrDAmc0aIQ=;
	b=kBPXeiqs4iBolqQ8bYpoY8E2VHXuthGNi7xgae8/qf5OCIB2rZeLA9HJQ2xi4NXTN2q01c
	VFVFUl7iQuXM2rPKIeZhJzjAWlFX1toJ0mFvwt6jvOgx7ePrHTb7xBJOHWV7b8m3e4unST
	KQQrbCS/2LUubfppfx2cBURJg75BB+U=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/21] bcachefs: opt_change_cookie
Date: Sun, 24 Aug 2025 08:37:40 -0400
Message-ID: <20250824123800.1617669-4-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a sequence number for detecting races between when we read the io
path options and when we do the btree update with the new extent.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h | 2 ++
 fs/bcachefs/inode.c    | 2 ++
 fs/bcachefs/opts.c     | 4 ++++
 fs/bcachefs/opts.h     | 3 +++
 fs/bcachefs/xattr.c    | 3 +++
 5 files changed, 14 insertions(+)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 16d08dfb5f19..7eb8b8f37f95 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -807,6 +807,8 @@ struct bch_fs {
 	struct bch_disk_groups_cpu __rcu *disk_groups;
 
 	struct bch_opts		opts;
+	atomic_t		opt_change_cookie;
+
 	unsigned		loglevel;
 	unsigned		prev_loglevel;
 
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index b7fcdb76483c..c1d673374e02 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1239,6 +1239,8 @@ void bch2_inode_opts_get_inode(struct bch_fs *c,
 	BCH_INODE_OPTS()
 #undef x
 
+	ret->opt_change_cookie = atomic_read(&c->opt_change_cookie);
+
 	bch2_io_opts_fixups(ret);
 }
 
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 10d472d3e7d1..16d210cbc849 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -606,6 +606,8 @@ void bch2_opt_hook_post_set(struct bch_fs *c, struct bch_dev *ca, u64 inum,
 	default:
 		break;
 	}
+
+	atomic_inc(&c->opt_change_cookie);
 }
 
 int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
@@ -810,6 +812,8 @@ void bch2_inode_opts_get(struct bch_fs *c, struct bch_inode_opts *ret)
 	BCH_INODE_OPTS()
 #undef x
 
+	ret->opt_change_cookie = atomic_read(&c->opt_change_cookie);
+
 	bch2_io_opts_fixups(ret);
 }
 
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 9e0c73b7bd3a..2425ba247201 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -674,9 +674,12 @@ struct bch_inode_opts {
 #define x(_name, _bits)	u##_bits _name;
 	BCH_INODE_OPTS()
 #undef x
+
 #define x(_name, _bits)	u64 _name##_from_inode:1;
 	BCH_INODE_OPTS()
 #undef x
+
+	u32 opt_change_cookie;
 };
 
 static inline void bch2_io_opts_fixups(struct bch_inode_opts *opts)
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 6d7303008b19..de72a735a49d 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -590,6 +590,9 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
 		}
 
 		ret = bch2_write_inode(c, inode, inode_opt_set_fn, &s, 0);
+
+		if (!ret)
+			atomic_inc(&c->opt_change_cookie);
 	}
 err:
 	return bch2_err_class(ret);
-- 
2.50.1

