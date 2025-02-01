Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5491CCEF6
	for <linux-bcachefs@vger.kernel.org>; Sat,  1 Feb 2025 21:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738445096; cv=none; b=Q2FVuujGx+odLpQxDT7/7eM+ycNFUWY0svty0C4sehKhWu9wtjlSdXNnUXjF/5jHVOSOjL3wQ8i7bL6uCnVL8x7ehgk/pZivhzeaqU0j/xGaqTNet8tQCqoFsaFLCJ07tD7cYXgNMHbJ0+XOIFR7DhZxLka7Cfg9z8O94+B02R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738445096; c=relaxed/simple;
	bh=yYK8f7I1aNapofg60l0ZtEixnSH17Y6dm5OMnzJR/pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJI8bvs3pcrzEhgzbQRhWPkdFLTr4vhNIWkJhNqqLTh6mHyYMUcf9pS8vw//cTQ8wrh+m/0iaUijzw44pdwQAo3NHUFz8I/AKbL1nKTbFs8jKs0aODVca+/s/4jPbV56gMgwMZOQcuvCrqKCCI27GRt8xj+LKerV3KwLMzJpTj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Drne/UPP; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Drne/UPP"
Date: Sat, 1 Feb 2025 16:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738445081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KvU32ei2vVgo2pDt9gpN5Ou+WbFmSMgZqQnjh2Nxa+8=;
	b=Drne/UPPVQtbAZ60EwZrSowhrra+QTlbStpS4brS4LyEsAEhIvjw5c2b9f3cTWzbD28pHn
	GaIA8cMqzfjxOtyWxaH6q7/nJONxYj1X+zDyioOmCh3aFWagBgLiIMKxwFu/Si1hmTN9xd
	JUg1bhcP/23nBeQ+ChoCdXAoJ0zmhLA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jeongjun Park <aha310510@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] bcachefs: fix deadlock in journal_entry_open()
Message-ID: <2iainwxojhulyf7oyga5xboufhiztz4boiqaofppopeduicwjt@pxj756ofltru>
References: <20250201195044.28007-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250201195044.28007-1-aha310510@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 02, 2025 at 04:50:44AM +0900, Jeongjun Park wrote:
> In the previous commit b3d82c2f2761, code was added to prevent journal sequence
> overflow. Among them, the code added to journal_entry_open() uses the
> bch2_fs_fatal_err_on() function to handle errors.
> 
> However, __journal_res_get() , which calls journal_entry_open() , calls
> journal_entry_open() while holding journal->lock , but bch2_fs_fatal_err_on()
> internally tries to acquire journal->lock , which results in a deadlock.
> 
> So we need to add a locked helper like bch2_journal_halt_locked() to handle
> fatal errors even when the journal->lock is held.
> 
> Fixes: b3d82c2f2761 ("bcachefs: Guard against journal seq overflow")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
>  fs/bcachefs/error.c    |  6 +++---
>  fs/bcachefs/fs-ioctl.c |  4 ++--
>  fs/bcachefs/journal.c  | 22 +++++++++++++++++-----
>  fs/bcachefs/journal.h  |  3 ++-
>  fs/bcachefs/recovery.c |  2 +-
>  fs/bcachefs/super.c    |  4 ++--
>  fs/bcachefs/super.h    |  2 +-
>  7 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
> index 038da6a61f6b..2482eb33b1ec 100644
> --- a/fs/bcachefs/error.c
> +++ b/fs/bcachefs/error.c
> @@ -20,7 +20,7 @@ bool bch2_inconsistent_error(struct bch_fs *c)
>  		return false;
>  	case BCH_ON_ERROR_fix_safe:
>  	case BCH_ON_ERROR_ro:
> -		if (bch2_fs_emergency_read_only(c))
> +		if (bch2_fs_emergency_read_only(c, false))

No, don't add a bool parameter. It'll be a lot less churny, and clearer
reading, if you add a separate

bch2_fs_emergency_read_only_locked()
helper

