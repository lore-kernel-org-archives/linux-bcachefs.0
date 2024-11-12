Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A2B1FF057
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423348; cv=none; b=r8ucvEHKrr1g6ZDEPb/fd/Vmex2cFZ3m2PXuDpNHIcZLA+d0prGcaHR9s/gZ0FBPsfKYqAuI2Q6FZSNJUBCxcW8Zb+aPStCzpYRZBVufR3opgcYMtiBZRPsNxCvE8n1eO3xilM6nlLZeCt2uJcqf46zs6hKrrRFwWqnr371fP+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423348; c=relaxed/simple;
	bh=ICST0+6WLnbo1DGiPl7UBeOGPEBBmTA1E7YsH3wFeLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fub/d7V4N1SDYR9LwGevbqpUjiL64JBwTD5Q80YD4Y6VjnLefeszJoWmKxAcBfZ91G//21UsZeJ/2j6xHLNxmOWn4APd3nGnfw3wgUTKg1/MQvorNIymUNgMgVlDegqCEPK0s6QXkWeRREDdLyMhgfK8IZmgciZ3P08zgYrVs84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XnqDc3Y0gz2DgwD;
	Tue, 12 Nov 2024 22:53:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 73EE9180043;
	Tue, 12 Nov 2024 22:55:41 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 22:55:41 +0800
