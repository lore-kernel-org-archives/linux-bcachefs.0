Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E2A25E817
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Apr 2025 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746037979; cv=none; b=KLyU0K13/8Ad+/9/Tvt5LypXBbDS04ZU6FfJK7xF6A0OiBK5IZu9cruXfLmihfQ9u8aER5ZUrQC+KLGUyjVfCo8cPObaVvgP8HfOxUPHQdHnuh61XaemN525QTk5BI527uWBspHyroc7Fy4kYYPEQzUg7sgJjNj/wi+Be9yUgnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746037979; c=relaxed/simple;
	bh=7dlKktqCOIiGzoJ0Hs7B9iO5DHTZlcGIUvzJTtAp4BQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvW+wqj0T8W+x54U5h2c7dp3SDCsqrQ/pxG3ZdGpDpNq5ODzmg+/G7/82lzMWQOGScypKJNXXYtyeJw5sZHq7iq79J+0c/l/bO7EAU+ntekGr+CjgjnOvHBvQBRkL21lHA7NpTHhv7xs4dWqq11XQWonYWCslhH+MKYqyHT6lDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jRUIgOxQ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jRUIgOxQ"
Date: Wed, 30 Apr 2025 14:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746037964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yoJYAWx7Zq6nI7wanJbzvpIAUvHzY3ZL8cl3YT7AY9E=;
	b=jRUIgOxQmEkkDft/osEDJMMGDSi7LOYB/6hIW6s7EJgl6QgD0aAhoa9vbdls3RFSGAtDWo
	57UDiGmWiCdxVMKHX+H7bzQBlSQLBv/NFetVc2tqa0Is3EvHkYx2EfCrG5Zhaufqd5GoDx
	PVZz/pF3RY5PbIiTSE/2rqgr9M/qjjs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <gynmaxokdg2t73okjvtl7cuvlcfa5saqwdnd3jh5obwejzy3ce@ic3q4nkrozlr>
References: <aBF5udHEHwWvmWJw@kspp>
 <wxh5qw7hzvvyg4texozjbviicfe2xmbjxngwlc3a7xef6jm6kn@wi3f25t2fftd>
 <a1edcb19-f463-4d15-be3d-2393191c45fd@embeddedor.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1edcb19-f463-4d15-be3d-2393191c45fd@embeddedor.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 30, 2025 at 12:27:26PM -0600, Gustavo A. R. Silva wrote:
> 
> 
> On 29/04/25 19:40, Kent Overstreet wrote:
> > On Tue, Apr 29, 2025 at 07:15:37PM -0600, Gustavo A. R. Silva wrote:
> > > -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> > > getting ready to enable it, globally.
> > > 
> > > Use the `DEFINE_FLEX()` helper for on-stack definitions of a flexible
> > > structure where the size of the flexible-array member is known at
> > > compile-time, and refactor the rest of the code, accordingly.
> > > 
> > > So, with these changes, fix the following warning:
> > > 
> > > fs/bcachefs/disk_accounting.c:429:51: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> > 
> > We also have bch_replicas_padded, does that also need a fix?
> 
> Yes - so, how about the following to address both issues:

Yes, I like that much better