>  			bch_err(c, "inconsistency detected - emergency read only at journal seq %llu",
>  				journal_cur_seq(&c->journal));
>  		return true;
> @@ -46,7 +46,7 @@ int bch2_topology_error(struct bch_fs *c)
>  
>  void bch2_fatal_error(struct bch_fs *c)
>  {
> -	if (bch2_fs_emergency_read_only(c))
> +	if (bch2_fs_emergency_read_only(c, false))
>  		bch_err(c, "fatal error - emergency read only");
>  }
>  
> @@ -62,7 +62,7 @@ void bch2_io_error_work(struct work_struct *work)
>  	if (dev
>  	    ? __bch2_dev_set_state(c, ca, BCH_MEMBER_STATE_ro,
>  				  BCH_FORCE_IF_DEGRADED)
> -	    : bch2_fs_emergency_read_only(c))
> +	    : bch2_fs_emergency_read_only(c, false))
>  		bch_err(ca,
>  			"too many IO errors, setting %s RO",
>  			dev ? "device" : "filesystem");
> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
> index 15725b4ce393..92becb6ae5aa 100644
> --- a/fs/bcachefs/fs-ioctl.c
> +++ b/fs/bcachefs/fs-ioctl.c
> @@ -354,14 +354,14 @@ static int bch2_ioc_goingdown(struct bch_fs *c, u32 __user *arg)
>  		if (ret)
>  			break;
>  		bch2_journal_flush(&c->journal);
> -		bch2_fs_emergency_read_only(c);
> +		bch2_fs_emergency_read_only(c, false);
>  		bdev_thaw(c->vfs_sb->s_bdev);
>  		break;
>  	case FSOP_GOING_FLAGS_LOGFLUSH:
>  		bch2_journal_flush(&c->journal);
>  		fallthrough;
>  	case FSOP_GOING_FLAGS_NOLOGFLUSH:
> -		bch2_fs_emergency_read_only(c);
> +		bch2_fs_emergency_read_only(c, false);
>  		break;
>  	default:
>  		ret = -EINVAL;
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index 2cd20114b74b..4b3bdbfd7782 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -310,14 +310,23 @@ static void __journal_entry_close(struct journal *j, unsigned closed_val, bool t
>  	__bch2_journal_buf_put(j, old.idx, le64_to_cpu(buf->data->seq));
>  }
>  
> -void bch2_journal_halt(struct journal *j)
> +void bch2_journal_halt_locked(struct journal *j)
>  {
> -	spin_lock(&j->lock);
> +	lockdep_assert_held(&j->lock);
> +
>  	__journal_entry_close(j, JOURNAL_ENTRY_ERROR_VAL, true);
>  	if (!j->err_seq)
>  		j->err_seq = journal_cur_seq(j);
>  	journal_wake(j);
> -	spin_unlock(&j->lock);
> +}
> +
> +void bch2_journal_halt(struct journal *j, bool locked)
> +{
> +	if (!locked)
> +		spin_lock(&j->lock);
> +	bch2_journal_halt_locked(j);
> +	if (!locked)
> +		spin_unlock(&j->lock);
>  }
>  
>  static bool journal_entry_want_write(struct journal *j)
> @@ -382,9 +391,12 @@ static int journal_entry_open(struct journal *j)
>  	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
>  		return JOURNAL_ERR_max_in_flight;
>  
> -	if (bch2_fs_fatal_err_on(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
> -				 c, "cannot start: journal seq overflow"))
> +	if (journal_cur_seq(j) >= JOURNAL_SEQ_MAX) {
> +		bch_err(c, "cannot start: journal seq overflow");
> +		if (bch2_fs_emergency_read_only(c, true))
> +			bch_err(c, "fatal error - emergency read only");
>  		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
> +	}
>  
>  	BUG_ON(!j->cur_entry_sectors);
>  
> diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
> index cb0df0663946..23f5fd970b7d 100644
> --- a/fs/bcachefs/journal.h
> +++ b/fs/bcachefs/journal.h
> @@ -407,7 +407,8 @@ int bch2_journal_flush(struct journal *);
>  bool bch2_journal_noflush_seq(struct journal *, u64, u64);
>  int bch2_journal_meta(struct journal *);
>  
> -void bch2_journal_halt(struct journal *);
> +void bch2_journal_halt(struct journal *, bool);
> +void bch2_journal_halt_locked(struct journal *);
>  
>  static inline int bch2_journal_error(struct journal *j)
>  {
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 98825437381c..31549181888c 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -1076,7 +1076,7 @@ int bch2_fs_recovery(struct bch_fs *c)
>  	return ret;
>  err:
>  fsck_err:
> -	bch2_fs_emergency_read_only(c);
> +	bch2_fs_emergency_read_only(c, false);
>  	goto out;
>  }
>  
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index d97ea7bd1171..d3d11fb39632 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -400,11 +400,11 @@ static void bch2_fs_read_only_async(struct bch_fs *c)
>  	queue_work(system_long_wq, &c->read_only_work);
>  }
>  
> -bool bch2_fs_emergency_read_only(struct bch_fs *c)
> +bool bch2_fs_emergency_read_only(struct bch_fs *c, bool locked)
>  {
>  	bool ret = !test_and_set_bit(BCH_FS_emergency_ro, &c->flags);
>  
> -	bch2_journal_halt(&c->journal);
> +	bch2_journal_halt(&c->journal, locked);
>  	bch2_fs_read_only_async(c);
>  
>  	wake_up(&bch2_read_only_wait);
> diff --git a/fs/bcachefs/super.h b/fs/bcachefs/super.h
> index fa6d52216510..e9ff83e06ca2 100644
> --- a/fs/bcachefs/super.h
> +++ b/fs/bcachefs/super.h
> @@ -28,7 +28,7 @@ int bch2_dev_offline(struct bch_fs *, struct bch_dev *, int);
>  int bch2_dev_resize(struct bch_fs *, struct bch_dev *, u64);
>  struct bch_dev *bch2_dev_lookup(struct bch_fs *, const char *);
>  
> -bool bch2_fs_emergency_read_only(struct bch_fs *);
> +bool bch2_fs_emergency_read_only(struct bch_fs *, bool);
>  void bch2_fs_read_only(struct bch_fs *);
>  
>  int bch2_fs_read_write(struct bch_fs *);
> --