Message-ID: <cac8f1ed-8d7c-45cd-9e67-5d3afae43df4@huawei.com>
Date: Tue, 12 Nov 2024 22:55:39 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: bch2_inum_to_path()
To: Kent Overstreet <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>
References: <20241112021404.86597-1-kent.overstreet@linux.dev>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241112021404.86597-1-kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/11/12 10:14, Kent Overstreet wrote:
> Add a function for walking backpointers to find a path from a given
> inode number, and convert various error messages to use it.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>   fs/bcachefs/bcachefs.h       |   8 --
>   fs/bcachefs/errcode.h        |   1 +
>   fs/bcachefs/error.c          |  34 +++++++
>   fs/bcachefs/error.h          |  15 +--
>   fs/bcachefs/fs-common.c      |  84 ++++++++++++++++
>   fs/bcachefs/fs-common.h      |   2 +
>   fs/bcachefs/fs-io-buffered.c |  10 +-
>   fs/bcachefs/fsck.c           |  12 ++-
>   fs/bcachefs/io_misc.c        |  12 ++-
>   fs/bcachefs/io_read.c        | 180 +++++++++++++++++++++++++----------
>   fs/bcachefs/io_write.c       | 132 ++++++++++++++++---------
>   fs/bcachefs/io_write_types.h |   1 +
>   12 files changed, 369 insertions(+), 122 deletions(-)
> 
> diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
> index c59a58b93a92..18479787f31a 100644
> --- a/fs/bcachefs/bcachefs.h
> +++ b/fs/bcachefs/bcachefs.h
> @@ -308,10 +308,6 @@ do {									\
>   	bch2_print(c, KERN_ERR bch2_fmt_dev(ca, fmt), ##__VA_ARGS__)
>   #define bch_err_dev_offset(ca, _offset, fmt, ...) \
>   	bch2_print(c, KERN_ERR bch2_fmt_dev_offset(ca, _offset, fmt), ##__VA_ARGS__)
> -#define bch_err_inum(c, _inum, fmt, ...) \
> -	bch2_print(c, KERN_ERR bch2_fmt_inum(c, _inum, fmt), ##__VA_ARGS__)
> -#define bch_err_inum_offset(c, _inum, _offset, fmt, ...) \
> -	bch2_print(c, KERN_ERR bch2_fmt_inum_offset(c, _inum, _offset, fmt), ##__VA_ARGS__)
>   
>   #define bch_err_ratelimited(c, fmt, ...) \
>   	bch2_print_ratelimited(c, KERN_ERR bch2_fmt(c, fmt), ##__VA_ARGS__)
> @@ -319,10 +315,6 @@ do {									\
>   	bch2_print_ratelimited(ca, KERN_ERR bch2_fmt_dev(ca, fmt), ##__VA_ARGS__)
>   #define bch_err_dev_offset_ratelimited(ca, _offset, fmt, ...) \
>   	bch2_print_ratelimited(ca, KERN_ERR bch2_fmt_dev_offset(ca, _offset, fmt), ##__VA_ARGS__)
> -#define bch_err_inum_ratelimited(c, _inum, fmt, ...) \
> -	bch2_print_ratelimited(c, KERN_ERR bch2_fmt_inum(c, _inum, fmt), ##__VA_ARGS__)
> -#define bch_err_inum_offset_ratelimited(c, _inum, _offset, fmt, ...) \
> -	bch2_print_ratelimited(c, KERN_ERR bch2_fmt_inum_offset(c, _inum, _offset, fmt), ##__VA_ARGS__)
>   
>   static inline bool should_print_err(int err)
>   {
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index 18c995d41203..b4982c836992 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -116,6 +116,7 @@
>   	x(ENOENT,			ENOENT_dirent_doesnt_match_inode)	\
>   	x(ENOENT,			ENOENT_dev_not_found)			\
>   	x(ENOENT,			ENOENT_dev_idx_not_found)		\
> +	x(ENOENT,			ENOENT_inode_no_backpointer)		\
>   	x(ENOTEMPTY,			ENOTEMPTY_dir_not_empty)		\
>   	x(ENOTEMPTY,			ENOTEMPTY_subvol_not_empty)		\
>   	x(EEXIST,			EEXIST_str_hash_set)			\
> diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
> index 2960baa023f6..2b8d19297b7b 100644
> --- a/fs/bcachefs/error.c
> +++ b/fs/bcachefs/error.c
> @@ -2,6 +2,7 @@
>   #include "bcachefs.h"
>   #include "btree_iter.h"
>   #include "error.h"
> +#include "fs-common.h"
>   #include "journal.h"
>   #include "recovery_passes.h"
>   #include "super.h"
> @@ -489,3 +490,36 @@ void bch2_flush_fsck_errs(struct bch_fs *c)
>   
>   	mutex_unlock(&c->fsck_error_msgs_lock);
>   }
> +
> +int bch2_inum_err_msg_trans(struct btree_trans *trans, struct printbuf *out, subvol_inum inum)
> +{
> +	u32 restart_count = trans->restart_count;
> +	int ret = 0;
> +
> +	/* XXX: we don't yet attempt to print paths when we don't know the subvol */
> +	if (inum.subvol)
> +		ret = lockrestart_do(trans, bch2_inum_to_path(trans, inum, out));
> +	if (!inum.subvol || ret)
> +		prt_printf(out, "inum %llu:%llu", inum.subvol, inum.inum);
> +
> +	return trans_was_restarted(trans, restart_count);
> +}
> +
> +int bch2_inum_offset_err_msg_trans(struct btree_trans *trans, struct printbuf *out,
> +				    subvol_inum inum, u64 offset)
> +{
> +	int ret = bch2_inum_err_msg_trans(trans, out, inum);
> +	prt_printf(out, " offset %llu: ", offset);
> +	return ret;
> +}
> +
> +void bch2_inum_err_msg(struct bch_fs *c, struct printbuf *out, subvol_inum inum)
> +{
> +	bch2_trans_run(c, bch2_inum_err_msg_trans(trans, out, inum));
> +}
> +
> +void bch2_inum_offset_err_msg(struct bch_fs *c, struct printbuf *out,
> +			      subvol_inum inum, u64 offset)
> +{
> +	bch2_trans_run(c, bch2_inum_offset_err_msg_trans(trans, out, inum, offset));
> +}
> diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
> index d784b02bebea..08853bcf66aa 100644
> --- a/fs/bcachefs/error.h
> +++ b/fs/bcachefs/error.h
> @@ -243,15 +243,10 @@ void bch2_io_error(struct bch_dev *, enum bch_member_error_type);
>   	_ret;								\
>   })
>   
> -#define bch2_dev_inum_io_err_on(cond, ca, _type, ...)			\
> -({									\
> -	bool _ret = (cond);						\
> -									\
> -	if (_ret) {							\
> -		bch_err_inum_offset_ratelimited(ca, __VA_ARGS__);	\
> -		bch2_io_error(ca, _type);				\
> -	}								\
> -	_ret;								\
> -})
> +int bch2_inum_err_msg_trans(struct btree_trans *, struct printbuf *, subvol_inum);
> +int bch2_inum_offset_err_msg_trans(struct btree_trans *, struct printbuf *, subvol_inum, u64);
> +
> +void bch2_inum_err_msg(struct bch_fs *, struct printbuf *, subvol_inum);
> +void bch2_inum_offset_err_msg(struct bch_fs *, struct printbuf *, subvol_inum, u64);
>   
>   #endif /* _BCACHEFS_ERROR_H */
> diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
> index 7e10a9ddcfd9..3d20f345d123 100644
> --- a/fs/bcachefs/fs-common.c
> +++ b/fs/bcachefs/fs-common.c
> @@ -548,3 +548,87 @@ int bch2_rename_trans(struct btree_trans *trans,
>   	bch2_trans_iter_exit(trans, &src_dir_iter);
>   	return ret;
>   }
> +
> +static inline void prt_bytes_reversed(struct printbuf *out, const void *b, unsigned n)
> +{
> +	bch2_printbuf_make_room(out, n);
> +
> +	unsigned can_print = min(n, printbuf_remaining(out));
> +
> +	b += n;
> +
> +	for (unsigned i = 0; i < can_print; i++)
> +		out->buf[out->pos++] = *((char *) --b);
> +
> +	printbuf_nul_terminate(out);
> +}
> +
> +static inline void reverse_bytes(void *b, size_t n)
> +{
> +	char *e = b + n, *s = b;
> +
> +	while (s < e) {
> +		--e;
> +		swap(*s, *e);
> +		s++;
> +	}
> +}
> +
> +/* XXX: we don't yet attempt to print paths when we don't know the subvol */
> +int bch2_inum_to_path(struct btree_trans *trans, subvol_inum inum, struct printbuf *path)
> +{
> +	unsigned orig_pos = path->pos;
> +	int ret = 0;
> +
> +	while (!(inum.subvol == BCACHEFS_ROOT_SUBVOL &&
> +		 inum.inum   == BCACHEFS_ROOT_INO)) {
> +		struct bch_inode_unpacked inode;
> +		ret = bch2_inode_find_by_inum_trans(trans, inum, &inode);
> +		if (ret)
> +			goto err;
> +
> +		if (!inode.bi_dir && !inode.bi_dir_offset) {
> +			ret = -BCH_ERR_ENOENT_inode_no_backpointer;
> +			goto err;
> +		}
> +
> +		u32 snapshot;
> +		ret = bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot);
> +		if (ret)
> +			goto err;
> +
> +		struct btree_iter d_iter;
> +		struct bkey_s_c_dirent d = bch2_bkey_get_iter_typed(trans, &d_iter,
> +				BTREE_ID_dirents, SPOS(inode.bi_dir, inode.bi_dir_offset, snapshot),
> +				0, dirent);
> +		ret = bkey_err(d.s_c);
> +		if (ret)
> +			goto err;
> +
> +		struct qstr dirent_name = bch2_dirent_get_name(d);
> +
> +		unsigned orig_pos2 = path->pos;
> +		prt_bytes(path, dirent_name.name, dirent_name.len);
> +		reverse_bytes(path->buf + orig_pos2, path->pos - orig_pos2);
These two line can be replaced with prt_bytes_reversed helper.
> +
> +		prt_char(path, '/');
> +
> +		if (d.v->d_type == DT_SUBVOL)
> +			inum.subvol = le32_to_cpu(d.v->d_parent_subvol);
> +		inum.inum = d.k->p.inode;
> +
> +		bch2_trans_iter_exit(trans, &d_iter);
> +	}
> +
> +	if (!path->pos)
The condition should be if (orig_pos == path->) ?

Thanks,
Hongbo

> +		prt_char(path, '/');
> +
> +	ret = path->allocation_failure ? -ENOMEM : 0;
> +	if (ret)
> +		goto err;
> +
> +	reverse_bytes(path->buf + orig_pos, path->pos - orig_pos);
> +	return 0;
> +err:
> +	return ret;
> +}
> diff --git a/fs/bcachefs/fs-common.h b/fs/bcachefs/fs-common.h
> index c934e807b380..2b59210bb5e8 100644
> --- a/fs/bcachefs/fs-common.h
> +++ b/fs/bcachefs/fs-common.h
> @@ -42,4 +42,6 @@ int bch2_rename_trans(struct btree_trans *,
>   bool bch2_reinherit_attrs(struct bch_inode_unpacked *,
>   			  struct bch_inode_unpacked *);
>   
> +int bch2_inum_to_path(struct btree_trans *, subvol_inum, struct printbuf *);
> +
>   #endif /* _BCACHEFS_FS_COMMON_H */
> diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
> index d55e215e8aa6..ff8b8df50bf3 100644
> --- a/fs/bcachefs/fs-io-buffered.c
> +++ b/fs/bcachefs/fs-io-buffered.c
> @@ -231,10 +231,12 @@ static void bchfs_read(struct btree_trans *trans,
>   	bch2_trans_iter_exit(trans, &iter);
>   
>   	if (ret) {
> -		bch_err_inum_offset_ratelimited(c,
> -				iter.pos.inode,
> -				iter.pos.offset << 9,
> -				"read error %i from btree lookup", ret);
> +		struct printbuf buf = PRINTBUF;
> +		bch2_inum_offset_err_msg_trans(trans, &buf, inum, iter.pos.offset << 9);
> +		prt_printf(&buf, "read error %i from btree lookup", ret);
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +		printbuf_exit(&buf);
> +
>   		rbio->bio.bi_status = BLK_STS_IOERR;
>   		bio_endio(&rbio->bio);
>   	}
> diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
> index e10abd2e6c69..111cdbb327e4 100644
> --- a/fs/bcachefs/fsck.c
> +++ b/fs/bcachefs/fsck.c
> @@ -212,6 +212,7 @@ static int lookup_lostfound(struct btree_trans *trans, u32 snapshot,
>   {
>   	struct bch_fs *c = trans->c;
>   	struct qstr lostfound_str = QSTR("lost+found");
> +	struct btree_iter lostfound_iter = { NULL };
>   	u64 inum = 0;
>   	unsigned d_type = 0;
>   	int ret;
> @@ -290,11 +291,16 @@ static int lookup_lostfound(struct btree_trans *trans, u32 snapshot,
>   	 * XXX: we could have a nicer log message here  if we had a nice way to
>   	 * walk backpointers to print a path
>   	 */
> -	bch_notice(c, "creating lost+found in subvol %llu snapshot %u",
> -		   root_inum.subvol, le32_to_cpu(st.root_snapshot));
> +	struct printbuf path = PRINTBUF;
> +	ret = bch2_inum_to_path(trans, root_inum, &path);
> +	if (ret)
> +		goto err;
> +
> +	bch_notice(c, "creating %s/lost+found in subvol %llu snapshot %u",
> +		   path.buf, root_inum.subvol, snapshot);
> +	printbuf_exit(&path);
>   
>   	u64 now = bch2_current_time(c);
> -	struct btree_iter lostfound_iter = { NULL };
>   	u64 cpu = raw_smp_processor_id();
>   
>   	bch2_inode_init_early(c, lostfound);
> diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
> index 524e31e7411b..5353979117b0 100644
> --- a/fs/bcachefs/io_misc.c
> +++ b/fs/bcachefs/io_misc.c
> @@ -113,11 +113,13 @@ int bch2_extent_fallocate(struct btree_trans *trans,
>   err:
>   	if (!ret && sectors_allocated)
>   		bch2_increment_clock(c, sectors_allocated, WRITE);
> -	if (should_print_err(ret))
> -		bch_err_inum_offset_ratelimited(c,
> -			inum.inum,
> -			iter->pos.offset << 9,
> -			"%s(): error: %s", __func__, bch2_err_str(ret));
> +	if (should_print_err(ret)) {
> +		struct printbuf buf = PRINTBUF;
> +		bch2_inum_offset_err_msg_trans(trans, &buf, inum, iter->pos.offset << 9);
> +		prt_printf(&buf, "fallocate error: %s", bch2_err_str(ret));
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +		printbuf_exit(&buf);
> +	}
>   err_noprint:
>   	bch2_open_buckets_put(c, &open_buckets);
>   	bch2_disk_reservation_put(c, &disk_res);
> diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
> index eb8d12fd6398..a0730333cd1f 100644
> --- a/fs/bcachefs/io_read.c
> +++ b/fs/bcachefs/io_read.c
> @@ -322,6 +322,20 @@ static struct promote_op *promote_alloc(struct btree_trans *trans,
>   
>   /* Read */
>   
> +static int bch2_read_err_msg_trans(struct btree_trans *trans, struct printbuf *out,
> +				   struct bch_read_bio *rbio, struct bpos read_pos)
> +{
> +	return bch2_inum_offset_err_msg_trans(trans, out,
> +		(subvol_inum) { rbio->subvol, read_pos.inode },
> +		read_pos.offset << 9);
> +}
> +
> +static void bch2_read_err_msg(struct bch_fs *c, struct printbuf *out,
> +			      struct bch_read_bio *rbio, struct bpos read_pos)
> +{
> +	bch2_trans_run(c, bch2_read_err_msg_trans(trans, out, rbio, read_pos));
> +}
> +
>   #define READ_RETRY_AVOID	1
>   #define READ_RETRY		2
>   #define READ_ERR		3
> @@ -500,6 +514,29 @@ static void bch2_rbio_error(struct bch_read_bio *rbio, int retry,
>   	}
>   }
>   
> +static void bch2_read_io_err(struct work_struct *work)
> +{
> +	struct bch_read_bio *rbio =
> +		container_of(work, struct bch_read_bio, work);
> +	struct bio *bio = &rbio->bio;
> +	struct bch_fs *c	= rbio->c;
> +	struct bch_dev *ca = rbio->have_ioref ? bch2_dev_have_ref(c, rbio->pick.ptr.dev) : NULL;
> +	struct printbuf buf = PRINTBUF;
> +
> +	bch2_read_err_msg(c, &buf, rbio, rbio->read_pos);
> +	prt_printf(&buf, "data read error: %s", bch2_blk_status_to_str(bio->bi_status));
> +
> +	if (ca) {
> +		bch2_io_error(ca, BCH_MEMBER_ERROR_read);
> +		bch_err_ratelimited(ca, "%s", buf.buf);
> +	} else {
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +	}
> +
> +	printbuf_exit(&buf);
> +	bch2_rbio_error(rbio, READ_RETRY_AVOID, bio->bi_status);
> +}
> +
>   static int __bch2_rbio_narrow_crcs(struct btree_trans *trans,
>   				   struct bch_read_bio *rbio)
>   {
> @@ -563,6 +600,73 @@ static noinline void bch2_rbio_narrow_crcs(struct bch_read_bio *rbio)
>   			     __bch2_rbio_narrow_crcs(trans, rbio));
>   }
>   
> +static void bch2_read_csum_err(struct work_struct *work)
> +{
> +	struct bch_read_bio *rbio =
> +		container_of(work, struct bch_read_bio, work);
> +	struct bch_fs *c	= rbio->c;
> +	struct bio *src		= &rbio->bio;
> +	struct bch_extent_crc_unpacked crc = rbio->pick.crc;
> +	struct nonce nonce = extent_nonce(rbio->version, crc);
> +	struct bch_csum csum = bch2_checksum_bio(c, crc.csum_type, nonce, src);
> +	struct printbuf buf = PRINTBUF;
> +
> +	bch2_read_err_msg(c, &buf, rbio, rbio->read_pos);
> +	prt_str(&buf, "data ");
> +	bch2_csum_err_msg(&buf, crc.csum_type, rbio->pick.crc.csum, csum);
> +
> +	struct bch_dev *ca = rbio->have_ioref ? bch2_dev_have_ref(c, rbio->pick.ptr.dev) : NULL;
> +	if (ca) {
> +		bch2_io_error(ca, BCH_MEMBER_ERROR_checksum);
> +		bch_err_ratelimited(ca, "%s", buf.buf);
> +	} else {
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +	}
> +
> +	bch2_rbio_error(rbio, READ_RETRY_AVOID, BLK_STS_IOERR);
> +	printbuf_exit(&buf);
> +}
> +
> +static void bch2_read_decompress_err(struct work_struct *work)
> +{
> +	struct bch_read_bio *rbio =
> +		container_of(work, struct bch_read_bio, work);
> +	struct bch_fs *c	= rbio->c;
> +	struct printbuf buf = PRINTBUF;
> +
> +	bch2_read_err_msg(c, &buf, rbio, rbio->read_pos);
> +	prt_str(&buf, "decompression error");
> +
> +	struct bch_dev *ca = rbio->have_ioref ? bch2_dev_have_ref(c, rbio->pick.ptr.dev) : NULL;
> +	if (ca)
> +		bch_err_ratelimited(ca, "%s", buf.buf);
> +	else
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +
> +	bch2_rbio_error(rbio, READ_ERR, BLK_STS_IOERR);
> +	printbuf_exit(&buf);
> +}
> +
> +static void bch2_read_decrypt_err(struct work_struct *work)
> +{
> +	struct bch_read_bio *rbio =
> +		container_of(work, struct bch_read_bio, work);
> +	struct bch_fs *c	= rbio->c;
> +	struct printbuf buf = PRINTBUF;
> +
> +	bch2_read_err_msg(c, &buf, rbio, rbio->read_pos);
> +	prt_str(&buf, "decrypt error");
> +
> +	struct bch_dev *ca = rbio->have_ioref ? bch2_dev_have_ref(c, rbio->pick.ptr.dev) : NULL;
> +	if (ca)
> +		bch_err_ratelimited(ca, "%s", buf.buf);
> +	else
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +
> +	bch2_rbio_error(rbio, READ_ERR, BLK_STS_IOERR);
> +	printbuf_exit(&buf);
> +}
> +
>   /* Inner part that may run in process context */
>   static void __bch2_read_endio(struct work_struct *work)
>   {
> @@ -669,33 +773,13 @@ static void __bch2_read_endio(struct work_struct *work)
>   		goto out;
>   	}
>   
> -	struct printbuf buf = PRINTBUF;
> -	buf.atomic++;
> -	prt_str(&buf, "data ");
> -	bch2_csum_err_msg(&buf, crc.csum_type, rbio->pick.crc.csum, csum);
> -
> -	struct bch_dev *ca = rbio->have_ioref ? bch2_dev_have_ref(c, rbio->pick.ptr.dev) : NULL;
> -	if (ca) {
> -		bch_err_inum_offset_ratelimited(ca,
> -			rbio->read_pos.inode,
> -			rbio->read_pos.offset << 9,
> -			"data %s", buf.buf);
> -		bch2_io_error(ca, BCH_MEMBER_ERROR_checksum);
> -	}
> -	printbuf_exit(&buf);
> -	bch2_rbio_error(rbio, READ_RETRY_AVOID, BLK_STS_IOERR);
> +	bch2_rbio_punt(rbio, bch2_read_csum_err, RBIO_CONTEXT_UNBOUND, system_unbound_wq);
>   	goto out;
>   decompression_err:
> -	bch_err_inum_offset_ratelimited(c, rbio->read_pos.inode,
> -					rbio->read_pos.offset << 9,
> -					"decompression error");
> -	bch2_rbio_error(rbio, READ_ERR, BLK_STS_IOERR);
> +	bch2_rbio_punt(rbio, bch2_read_decompress_err, RBIO_CONTEXT_UNBOUND, system_unbound_wq);
>   	goto out;
>   decrypt_err:
> -	bch_err_inum_offset_ratelimited(c, rbio->read_pos.inode,
> -					rbio->read_pos.offset << 9,
> -					"decrypt error");
> -	bch2_rbio_error(rbio, READ_ERR, BLK_STS_IOERR);
> +	bch2_rbio_punt(rbio, bch2_read_decrypt_err, RBIO_CONTEXT_UNBOUND, system_unbound_wq);
>   	goto out;
>   }
>   
> @@ -716,16 +800,8 @@ static void bch2_read_endio(struct bio *bio)
>   	if (!rbio->split)
>   		rbio->bio.bi_end_io = rbio->end_io;
>   
> -	if (bio->bi_status) {
> -		if (ca) {
> -			bch_err_inum_offset_ratelimited(ca,
> -				rbio->read_pos.inode,
> -				rbio->read_pos.offset,
> -				"data read error: %s",
> -				bch2_blk_status_to_str(bio->bi_status));
> -			bch2_io_error(ca, BCH_MEMBER_ERROR_read);
> -		}
> -		bch2_rbio_error(rbio, READ_RETRY_AVOID, bio->bi_status);
> +	if (unlikely(bio->bi_status)) {
> +		bch2_rbio_punt(rbio, bch2_read_io_err, RBIO_CONTEXT_UNBOUND, system_unbound_wq);
>   		return;
>   	}
>   
> @@ -830,15 +906,13 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
>   	if (!pick_ret)
>   		goto hole;
>   
> -	if (pick_ret < 0) {
> +	if (unlikely(pick_ret < 0)) {
>   		struct printbuf buf = PRINTBUF;
> +		bch2_read_err_msg_trans(trans, &buf, rbio, read_pos);
> +		prt_printf(&buf, "no device to read from: %s\n  ", bch2_err_str(pick_ret));
>   		bch2_bkey_val_to_text(&buf, c, k);
>   
> -		bch_err_inum_offset_ratelimited(c,
> -				read_pos.inode, read_pos.offset << 9,
> -				"no device to read from: %s\n  %s",
> -				bch2_err_str(pick_ret),
> -				buf.buf);
> +		bch_err_ratelimited(c, "%s", buf.buf);
>   		printbuf_exit(&buf);
>   		goto err;
>   	}
> @@ -1024,11 +1098,15 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
>   	}
>   
>   	if (!rbio->pick.idx) {
> -		if (!rbio->have_ioref) {
> -			bch_err_inum_offset_ratelimited(c,
> -					read_pos.inode,
> -					read_pos.offset << 9,
> -					"no device to read from");
> +		if (unlikely(!rbio->have_ioref)) {
> +			struct printbuf buf = PRINTBUF;
> +			bch2_read_err_msg_trans(trans, &buf, rbio, read_pos);
> +			prt_printf(&buf, "no device to read from:\n  ");
> +			bch2_bkey_val_to_text(&buf, c, k);
> +
> +			bch_err_ratelimited(c, "%s", buf.buf);
> +			printbuf_exit(&buf);
> +
>   			bch2_rbio_error(rbio, READ_RETRY_AVOID, BLK_STS_IOERR);
>   			goto out;
>   		}
> @@ -1190,16 +1268,20 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
>   	}
>   
>   	bch2_trans_iter_exit(trans, &iter);
> -	bch2_trans_put(trans);
> -	bch2_bkey_buf_exit(&sk, c);
>   
>   	if (ret) {
> -		bch_err_inum_offset_ratelimited(c, inum.inum,
> -						bvec_iter.bi_sector << 9,
> -						"read error %i from btree lookup", ret);
> +		struct printbuf buf = PRINTBUF;
> +		bch2_inum_offset_err_msg_trans(trans, &buf, inum, bvec_iter.bi_sector << 9);
> +		prt_printf(&buf, "read error %i from btree lookup", ret);
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +		printbuf_exit(&buf);
> +
>   		rbio->bio.bi_status = BLK_STS_IOERR;
>   		bch2_rbio_done(rbio);
>   	}
> +
> +	bch2_trans_put(trans);
> +	bch2_bkey_buf_exit(&sk, c);
>   }
>   
>   void bch2_fs_io_read_exit(struct bch_fs *c)
> diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
> index f11e11279f01..322c945c564e 100644
> --- a/fs/bcachefs/io_write.c
> +++ b/fs/bcachefs/io_write.c
> @@ -395,6 +395,21 @@ static int bch2_write_index_default(struct bch_write_op *op)
>   
>   /* Writes */
>   
> +static void __bch2_write_op_error(struct printbuf *out, struct bch_write_op *op,
> +				  u64 offset)
> +{
> +	bch2_inum_offset_err_msg(op->c, out,
> +				 (subvol_inum) { op->subvol, op->pos.inode, },
> +				 offset << 9);
> +	prt_printf(out, "write error%s: ",
> +		   op->flags & BCH_WRITE_MOVE ? "(internal move)" : "");
> +}
> +
> +static void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op)
> +{
> +	__bch2_write_op_error(out, op, op->pos.offset);
> +}
> +
>   void bch2_submit_wbio_replicas(struct bch_write_bio *wbio, struct bch_fs *c,
>   			       enum bch_data_type type,
>   			       const struct bkey_i *k,
> @@ -531,14 +546,14 @@ static void __bch2_write_index(struct bch_write_op *op)
>   
>   		op->written += sectors_start - keylist_sectors(keys);
>   
> -		if (ret && !bch2_err_matches(ret, EROFS)) {
> +		if (unlikely(ret && !bch2_err_matches(ret, EROFS))) {
>   			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
>   
> -			bch_err_inum_offset_ratelimited(c,
> -				insert->k.p.inode, insert->k.p.offset << 9,
> -				"%s write error while doing btree update: %s",
> -				op->flags & BCH_WRITE_MOVE ? "move" : "user",
> -				bch2_err_str(ret));
> +			struct printbuf buf = PRINTBUF;
> +			__bch2_write_op_error(&buf, op, bkey_start_offset(&insert->k));
> +			prt_printf(&buf, "btree update error: %s", bch2_err_str(ret));
> +			bch_err_ratelimited(c, "%s", buf.buf);
> +			printbuf_exit(&buf);
>   		}
>   
>   		if (ret)
> @@ -641,7 +656,7 @@ void bch2_write_point_do_index_updates(struct work_struct *work)
>   	}
>   }
>   
> -static void bch2_write_endio(struct bio *bio)
> +static inline void __bch2_write_endio(struct bio *bio)
>   {
>   	struct closure *cl		= bio->bi_private;
>   	struct bch_write_op *op		= container_of(cl, struct bch_write_op, cl);
> @@ -652,15 +667,6 @@ static void bch2_write_endio(struct bio *bio)
>   		? bch2_dev_have_ref(c, wbio->dev)
>   		: NULL;
>   
> -	if (bch2_dev_inum_io_err_on(bio->bi_status, ca, BCH_MEMBER_ERROR_write,
> -				    op->pos.inode,
> -				    wbio->inode_offset << 9,
> -				    "data write error: %s",
> -				    bch2_blk_status_to_str(bio->bi_status))) {
> -		set_bit(wbio->dev, op->failed.d);
> -		op->flags |= BCH_WRITE_IO_ERROR;
> -	}
> -
>   	if (wbio->nocow) {
>   		bch2_bucket_nocow_unlock(&c->nocow_locks,
>   					 POS(ca->dev_idx, wbio->nocow_bucket),
> @@ -685,6 +691,44 @@ static void bch2_write_endio(struct bio *bio)
>   		closure_put(cl);
>   }
>   
> +static void bch2_write_endio_err(struct work_struct *work)
> +
> +{
> +	struct bch_write_bio *wbio	= container_of(work, struct bch_write_bio, work);
> +	struct bio *bio			= &wbio->bio;
> +	struct closure *cl		= bio->bi_private;
> +	struct bch_write_op *op		= container_of(cl, struct bch_write_op, cl);
> +	struct bch_fs *c		= op->c;
> +	struct bch_dev *ca		= wbio->have_ioref
> +		? bch2_dev_have_ref(c, wbio->dev)
> +		: NULL;
> +
> +	struct printbuf buf = PRINTBUF;
> +	bch2_write_op_error(&buf, op);
> +	prt_printf(&buf, "data write error: %s", bch2_blk_status_to_str(bio->bi_status));
> +	bch_err_ratelimited(c, "%s", buf.buf);
> +	printbuf_exit(&buf);
> +
> +	if (ca)
> +		bch2_io_error(ca, BCH_MEMBER_ERROR_write);
> +
> +	set_bit(wbio->dev, op->failed.d);
> +	op->flags |= BCH_WRITE_IO_ERROR;
> +
> +	__bch2_write_endio(bio);
> +}
> +
> +static void bch2_write_endio(struct bio *bio)
> +{
> +	if (unlikely(bio->bi_status)) {
> +		struct bch_write_bio *wbio = to_wbio(bio);
> +		INIT_WORK(&wbio->work, bch2_write_endio_err);
> +		queue_work(system_unbound_wq, &wbio->work);
> +	} else {
> +		__bch2_write_endio(bio);
> +	}
> +}
> +
>   static void init_append_extent(struct bch_write_op *op,
>   			       struct write_point *wp,
>   			       struct bversion version,
> @@ -1080,11 +1124,12 @@ static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
>   	*_dst = dst;
>   	return more;
>   csum_err:
> -	bch_err_inum_offset_ratelimited(c,
> -		op->pos.inode,
> -		op->pos.offset << 9,
> -		"%s write error: error verifying existing checksum while rewriting existing data (memory corruption?)",
> -		op->flags & BCH_WRITE_MOVE ? "move" : "user");
> +	struct printbuf buf = PRINTBUF;
> +	bch2_write_op_error(&buf, op);
> +	prt_printf(&buf, "error verifying existing checksum while rewriting existing data (memory corruption?)");
> +	bch_err_ratelimited(c, "%s", buf.buf);
> +	printbuf_exit(&buf);
> +
>   	ret = -EIO;
>   err:
>   	if (to_wbio(dst)->bounce)
> @@ -1175,11 +1220,11 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
>   		if (ret && !bch2_err_matches(ret, EROFS)) {
>   			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
>   
> -			bch_err_inum_offset_ratelimited(c,
> -				insert->k.p.inode, insert->k.p.offset << 9,
> -				"%s write error while doing btree update: %s",
> -				op->flags & BCH_WRITE_MOVE ? "move" : "user",
> -				bch2_err_str(ret));
> +			struct printbuf buf = PRINTBUF;
> +			__bch2_write_op_error(&buf, op, bkey_start_offset(&insert->k));
> +			prt_printf(&buf, "btree update error: %s", bch2_err_str(ret));
> +			bch_err_ratelimited(c, "%s", buf.buf);
> +			printbuf_exit(&buf);
>   		}
>   
>   		if (ret) {
> @@ -1340,9 +1385,11 @@ static void bch2_nocow_write(struct bch_write_op *op)
>   		goto retry;
>   
>   	if (ret) {
> -		bch_err_inum_offset_ratelimited(c,
> -			op->pos.inode, op->pos.offset << 9,
> -			"%s: btree lookup error %s", __func__, bch2_err_str(ret));
> +		struct printbuf buf = PRINTBUF;
> +		bch2_write_op_error(&buf, op);
> +		prt_printf(&buf, "%s(): btree lookup error: %s", __func__, bch2_err_str(ret));
> +		bch_err_ratelimited(c, "%s", buf.buf);
> +		printbuf_exit(&buf);
>   		op->error = ret;
>   		op->flags |= BCH_WRITE_SUBMITTED;
>   	}
> @@ -1462,14 +1509,14 @@ static void __bch2_write(struct bch_write_op *op)
>   		if (ret <= 0) {
>   			op->flags |= BCH_WRITE_SUBMITTED;
>   
> -			if (ret < 0) {
> -				if (!(op->flags & BCH_WRITE_ALLOC_NOWAIT))
> -					bch_err_inum_offset_ratelimited(c,
> -						op->pos.inode,
> -						op->pos.offset << 9,
> -						"%s(): %s error: %s", __func__,
> -						op->flags & BCH_WRITE_MOVE ? "move" : "user",
> -						bch2_err_str(ret));
> +			if (unlikely(ret < 0)) {
> +				if (!(op->flags & BCH_WRITE_ALLOC_NOWAIT)) {
> +					struct printbuf buf = PRINTBUF;
> +					bch2_write_op_error(&buf, op);
> +					prt_printf(&buf, "%s(): %s", __func__, bch2_err_str(ret));
> +					bch_err_ratelimited(c, "%s", buf.buf);
> +					printbuf_exit(&buf);
> +				}
>   				op->error = ret;
>   				break;
>   			}
> @@ -1595,12 +1642,11 @@ CLOSURE_CALLBACK(bch2_write)
>   	bch2_keylist_init(&op->insert_keys, op->inline_keys);
>   	wbio_init(bio)->put_bio = false;
>   
> -	if (bio->bi_iter.bi_size & (c->opts.block_size - 1)) {
> -		bch_err_inum_offset_ratelimited(c,
> -			op->pos.inode,
> -			op->pos.offset << 9,
> -			"%s write error: misaligned write",
> -			op->flags & BCH_WRITE_MOVE ? "move" : "user");
> +	if (unlikely(bio->bi_iter.bi_size & (c->opts.block_size - 1))) {
> +		struct printbuf buf = PRINTBUF;
> +		bch2_write_op_error(&buf, op);
> +		prt_printf(&buf, "misaligned write");
> +		printbuf_exit(&buf);
>   		op->error = -EIO;
>   		goto err;
>   	}
> diff --git a/fs/bcachefs/io_write_types.h b/fs/bcachefs/io_write_types.h
> index 6e878a6f2f0b..bf0447c0e8f2 100644
> --- a/fs/bcachefs/io_write_types.h
> +++ b/fs/bcachefs/io_write_types.h
> @@ -15,6 +15,7 @@
>   
>   struct bch_write_bio {
>   	struct_group(wbio,
> +	struct work_struct	work;	/* for when we need to print an error message */
>   	struct bch_fs		*c;
>   	struct bch_write_bio	*parent;
>   
