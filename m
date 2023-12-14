Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwDzLYH5"
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB162115
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Dec 2023 11:07:26 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-35da85e543eso31696025ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Dec 2023 11:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702580846; x=1703185646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hg1ElwjLI5goom4XMAq4n45P7e2k9dnWHCP8SFBE2fQ=;
        b=LwDzLYH5UXB/oiszFulU6hOO1T8kNi4IiQb+w3FwCWt9Z+BAv7uzwUdGz9Sjz4tyHh
         AcxP/oXu3DYyD8TjQcyNW40JpPt3ZPqr2SRXMmLfXzPOUBlIZYbSiYRE5WhNC8PpiocJ
         wnnzkyQCFfc/v6cZ0NO8yWbSvODdXcoQyK8l8yfyKQa5K8ST8V39BUnAL1y5vsH9QrLk
         G8cqXUZGy+fnZyh9PPJNtE4JFU1tUOoWRGFXPURMpe4bgAdUajJ+l8pPJm2o69quwGdE
         b/rnR0ev92kzPVmeMGosRg/F/p68cfJ+9hhbMleVcfkh7F3LAC4cT9zXAUAPf+GROA28
         EKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702580846; x=1703185646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hg1ElwjLI5goom4XMAq4n45P7e2k9dnWHCP8SFBE2fQ=;
        b=VeOVNnS/kwf8zC+ZHpgYPXjO9itWKsExe4RRlqKH4hLi6clM5IuQDAWWwxtK9fVU7s
         IqC7PrIdTtcoxEhDdWhQqIsR9lq7rz4rmrEBPuoTxpbJCfp6imIuiDEQKo3oKMnavQhb
         IHsu3cBzKxcLu06Li7fHKsbz9jh8PJGlLbInUBLNu30URCpe0xYArtqOZ2K8PE1odwkT
         PVfxoBJtLjZsUUDFz9Q4BFS1aRcdAzNaRpi20Jgo70cGyWoM0xRXYFJP8RbwDD71XXii
         W95S/Wx+Fcl0sh1aiAbtUia+HiRC2ishgAONVJLz9pOkVQgOI4Wc6V+GSddTuOZmpMQo
         He+g==
X-Gm-Message-State: AOJu0Yz6vWy4fISvUp6a+igDwccQM2dR3AwAlYqbXJ3LqUOFYgabVezH
	7Gj7ADaID0Sp/Ybb64jCeu4=
X-Google-Smtp-Source: AGHT+IHlXaVVi8EAucOG59umoW0/FILyOWqqpoOH9AMjcPk0ejIHQ48aPeiTig0PBhcZP1iKUapnaw==
X-Received: by 2002:a92:c242:0:b0:35d:57f7:b27a with SMTP id k2-20020a92c242000000b0035d57f7b27amr13145942ilo.23.1702580846207;
        Thu, 14 Dec 2023 11:07:26 -0800 (PST)
Received: from fedora.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id t1-20020a92c901000000b0035ae9f62692sm50733ilp.88.2023.12.14.11.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 11:07:25 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] bcachefs: fix invalid memory access in bch2_fs_alloc() error path
Date: Thu, 14 Dec 2023 12:06:41 -0700
Message-ID: <20231214190641.230598-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When bch2_fs_alloc() gets an error before calling
bch2_fs_btree_iter_init(), bch2_fs_btree_iter_exit() makes an invalid
memory access because btree_trans_list is uninitialized.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
Fixes: 6bd68ec266ad ("bcachefs: Heap allocate btree_trans")
---
 fs/bcachefs/btree_iter.c | 8 ++++++--
 fs/bcachefs/btree_iter.h | 1 +
 fs/bcachefs/super.c      | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index f6c41a8924dd..569a087f6a65 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3142,10 +3142,9 @@ void bch2_fs_btree_iter_exit(struct bch_fs *c)
 	mempool_exit(&c->btree_trans_pool);
 }
 
-int bch2_fs_btree_iter_init(struct bch_fs *c)
+void bch2_fs_btree_iter_init_early(struct bch_fs *c)
 {
 	struct btree_transaction_stats *s;
-	int ret;
 
 	for (s = c->btree_transaction_stats;
 	     s < c->btree_transaction_stats + ARRAY_SIZE(c->btree_transaction_stats);
@@ -3156,6 +3155,11 @@ int bch2_fs_btree_iter_init(struct bch_fs *c)
 
 	INIT_LIST_HEAD(&c->btree_trans_list);
 	seqmutex_init(&c->btree_trans_lock);
+}
+
+int bch2_fs_btree_iter_init(struct bch_fs *c)
+{
+	int ret;
 
 	c->btree_trans_bufs = alloc_percpu(struct btree_trans_buf);
 	if (!c->btree_trans_bufs)
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 90e54545afff..a9277a1564b3 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -876,6 +876,7 @@ unsigned bch2_trans_get_fn_idx(const char *);
 void bch2_btree_trans_to_text(struct printbuf *, struct btree_trans *);
 
 void bch2_fs_btree_iter_exit(struct bch_fs *);
+void bch2_fs_btree_iter_init_early(struct bch_fs *);
 int bch2_fs_btree_iter_init(struct bch_fs *);
 
 #endif /* _BCACHEFS_BTREE_ITER_H */
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 893b52eda519..3a72df8a8334 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -769,6 +769,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 
 	bch2_fs_copygc_init(c);
 	bch2_fs_btree_key_cache_init_early(&c->btree_key_cache);
+	bch2_fs_btree_iter_init_early(c);
 	bch2_fs_btree_interior_update_init_early(c);
 	bch2_fs_allocator_background_init(c);
 	bch2_fs_allocator_foreground_init(c);
-- 
2.43.0

