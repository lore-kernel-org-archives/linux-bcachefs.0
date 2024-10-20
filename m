Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1387462
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729466591; cv=none; b=maeiPb2hmlPXz4M5GBsznzipJlYl6Gwx9bwG98bAFzeG62D0Bmy+bNrvxh2KxF5cUIGR+24ddsQWx2lPMd/UaY+5FrfOm4VfcvqV7q8ybrW2OP06DxkXbHyu9q30vsbCtO5CLl1mr+ClMeR4Ua1eR0eLy9W5Q2+MOzNg01W95Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729466591; c=relaxed/simple;
	bh=T7uRNOqXPpDJ66mNu6+5SQJLlQtpLfm/G3nL3qd0+Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIfpxXIPs5PY2RmJ/YrICW7vORRtB8S1/ObmMkoxFjWJ/FZLqlVg8T2WlH0/LJUvYsmWo2xy/kB6vIgIHVHsC7xpvmUYXdpAAJz01/b2lbSsYR5biJkvfvPkzZGxBlyFMBD9r/YmSFtZtuAxueMxcvw4iCVQxXJn+I81QW6r+2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TmfcKBSZ; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TmfcKBSZ"
Date: Sun, 20 Oct 2024 19:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729466586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DYwUO71iJxjfdmXJVtQz+BNTm0SpwTgVf3GOfBoEnXs=;
	b=TmfcKBSZOHm2BmMu3epYRnKjwnqle3S010yNgt/DqvW9ovSOhBqxVOjvF7tQetfeD402PX
	HeR9kBsG7V+fKNZywlruKnfchafGlqphdDqMqVcq2PUTZZQRJ9lCMZfBHDcyQ3yu6OJgVb
	kVnYHS/+24FiHk7PfY21Fodi3l8VaXs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: Re: [PATCH v1] bcachefs: set freespace inited to false if
 trans_mark_dev_sbs fails
Message-ID: <b22xc632ptvw3jtkyp5yqj6lxpnbdwlmqxekafuunjxxsaup7n@jrybxzaqj4li>
References: <20241020170708.67044-2-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241020170708.67044-2-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 05:08:45PM +0000, Piotr Zalewski wrote:
> In bch2_fs_initialize if bch2_trans_mark_dev_sbs fails, set freespace
> initialized bits to 0 in member's flags and update member cached version
> for each device. bch2_trans_mark_dev_sbs fails just before freespace
> init which can left freespace init bits set to true erroneously which later
> can indirectly trigger BUG condition in bch2_bucket_alloc_freelist[1].

Err...

freespace_initialized shouldn't even be set at this point, it's set
later, in bch2_fs_freespace_init(), naturally.

So - syzbot is feeding us garbage, heh. BCH_MEMBER_FREESPACE_INITIALIZED
should be false on a non initialized filesystem.

So we actually should be unconditially clearing it (sanitizing our
input) at the top of bch2_fs_initialize().

> 
> [1] https://syzkaller.appspot.com/bug?extid=2b6a17991a6af64f9489
> 
> Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2b6a17991a6af64f9489
> Fixes: bbe682c76789 ("bcachefs: Ensure devices are always correctly initialized")
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
> ---
>  fs/bcachefs/recovery.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 67bba156cce9..bcec79122f65 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -1031,6 +1031,7 @@ int bch2_fs_initialize(struct bch_fs *c)
>  	struct bkey_inode_buf packed_inode;
>  	struct qstr lostfound = QSTR("lost+found");
>  	int ret;
> +	struct bch_member *m;
>  
>  	bch_notice(c, "initializing new filesystem");
>  	set_bit(BCH_FS_new_fs, &c->flags);
> @@ -1086,8 +1087,17 @@ int bch2_fs_initialize(struct bch_fs *c)
>  	bch_verbose(c, "marking superblocks");
>  	ret = bch2_trans_mark_dev_sbs(c);
>  	bch_err_msg(c, ret, "marking superblocks");
> -	if (ret)
> +	if (ret) {
> +		mutex_lock(&c->sb_lock);
> +		for_each_member_device(c, ca) {
> +			m = bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx);
> +			SET_BCH_MEMBER_FREESPACE_INITIALIZED(m, false);
> +			ca->mi = bch2_mi_to_cpu(m);
> +		}
> +		mutex_unlock(&c->sb_lock);
> +
>  		goto err;
> +	}
>  
>  	for_each_online_member(c, ca)
>  		ca->new_fs_bucket_idx = 0;
> -- 
> 2.47.0
> 
> 
