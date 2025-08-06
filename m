Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B971A83F7
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 17:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499742; cv=none; b=JWn6aP1vmeowNnNIeIrwIzjVlCBNeUiUi2oLdrV1JXi+HoL2JPk2+vUeINHJgsw2ZIaMjdeXhpWlkQJ5A6XKFrQEbv2qNMgHg6eeEIQfHmRxRDp/RZsOaWZTuB4AvaFJC42TMaqQBw9bD4LBcACeKK3JQB0br6DpdL+mH9IkIGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499742; c=relaxed/simple;
	bh=zaUoGFbaAYuePo6YHEpVrJpE6jngdPJhZ6VcMIkj7jI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpXMuzz8Ku7IVxKSqetPqOozc0F8Wor7jiwJApGLHvIK2FqMxX6dIuE35hVhRY0w4ed0P5kHJJFG0Tssp5u0u43bt9ANBedykWU8w8rSl29PtK36lODwQnW1kY+8xWfjdHuTsSoYmh/aVK7ow91lXTjARRYu2i1IVft6W3eJM0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g2UiFtiU; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g2UiFtiU"
Date: Wed, 6 Aug 2025 13:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754499736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mrVEIPUCAfdNo2cWJ8/9cyDYeTTHWe9P0fKLxURvCRA=;
	b=g2UiFtiU+ktbX03+8uyO5DsZlL4A6CYLNMwixGIU7vQIn4UZTn0D37dSLaDufIKj40uFGa
	bSfJBWfavzO9s8mYsZ9eCOXgH4TBz5rjTSeTO6NGmuIknTkeB/5RlyZwW1YcOi3aaLiEIb
	6BSdFeDKLHHw0YCRUX1XISMR5c0V8zQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: bch_err_throw()
Message-ID: <bdz4qbe7a7ngai35v7crwtcvrbsmqsryhpx6obaj5i5nzw2gyb@cfqacrxzis6n>
References: <aJNAE5KV22lYAq_A@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJNAE5KV22lYAq_A@stanley.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 06, 2025 at 02:44:19PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> Commit 09b9c72bd4b7 ("bcachefs: bch_err_throw()") from May 28, 2025
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	fs/bcachefs/journal_sb.c:213 bch2_journal_buckets_to_sb()
> 	error: we previously assumed 'c' could be null (see line 197)
> 
> fs/bcachefs/journal_sb.c
>     191 int bch2_journal_buckets_to_sb(struct bch_fs *c, struct bch_dev *ca,
>     192                                u64 *buckets, unsigned nr)
>     193 {
>     194         struct bch_sb_field_journal_v2 *j;
>     195         unsigned i, dst = 0, nr_compacted = 1;
>     196 
>     197         if (c)
>                 ^^^^^^
> Here we assume c can be NULL.
> 
>     198                 lockdep_assert_held(&c->sb_lock);
>     199 
>     200         if (!nr) {
>     201                 bch2_sb_field_delete(&ca->disk_sb, BCH_SB_FIELD_journal);
>     202                 bch2_sb_field_delete(&ca->disk_sb, BCH_SB_FIELD_journal_v2);
>     203                 return 0;
>     204         }
>     205 
>     206         for (i = 0; i + 1 < nr; i++)
>     207                 if (buckets[i] + 1 != buckets[i + 1])
>     208                         nr_compacted++;
>     209 
>     210         j = bch2_sb_field_resize(&ca->disk_sb, journal_v2,
>     211                          (sizeof(*j) + sizeof(j->d[0]) * nr_compacted) / sizeof(u64));
>     212         if (!j)
> --> 213                 return bch_err_throw(c, ENOSPC_sb_journal);

This is a real bug.

>                                              ^
> The patch adds an unchecked dereference
> 
>     214 
>     215         bch2_sb_field_delete(&ca->disk_sb, BCH_SB_FIELD_journal);
>     216 
>     217         j->d[dst].start = cpu_to_le64(buckets[0]);
>     218         j->d[dst].nr        = cpu_to_le64(1);
>     219 
>     220         for (i = 1; i < nr; i++) {
>     221                 if (buckets[i] == buckets[i - 1] + 1) {
>     222                         le64_add_cpu(&j->d[dst].nr, 1);
>     223                 } else {
>     224                         dst++;
>     225                         j->d[dst].start = cpu_to_le64(buckets[i]);
>     226                         j->d[dst].nr        = cpu_to_le64(1);
>     227                 }
>     228         }
>     229 
>     230         BUG_ON(dst + 1 != nr_compacted);
>     231         return 0;
>     232 }
> 
> regards,
> dan carpenter
