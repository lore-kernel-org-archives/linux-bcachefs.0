Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83551EA7DE
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505699; cv=none; b=qD3kYQEJ4eAWz9r7ugyNoJDi5ic8l3E2kOf6wSK3JH0BjFyaT4Sx22XP4TqflawWhVj5+UxWKscK2u7/SSJoEpu07UKcmy4dQ+U3IOpXJV0PBtW/7eMtQN/3UeUIlyQF/HGY5x8XwUowdAU9NA1tpwI2RESF3O9/pQixyHBxOz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505699; c=relaxed/simple;
	bh=Yi9UGvXYWM2C7HprhASzT3oKU16pd3QNYvAnd1V+ouY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5Ar0VvswZU6BFCLNmwK/ZrdbrqUUym9tSJBL+47jOiBIFVlm/6A9ZimceZde+HPCKq1/u340ARm3K0iK/UOiFylBIi6S0QdSWx6myKzPRSelcJzJU2PI3sohzgo3Yej9BwGA7rIIhJxElySxyiUg5bsWvbXQ3eDGyDcTobjdMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uzbeumWK; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uzbeumWK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N60YuOxywei0PVluxPU+NAOito2rvCsTqps0oqd0VVY=;
	b=uzbeumWKgVYkhzV/6qGtAZr8D4nTBxM4D8ca8cEtlHB3WKdwrcvONXb2HLpNmUR6o/vSCx
	54xQaYfEsD4FANJWb7x8k6jBcDcUSRmZkQpC7REONgrIRH/PVTRj5fCetm/RcoKsLjGkyZ
	/7psNjmwkjPAICyqll55qTwslVWbN5Q=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/5] bcachefs: Kill BCH_DEV_OPT_SETTERS()
Date: Thu, 20 Mar 2025 17:21:19 -0400
Message-ID: <20250320212125.3359155-2-kent.overstreet@linux.dev>
In-Reply-To: <20250320212125.3359155-1-kent.overstreet@linux.dev>
References: <20250320212125.3359155-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, device options had their superblock option field listed
separately, which was weird and easy to miss when defining options.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/opts.c              | 108 +++++++++++++++-----------------
 fs/bcachefs/opts.h              |  50 +++++++--------
 fs/bcachefs/sb-members_format.h |   1 +
 fs/bcachefs/super-io.c          |   8 +--
 4 files changed, 80 insertions(+), 87 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 6772faf385a5..0dc0ce37a6e1 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -163,16 +163,6 @@ const char * const bch2_d_types[BCH_DT_MAX] = {
 	[DT_SUBVOL]	= "subvol",
 };
 
-u64 BCH2_NO_SB_OPT(const struct bch_sb *sb)
-{
-	BUG();
-}
-
-void SET_BCH2_NO_SB_OPT(struct bch_sb *sb, u64 v)
-{
-	BUG();
-}
-
 void bch2_opts_apply(struct bch_opts *dst, struct bch_opts src)
 {
 #define x(_name, ...)						\
@@ -223,6 +213,21 @@ void bch2_opt_set_by_id(struct bch_opts *opts, enum bch_opt_id id, u64 v)
 	}
 }
 
