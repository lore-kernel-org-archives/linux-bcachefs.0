Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919B1217F2E
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 01:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729905439; cv=none; b=Fi6hopImpnGFpnB3alTq00Z7o4NG0thLE+sIl9rE21U6eDnW8OmqzypYC7GQdRDHfrnKFo7FnBdAtPAQ02b7k3closac1/fbslQTNNVc1mrcgHQqRA7vMBScnVCqB0CVyH9Vql2pDVIlRxUInqHkM87tN2XkJbGiIR9cW5pn/Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729905439; c=relaxed/simple;
	bh=yku16IpmXqKjfqlU/QIrNWCB6Pug1Po8pO4b0FoB29s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOsH0EFAWU81NHo+mXUKOBAarBk9QvgNBUYPb534aJoQ05zqW/td8AK2qhXQy4AdqOcBuRssGJ1Qmu68aP3seWl+9NOrm846B6FtccrOExGkt6aoIqWb6wE9IzC4hy1G8AKomQLo3v2rl1111gyilTMuGUWHpgCFGqOUnqLgdbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p+UoFXJb; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p+UoFXJb"
Date: Fri, 25 Oct 2024 21:17:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729905433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XE+SMRKBuxgSK7mjawgqB0u1W5PNuYKDKH4Hgg1SwBs=;
	b=p+UoFXJbgQ2GofArJetSUnnSe7aWCJvfCFPe3xOU7Q4HV+xUnyD7SoxCVcOYqT9uRDd56V
	uFfNqXME6B/IZk8ZPC81TuzOyNAnPIbbsF/w/RYK2GLrqMOuTEzN2F1F+cmQI8HmXMq+Gz
	qPVaxHS0M+7ZTcLBRSPbvAchbMSRUAo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: Retrieve ext again after sb is reallocated
Message-ID: <43c3r56uapoeyc33lt6tunn5x772ngflxq6lpntodoj3g32s6t@ohktx3g4pkis>
References: <20241025100205.635960-1-lizhi.xu@windriver.com>
 <20241026010953.2380726-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026010953.2380726-1-lizhi.xu@windriver.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 09:09:53AM +0800, Lizhi Xu wrote:
> Syzbot reported a slab-use-after-free Read in bch2_reconstruct_alloc.
> The sb counters resize will cause sb reallocation and release the old sb,
> which leads to uaf in ext.
> After disk_sb.sb is reallocated, ext should be retrieved again to avoid uaf.
> 
> Reported-and-tested-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9fc4dac4775d07bcfe34
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/bcachefs/recovery.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 55e1504a8130..9df0969c29ce 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -59,6 +59,7 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
>  
>  	mutex_lock(&c->sb_lock);
>  	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
> +	void *sb;
>  
>  	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_allocations, ext->recovery_passes_required);
>  	__set_bit_le64(BCH_RECOVERY_PASS_STABLE_check_alloc_info, ext->recovery_passes_required);
> @@ -94,7 +95,10 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
>  	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
>  	c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
>  
> +	sb = c->disk_sb.sb;
>  	bch2_write_super(c);
> +	if (sb != c->disk_sb.sb)
> +		ext = bch2_sb_field_get(c->disk_sb.sb, ext);
>  	mutex_unlock(&c->sb_lock);
>  
>  	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));

There's a simpler fix:


From 8e910ca20e112d7f06ba3bf631a06ddb5ce14657 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Fri, 25 Oct 2024 13:13:05 -0400
Subject: [PATCH] bcachefs: Fix UAF in bch2_reconstruct_alloc()

write_super() -> sb_counters_from_cpu() may reallocate the superblock

Reported-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 454b5a32dd7f..0ebc76dd7eb5 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -94,11 +94,10 @@ static void bch2_reconstruct_alloc(struct bch_fs *c)
 	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
 	c->sb.compat &= ~(1ULL << BCH_COMPAT_alloc_info);
 
-	bch2_write_super(c);
-	mutex_unlock(&c->sb_lock);
-
 	c->opts.recovery_passes |= bch2_recovery_passes_from_stable(le64_to_cpu(ext->recovery_passes_required[0]));
 
+	bch2_write_super(c);
+	mutex_unlock(&c->sb_lock);
 
 	bch2_shoot_down_journal_keys(c, BTREE_ID_alloc,
 				     0, BTREE_MAX_DEPTH, POS_MIN, SPOS_MAX);
