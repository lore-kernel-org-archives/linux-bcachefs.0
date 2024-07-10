Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971DC18FC93
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720629960; cv=none; b=RmRiOIeEGns8aSzNuBYUt8Uo5DZAwBmty5v53U58j3+pdd0bTlF1uLauAQtnJ9uzHDMO/T7TlfqPTJF2rCeMQA8jxO23YSMsrodkE4srcRZqBwAf0xXHbklz+GF4ivwUltrdGxc6FpcKMuFYHMI5wAkEjJ1bP2wWbdVJrsv3fUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720629960; c=relaxed/simple;
	bh=p1+1OnlH5raC55JmEENqaaod5E0bYD5UMM3bt0Nc3qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GASOGhE21YN7oO2E61C5n0thzd1nu/3UTbleWe4rZMoebF6dX2Gn5qJ2OXnbcae9puw1n2h317WBKDAP7KiCRRg2TpqPw4m7F2C3XAF0VH98PDj4H/DzHSTtQtXP754TvdSEMHptV2tR/Rw/5DBAlZRsApjCqGOjkMjHNtfMhys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W7kOUqc6; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W7kOUqc6"
X-Envelope-To: peili.dev@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720629956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n/h15YrO+R+Zia0lKtW37Z8KbW+iOs4EBNwbW9/ff/I=;
	b=W7kOUqc61ABNbp/+7M6a4ePJUm5b1nr4oT/O8jrf9bbpELxpxYmS1pZMbAiLu708UVmMLu
	2Gxau5HwoM7zEVToCYOvj5vK+aC9jNZ5f4TUVOFWoeEEbVhISNkfhAZ4Z1+hSzfowU/6yU
	tKwxw2ge1KxWGhEF23lOXmelP6QgQF0=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: skhan@linuxfoundation.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
X-Envelope-To: linux-kernel-mentees@lists.linuxfoundation.org
X-Envelope-To: syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
Date: Wed, 10 Jul 2024 12:45:54 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Pei Li <peili.dev@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com, 
	linux-kernel-mentees@lists.linuxfoundation.org, syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
Subject: Re: [PATCH] Fix WARNING: suspicious RCU usage in
 bch2_bucket_ref_update
Message-ID: <btghyyjqr53g4duu2b3ucbo2yksupsox2fcsniugceej2fbfqx@7tvxssrbctoo>
References: <20240710-bug10-v1-1-f1f8cf98f7c0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710-bug10-v1-1-f1f8cf98f7c0@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 10, 2024 at 08:33:24AM GMT, Pei Li wrote:
> When dereference ca->bucket_gens, we are expecting one of the three
> locks to be hold if ca->fs is not NULL.
> 
> This patch acquires mark_lock before entering __mark_pointer()
> 
> Note: testing is done by a robot and is best-effort only.
> 
> To: Kent Overstreet <kent.overstreet@linux.dev>
> To: Brian Foster <bfoster@redhat.com>
> Cc: linux-bcachefs@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: skhan@linuxfoundation.org
> Cc: syzkaller-bugs@googlegroups.com
> Cc: linux-kernel-mentees@lists.linuxfoundation.org
> Reported-by: syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e74fea078710bbca6f4b
> Tested-by: syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
> Signed-off-by: Pei Li <peili.dev@gmail.com>
> ---
> Syzbot reported the following warning:
> 
> fs/bcachefs/buckets.h:107 suspicious rcu_dereference_check() usage!
> 
> When dereference ca->bucket_gens, we are expecting one of the three
> locks to be hold if ca->fs is not NULL.
> 
> This patch acquires mark_lock before entering __mark_pointer()
> 
> Tested on:
> 
> commit:         34afb82a Merge tag '6.10-rc6-smb3-server-fixes' of git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1492e87e980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=42a432cfd0e579e0
> dashboard link: https://syzkaller.appspot.com/bug?extid=e74fea078710bbca6f4b
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=15e2e87e980000
> 
> Note: testing is done by a robot and is best-effort only.
> ---
>  fs/bcachefs/buckets.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
> index 743d57eba760..03147e46dc47 100644
> --- a/fs/bcachefs/buckets.c
> +++ b/fs/bcachefs/buckets.c
> @@ -1033,8 +1033,14 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
>  
>  	if (flags & BTREE_TRIGGER_transactional) {
>  		struct bkey_i_alloc_v4 *a = bch2_trans_start_alloc_update(trans, bucket);
> +
> +		percpu_down_read(&c->mark_lock);
> +
>  		ret = PTR_ERR_OR_ZERO(a) ?:
>  			__mark_pointer(trans, ca, k, &p.ptr, *sectors, bp.data_type, &a->v);
> +
> +		percpu_up_read(&c->mark_lock);

This is much heavier than we need, a more localized rcu_read_lock() is
sufficient. This is in my tree (neglected to include it with today's
pull request, whoops).

commit 5df2f4ffe8bb9bead346f4768df603fa575678df
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Jul 9 16:43:01 2024 -0400

    bcachefs: Fix RCU splat
    
    Reported-by: syzbot+e74fea078710bbca6f4b@syzkaller.appspotmail.com
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 743d57eba760..314ee3e0187f 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -805,7 +805,7 @@ int bch2_bucket_ref_update(struct btree_trans *trans, struct bch_dev *ca,
 			"bucket %u:%zu gen %u (mem gen %u) data type %s: stale dirty ptr (gen %u)\n"
 			"while marking %s",
 			ptr->dev, bucket_nr, b_gen,
-			*bucket_gen(ca, bucket_nr),
+			bucket_gen_get(ca, bucket_nr),
 			bch2_data_type_str(bucket_data_type ?: ptr_data_type),
 			ptr->gen,
 			(printbuf_reset(&buf),
diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index 80ee0be9793e..8ad4be73860c 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -116,6 +116,14 @@ static inline u8 *bucket_gen(struct bch_dev *ca, size_t b)
 	return gens->b + b;
 }
 
+static inline u8 bucket_gen_get(struct bch_dev *ca, size_t b)
+{
+	rcu_read_lock();
+	u8 gen = *bucket_gen(ca, b);
+	rcu_read_unlock();
+	return gen;
+}
+
 static inline size_t PTR_BUCKET_NR(const struct bch_dev *ca,
 				   const struct bch_extent_ptr *ptr)
 {
