Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B98E14882D
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Aug 2024 02:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724208941; cv=none; b=FWF+IglpqGAVlRUHpHeF8Prz7LaXt5HlPX7VsK/aWIdY44EkMkVcg8FqFH6HrsANH2j1Na+64EPVezk8oDZGd3xepA+X5TwlIsy7yQv8po8Q0TpFzKubykg2PYVoR9LWCPXBBPzOYozKccyp0geVJcGs3LCN1RNwTvcXcgVuwMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724208941; c=relaxed/simple;
	bh=cTtqvFNjAGvd7oVCrrsJ/MmyHn8rlOb0xSjH7VWLcAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQnpioGlvVppeyaacjC8JUpbKxFH4oiLw1+qn32co39jk1a5Cr1yc7Owq5z0oM8WnlCKEJzr4Ws81za9NJ5iJ4st4SYKW83beFOZjOCG8cOs0mK4hRBS+LA1ZjPsHuAZo4hs7bT7Cq/QMqJqAKgOjENmI6V/dBjfyjRI5Y9oYMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KF38pw7c; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KF38pw7c"
Date: Tue, 20 Aug 2024 22:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724208937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YPpwEYqBs+F7d8bXsC8ABXrt7azGc68SjA8QbQj4LQI=;
	b=KF38pw7cp6VUyPffgdTIHGy4j1oduaRHKRDLCNcjrqeQz6ZOysA6vcSxDzo+pm6yLca56i
	MC178K60QozMhvOO2VPXHl67Rg/K7Ivrq2r9pYx31/JqS1dW2xvL4B10KwSXDjObsjEd/N
	uCt5gL9owfIlQb7hnYwXdSp1QvDjzts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] bcachefs: Add journal v2 entry nr value check
Message-ID: <kx4yjcxjjjj3yfufcdcvpbtrd65xl2x3x52pzv32ul5jh6ohia@ws5ovtvadau5>
References: <rtuy45ppvbi7yoighz2uvxwauotsyt5jr6kwfp4bsp2g43f342@k4hnm3xmqotz>
 <20240821023355.1619187-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821023355.1619187-1-lizhi.xu@windriver.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 21, 2024 at 10:33:55AM GMT, Lizhi Xu wrote:
> On Tue, 20 Aug 2024 19:34:18 -0400, Kent Overstreet wrote:
> > > When journal v2 entry nr overflow, it will cause the value of ja->nr to
> > > be incorrect, this will result in the allocated memory to ja->buckets
> > > being too small, leading to out of bounds access in bch2_dev_journal_init.
> > >
> > > Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
> > > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > > ---
> > >  fs/bcachefs/journal_sb.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/fs/bcachefs/journal_sb.c b/fs/bcachefs/journal_sb.c
> > > index db80e506e3ab..db2b2100e4e5 100644
> > > --- a/fs/bcachefs/journal_sb.c
> > > +++ b/fs/bcachefs/journal_sb.c
> > > @@ -119,6 +119,11 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
> > >  	for (i = 0; i < nr; i++) {
> > >  		b[i].start = le64_to_cpu(journal->d[i].start);
> > >  		b[i].end = b[i].start + le64_to_cpu(journal->d[i].nr);
> > > +		if (le64_to_cpu(journal->d[i].nr) > UINT_MAX) {
> > > +			prt_printf(err, "journal v2 entry d[%u].nr %llu overflow\n",
> > > +				i, le64_to_cpu(journal->d[i].nr));
> > > +			goto err;
> > > +		}
> > 
> > no, you need to sum up _all_ the entries and verify the total doesn't
> > overflow UINT_MAX
> The overflow value of le64_to_cpu(journal->d[i].nr) is 18446744073709551615(for u64),
> or in other words, it is -1 for s64.
> 
> Therefore, the existing check for single entry is retained, and an overflow
> check for the total value of all entry is will added.

No, this is completely broken.