+/* dummy option, for options that aren't stored in the superblock */
+typedef u64 (*sb_opt_get_fn)(const struct bch_sb *);
+typedef void (*sb_opt_set_fn)(struct bch_sb *, u64);
+typedef u64 (*member_opt_get_fn)(const struct bch_member *);
+typedef void (*member_opt_set_fn)(struct bch_member *, u64);
+
+static const sb_opt_get_fn	BCH2_NO_SB_OPT = NULL;
+static const sb_opt_set_fn	SET_BCH2_NO_SB_OPT = NULL;
+static const member_opt_get_fn	BCH2_NO_MEMBER_OPT = NULL;
+static const member_opt_set_fn	SET_BCH2_NO_MEMBER_OPT = NULL;
+
+#define type_compatible_or_null(_p, _type)				\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_p), typeof(_type)), _p, NULL)
+
 const struct bch_option bch2_opt_table[] = {
 #define OPT_BOOL()		.type = BCH_OPT_BOOL, .min = 0, .max = 2
 #define OPT_UINT(_min, _max)	.type = BCH_OPT_UINT,			\
@@ -239,15 +244,15 @@ const struct bch_option bch2_opt_table[] = {
 
 #define x(_name, _bits, _flags, _type, _sb_opt, _default, _hint, _help)	\
 	[Opt_##_name] = {						\
-		.attr	= {						\
-			.name	= #_name,				\
-			.mode = (_flags) & OPT_RUNTIME ? 0644 : 0444,	\
-		},							\
-		.flags	= _flags,					\
-		.hint	= _hint,					\
-		.help	= _help,					\
-		.get_sb = _sb_opt,					\
-		.set_sb	= SET_##_sb_opt,				\
+		.attr.name	= #_name,				\
+		.attr.mode	= (_flags) & OPT_RUNTIME ? 0644 : 0444,	\
+		.flags		= _flags,				\
+		.hint		= _hint,				\
+		.help		= _help,				\
+		.get_sb		= type_compatible_or_null(_sb_opt,	*BCH2_NO_SB_OPT),	\
+		.set_sb		= type_compatible_or_null(SET_##_sb_opt,*SET_BCH2_NO_SB_OPT),	\
+		.get_member	= type_compatible_or_null(_sb_opt,	*BCH2_NO_MEMBER_OPT),	\
+		.set_member	= type_compatible_or_null(SET_##_sb_opt,*SET_BCH2_NO_MEMBER_OPT),\
 		_type							\
 	},
 
@@ -495,12 +500,8 @@ int bch2_opt_check_may_set(struct bch_fs *c, int id, u64 v)
 
 int bch2_opts_check_may_set(struct bch_fs *c)
 {
-	unsigned i;
-	int ret;
-
-	for (i = 0; i < bch2_opts_nr; i++) {
-		ret = bch2_opt_check_may_set(c, i,
-				bch2_opt_get_by_id(&c->opts, i));
+	for (unsigned i = 0; i < bch2_opts_nr; i++) {
+		int ret = bch2_opt_check_may_set(c, i, bch2_opt_get_by_id(&c->opts, i));
 		if (ret)
 			return ret;
 	}
@@ -619,12 +620,25 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 	return ret;
 }
 
-u64 bch2_opt_from_sb(struct bch_sb *sb, enum bch_opt_id id)
+u64 bch2_opt_from_sb(struct bch_sb *sb, enum bch_opt_id id, int dev_idx)
 {
 	const struct bch_option *opt = bch2_opt_table + id;
 	u64 v;
 
-	v = opt->get_sb(sb);
+	if (dev_idx < 0) {
+		v = opt->get_sb(sb);
+	} else {
+		if (WARN(!bch2_member_exists(sb, dev_idx),
+			 "tried to set device option %s on nonexistent device %i",
+			 opt->attr.name, dev_idx))
+			return 0;
+
+		struct bch_member m = bch2_sb_member_get(sb, dev_idx);
+		v = opt->get_member(&m);
+	}
+
+	if (opt->flags & OPT_SB_FIELD_ONE_BIAS)
+		--v;
 
 	if (opt->flags & OPT_SB_FIELD_ILOG2)
 		v = 1ULL << v;
@@ -641,35 +655,19 @@ u64 bch2_opt_from_sb(struct bch_sb *sb, enum bch_opt_id id)
  */
 int bch2_opts_from_sb(struct bch_opts *opts, struct bch_sb *sb)
 {
-	unsigned id;
-
-	for (id = 0; id < bch2_opts_nr; id++) {
+	for (unsigned id = 0; id < bch2_opts_nr; id++) {
 		const struct bch_option *opt = bch2_opt_table + id;
 
-		if (opt->get_sb == BCH2_NO_SB_OPT)
-			continue;
-
-		bch2_opt_set_by_id(opts, id, bch2_opt_from_sb(sb, id));
+		if (opt->get_sb)
+			bch2_opt_set_by_id(opts, id, bch2_opt_from_sb(sb, id, -1));
 	}
 
 	return 0;
 }
 
-struct bch_dev_sb_opt_set {
-	void			(*set_sb)(struct bch_member *, u64);
-};
-
-static const struct bch_dev_sb_opt_set bch2_dev_sb_opt_setters [] = {
-#define x(n, set)	[Opt_##n] = { .set_sb = SET_##set },
-	BCH_DEV_OPT_SETTERS()
-#undef x
-};
-
 void __bch2_opt_set_sb(struct bch_sb *sb, int dev_idx,
 		       const struct bch_option *opt, u64 v)
 {
-	enum bch_opt_id id = opt - bch2_opt_table;
-
 	if (opt->flags & OPT_SB_FIELD_SECTORS)
 		v >>= 9;
 
@@ -679,24 +677,18 @@ void __bch2_opt_set_sb(struct bch_sb *sb, int dev_idx,
 	if (opt->flags & OPT_SB_FIELD_ONE_BIAS)
 		v++;
 
-	if (opt->flags & OPT_FS) {
-		if (opt->set_sb != SET_BCH2_NO_SB_OPT)
-			opt->set_sb(sb, v);
-	}
+	if ((opt->flags & OPT_FS) && opt->set_sb)
+		opt->set_sb(sb, v);
 
-	if ((opt->flags & OPT_DEVICE) && dev_idx >= 0) {
+	if ((opt->flags & OPT_DEVICE) &&
+	    opt->set_member &&
+	    dev_idx >= 0) {
 		if (WARN(!bch2_member_exists(sb, dev_idx),
 			 "tried to set device option %s on nonexistent device %i",
 			 opt->attr.name, dev_idx))
 			return;
 
-		struct bch_member *m = bch2_members_v2_get_mut(sb, dev_idx);
-
-		const struct bch_dev_sb_opt_set *set = bch2_dev_sb_opt_setters + id;
-		if (set->set_sb)
-			set->set_sb(m, v);
-		else
-			pr_err("option %s cannot be set via opt_set_sb()", opt->attr.name);
+		opt->set_member(bch2_members_v2_get_mut(sb, dev_idx), v);
 	}
 }
 
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index baa9c11acb1a..c0adfd5b4f1c 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -50,10 +50,6 @@ static inline const char *bch2_d_type_str(unsigned d_type)
  * apply the options from that struct that are defined.
  */
 
-/* dummy option, for options that aren't stored in the superblock */
-u64 BCH2_NO_SB_OPT(const struct bch_sb *);
-void SET_BCH2_NO_SB_OPT(struct bch_sb *, u64);
-
 /* When can be set: */
 enum opt_flags {
 	OPT_FS			= BIT(0),	/* Filesystem option */
@@ -318,11 +314,6 @@ enum fsck_err_opts {
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,		false,				\
 	  NULL,		"Don't kick drives out when splitbrain detected")\
-	x(discard,			u8,				\
-	  OPT_FS|OPT_MOUNT|OPT_DEVICE,					\
-	  OPT_BOOL(),							\
-	  BCH2_NO_SB_OPT,		true,				\
-	  NULL,		"Enable discard/TRIM support")			\
 	x(verbose,			u8,				\
 	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
 	  OPT_BOOL(),							\
@@ -503,27 +494,37 @@ enum fsck_err_opts {
 	  BCH2_NO_SB_OPT,		false,				\
 	  NULL,		"Skip submit_bio() for data reads and writes, "	\
 			"for performance testing purposes")		\
-	x(fs_size,			u64,				\
+	x(state,			u64,				\
 	  OPT_DEVICE,							\
+	  OPT_STR(bch2_member_states),					\
+	  BCH_MEMBER_STATE,		BCH_MEMBER_STATE_rw,		\
+	  "state",	"rw,ro,failed,spare")				\
+	x(fs_size,			u64,				\
+	  OPT_DEVICE|OPT_HIDDEN,					\
 	  OPT_UINT(0, S64_MAX),						\
-	  BCH2_NO_SB_OPT,		0,				\
+	  BCH2_NO_MEMBER_OPT,		0,				\
 	  "size",	"Size of filesystem on device")			\
-	x(bucket,			u32,				\
-	  OPT_DEVICE,							\
+	x(bucket_size,			u32,				\
+	  OPT_DEVICE|OPT_HUMAN_READABLE|OPT_SB_FIELD_SECTORS,		\
 	  OPT_UINT(0, S64_MAX),						\
-	  BCH2_NO_SB_OPT,		0,				\
+	  BCH_MEMBER_BUCKET_SIZE,	0,				\
 	  "size",	"Specifies the bucket size; must be greater than the btree node size")\
 	x(durability,			u8,				\
-	  OPT_DEVICE|OPT_SB_FIELD_ONE_BIAS,				\
+	  OPT_DEVICE|OPT_RUNTIME|OPT_SB_FIELD_ONE_BIAS,			\
 	  OPT_UINT(0, BCH_REPLICAS_MAX),				\
-	  BCH2_NO_SB_OPT,		1,				\
+	  BCH_MEMBER_DURABILITY,	1,				\
 	  "n",		"Data written to this device will be considered\n"\
 			"to have already been replicated n times")	\
 	x(data_allowed,			u8,				\
 	  OPT_DEVICE,							\
 	  OPT_BITFIELD(__bch2_data_types),				\
-	  BCH2_NO_SB_OPT,		BIT(BCH_DATA_journal)|BIT(BCH_DATA_btree)|BIT(BCH_DATA_user),\
+	  BCH_MEMBER_DATA_ALLOWED,	BIT(BCH_DATA_journal)|BIT(BCH_DATA_btree)|BIT(BCH_DATA_user),\
 	  "types",	"Allowed data types for this device: journal, btree, and/or user")\
+	x(discard,			u8,				\
+	  OPT_MOUNT|OPT_DEVICE|OPT_RUNTIME,				\
+	  OPT_BOOL(),							\
+	  BCH_MEMBER_DISCARD,		true,				\
+	  NULL,		"Enable discard/TRIM support")			\
 	x(btree_node_prefetch,		u8,				\
 	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
 	  OPT_BOOL(),							\
@@ -531,11 +532,6 @@ enum fsck_err_opts {
 	  NULL,		"BTREE_ITER_prefetch casuse btree nodes to be\n"\
 	  " prefetched sequentially")
 
-#define BCH_DEV_OPT_SETTERS()						\
-	x(discard,		BCH_MEMBER_DISCARD)			\
-	x(durability,		BCH_MEMBER_DURABILITY)			\
-	x(data_allowed,		BCH_MEMBER_DATA_ALLOWED)
-
 struct bch_opts {
 #define x(_name, _bits, ...)	unsigned _name##_defined:1;
 	BCH_OPTS()
@@ -592,8 +588,6 @@ struct printbuf;
 
 struct bch_option {
 	struct attribute	attr;
-	u64			(*get_sb)(const struct bch_sb *);
-	void			(*set_sb)(struct bch_sb *, u64);
 	enum opt_type		type;
 	enum opt_flags		flags;
 	u64			min, max;
@@ -605,6 +599,12 @@ struct bch_option {
 	const char		*hint;
 	const char		*help;
 
+	u64			(*get_sb)(const struct bch_sb *);
+	void			(*set_sb)(struct bch_sb *, u64);
+
+	u64			(*get_member)(const struct bch_member *);
+	void			(*set_member)(struct bch_member *, u64);
+
 };
 
 extern const struct bch_option bch2_opt_table[];
@@ -613,7 +613,7 @@ bool bch2_opt_defined_by_id(const struct bch_opts *, enum bch_opt_id);
 u64 bch2_opt_get_by_id(const struct bch_opts *, enum bch_opt_id);
 void bch2_opt_set_by_id(struct bch_opts *, enum bch_opt_id, u64);
 
-u64 bch2_opt_from_sb(struct bch_sb *, enum bch_opt_id);
+u64 bch2_opt_from_sb(struct bch_sb *, enum bch_opt_id, int);
 int bch2_opts_from_sb(struct bch_opts *, struct bch_sb *);
 void __bch2_opt_set_sb(struct bch_sb *, int, const struct bch_option *, u64);
 
diff --git a/fs/bcachefs/sb-members_format.h b/fs/bcachefs/sb-members_format.h
index 2adf1221a440..3affec823b3f 100644
--- a/fs/bcachefs/sb-members_format.h
+++ b/fs/bcachefs/sb-members_format.h
@@ -79,6 +79,7 @@ struct bch_member {
 
 #define BCH_MEMBER_V1_BYTES	56
 
+LE16_BITMASK(BCH_MEMBER_BUCKET_SIZE,	struct bch_member, bucket_size,  0, 16)
 LE64_BITMASK(BCH_MEMBER_STATE,		struct bch_member, flags,  0,  4)
 /* 4-14 unused, was TIER, HAS_(META)DATA, REPLACEMENT */
 LE64_BITMASK(BCH_MEMBER_DISCARD,	struct bch_member, flags, 14, 15)
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index f2e4428281a3..572b06bfa0b8 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -489,8 +489,8 @@ int bch2_sb_validate(struct bch_sb *sb, u64 read_offset,
 	for (opt_id = 0; opt_id < bch2_opts_nr; opt_id++) {
 		const struct bch_option *opt = bch2_opt_table + opt_id;
 
-		if (opt->get_sb != BCH2_NO_SB_OPT) {
-			u64 v = bch2_opt_from_sb(sb, opt_id);
+		if (opt->get_sb) {
+			u64 v = bch2_opt_from_sb(sb, opt_id, -1);
 
 			prt_printf(out, "Invalid option ");
 			ret = bch2_opt_validate(opt, v, out);
@@ -1473,8 +1473,8 @@ void bch2_sb_to_text(struct printbuf *out, struct bch_sb *sb,
 		for (id = 0; id < bch2_opts_nr; id++) {
 			const struct bch_option *opt = bch2_opt_table + id;
 
-			if (opt->get_sb != BCH2_NO_SB_OPT) {
-				u64 v = bch2_opt_from_sb(sb, id);
+			if (opt->get_sb) {
+				u64 v = bch2_opt_from_sb(sb, id, -1);
 
 				prt_printf(out, "%s:\t", opt->attr.name);
 				bch2_opt_to_text(out, NULL, sb, opt, v,
-- 
2.49.0