> 
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index 7be71952425c..2dcccf1edbb9 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -287,7 +287,7 @@ static inline bool accounting_to_replicas(struct bch_replicas_entry_v1 *r, struc
> 
>  static int bch2_accounting_update_sb_one(struct bch_fs *c, struct bpos p)
>  {
> -       struct bch_replicas_padded r;
> +       union bch_replicas_padded r;
>         return accounting_to_replicas(&r.e, p)
>                 ? bch2_mark_replicas(c, &r.e)
>                 : 0;
> @@ -361,7 +361,7 @@ static int __bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accoun
>  int bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accounting a,
>                                enum bch_accounting_mode mode)
>  {
> -       struct bch_replicas_padded r;
> +       union bch_replicas_padded r;
> 
>         if (mode != BCH_ACCOUNTING_read &&
>             accounting_to_replicas(&r.e, a.k->p) &&
> @@ -425,10 +425,12 @@ int bch2_fs_replicas_usage_read(struct bch_fs *c, darray_char *usage)
> 
>         percpu_down_read(&c->mark_lock);
>         darray_for_each(acc->k, i) {
> -               struct {
> +               union {
> +                       u8 bytes[struct_size_t(struct bch_replicas_usage, r.devs,
> +                                              BCH_BKEY_PTRS_MAX)];
>                         struct bch_replicas_usage r;
> -                       u8 pad[BCH_BKEY_PTRS_MAX];
>                 } u;
> +               u.r.r.nr_devs = BCH_BKEY_PTRS_MAX;
> 
>                 if (!accounting_to_replicas(&u.r.r, i->pos))
>                         continue;
> @@ -627,7 +629,7 @@ static int bch2_disk_accounting_validate_late(struct btree_trans *trans,
> 
>         switch (acc->type) {
>         case BCH_DISK_ACCOUNTING_replicas: {
> -               struct bch_replicas_padded r;
> +               union bch_replicas_padded r;
>                 __accounting_to_replicas(&r.e, acc);
> 
>                 for (unsigned i = 0; i < r.e.nr_devs; i++)
> diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
> index 06144bfd9c19..809446c78951 100644
> --- a/fs/bcachefs/ec_types.h
> +++ b/fs/bcachefs/ec_types.h
> @@ -4,9 +4,10 @@
> 
>  #include "bcachefs_format.h"
> 
> -struct bch_replicas_padded {
> +union bch_replicas_padded {
> +       u8                              bytes[struct_size_t(struct bch_replicas_entry_v1,
> +                                                           devs, BCH_BKEY_PTRS_MAX)];
>         struct bch_replicas_entry_v1    e;
> -       u8                              pad[BCH_BKEY_PTRS_MAX];
>  };
> 
>  struct stripe {
> @@ -28,7 +29,7 @@ struct gc_stripe {
>         u16                     block_sectors[BCH_BKEY_PTRS_MAX];
>         struct bch_extent_ptr   ptrs[BCH_BKEY_PTRS_MAX];
> 
> -       struct bch_replicas_padded r;
> +       union bch_replicas_padded r;
>  };
> 
>  #endif /* _BCACHEFS_EC_TYPES_H */
> diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
> index 58e3983d860a..7c09a3c109ab 100644
> --- a/fs/bcachefs/journal_io.c
> +++ b/fs/bcachefs/journal_io.c
> @@ -1404,7 +1404,7 @@ int bch2_journal_read(struct bch_fs *c,
>         }
> 
>         genradix_for_each(&c->journal_entries, radix_iter, _i) {
> -               struct bch_replicas_padded replicas = {
> +               union bch_replicas_padded replicas = {
>                         .e.data_type = BCH_DATA_journal,
>                         .e.nr_devs = 0,
>                         .e.nr_required = 1,
> @@ -1632,7 +1632,7 @@ static CLOSURE_CALLBACK(journal_write_done)
>         closure_type(w, struct journal_buf, io);
>         struct journal *j = container_of(w, struct journal, buf[w->idx]);
>         struct bch_fs *c = container_of(j, struct bch_fs, journal);
> -       struct bch_replicas_padded replicas;
> +       union bch_replicas_padded replicas;
>         u64 seq = le64_to_cpu(w->data->seq);
>         int err = 0;
> 
> @@ -2055,7 +2055,7 @@ CLOSURE_CALLBACK(bch2_journal_write)
>         closure_type(w, struct journal_buf, io);
>         struct journal *j = container_of(w, struct journal, buf[w->idx]);
>         struct bch_fs *c = container_of(j, struct bch_fs, journal);
> -       struct bch_replicas_padded replicas;
> +       union bch_replicas_padded replicas;
>         unsigned nr_rw_members = dev_mask_nr(&c->rw_devs[BCH_DATA_journal]);
>         int ret;
> 
> diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
> index 66bfb95f1ea4..0acaf20f2181 100644
> --- a/fs/bcachefs/journal_reclaim.c
> +++ b/fs/bcachefs/journal_reclaim.c
> @@ -953,7 +953,7 @@ int bch2_journal_flush_device_pins(struct journal *j, int dev_idx)
>         seq = 0;
>         spin_lock(&j->lock);
>         while (!ret) {
> -               struct bch_replicas_padded replicas;
> +               union bch_replicas_padded replicas;
> 
>                 seq = max(seq, journal_last_seq(j));
>                 if (seq >= j->pin.back)
> 
> 
> Thanks
> -Gustavo
