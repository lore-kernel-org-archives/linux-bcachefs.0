Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9843FD4
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Aug 2024 03:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724210221; cv=none; b=beh8HUDCGv7WIMA91alCmUkL+NsfPZRVuYACQUJyxHDRL6iXO3VERTL2K031fJqHmUa9ldyvsG6HXcgK9Rw4FlPoXUVPf/tr72bZGc0PTeAHsCYrGHmDaUy112MpEbOJ2j7WwkSfxqL1hEIHaZlOA2O8tcB1f9ldLYQFC1rvFZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724210221; c=relaxed/simple;
	bh=tfch8IYzWGhgR+yxCWb+lHAGJnUkmjBy22N0VCEwhR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/Q7p6Wga5a4H8cBZI+xdlNCVINR8DjTGAmDQAeGD6tW3lSCaCKRyUaItbp6o0ui3mq2xH5VOq5aaVCrAL6WB4PZCVvBZOjzQwe++1We2g5S2HeX90Ls/Gg/5M0MTYm6LepWM4AO1UlIEz0JOSKzsiBMuGr9qpdQ5KM0BxRINpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P7RTonuO; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P7RTonuO"
Date: Tue, 20 Aug 2024 23:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724210215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P4ds8y5jCb0SmU1vec4ecScz2yVbc2oUT+7f08M9+1w=;
	b=P7RTonuOUyaqKbyf5f9Ci0untlvmdI40IoEEetJxV+aF4BAWDcu17wsghAMinxEvKD86D5
	2l6rrLcH7PfCDaLTa5koTGeUHi3NTwMYhkAouemfeAoV25pjeWmBUd3jL1DMzvTSQz5UhU
	EwL1OUdeqX82eu3qjEhi7M0BuYNXEK4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V3] bcachefs: Add journal v2 entry nr value check
Message-ID: <vr4n6n25sq5dtcr3njl44ev2dxrawpz6s6xwv6cpjfm33uqmay@uhieqhcxeuns>
References: <zdrkmfo2ln2t7e3oh3mz3yr2xs67qm3ea4wfe4fnv6zw4fk4pd@k5peuzfz5ods>
 <20240821031000.2087573-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821031000.2087573-1-lizhi.xu@windriver.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 21, 2024 at 11:10:00AM GMT, Lizhi Xu wrote:
> On Tue, 20 Aug 2024 23:00:05 -0400, Kent Overstreet wrote:
> > > When the nr value of a signle entry or their sum overflows, it will
> > > cause the value of ja->nr to be incorrect, this will result in the
> > > allocated memory to ja->buckets being too small, leading to out of
> > > bounds access in bch2_dev_journal_init.
> > > 
> > > Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
> > > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > > ---
> > >  fs/bcachefs/journal_sb.c | 16 +++++++++++++++-
> > >  1 file changed, 15 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/bcachefs/journal_sb.c b/fs/bcachefs/journal_sb.c
> > > index db80e506e3ab..230ed99130e4 100644
> > > --- a/fs/bcachefs/journal_sb.c
> > > +++ b/fs/bcachefs/journal_sb.c
> > > @@ -107,6 +107,7 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
> > >  	unsigned nr;
> > >  	unsigned i;
> > >  	struct u64_range *b;
> > > +	u64 total_nr = 0, entry_nr;
> > >  
> > >  	nr = bch2_sb_field_journal_v2_nr_entries(journal);
> > >  	if (!nr)
> > > @@ -117,8 +118,21 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
> > >  		return -BCH_ERR_ENOMEM_sb_journal_v2_validate;
> > >  
> > >  	for (i = 0; i < nr; i++) {
> > > +		entry_nr = le64_to_cpu(journal->d[i].nr);
> > > +		if (entry_nr > UINT_MAX) {
> > > +			prt_printf(err, "Journal v2 entry d[%u] nr %llu overflow\n",
> > > +				i, entry_nr);
> > > +			goto err;
> > > +		}
> > 
> > This check is unnecessary; we know the sum can't overflow a u64 because
> > we're also checking that the entries are nonoverlapping.
> You didn't read my previous email carefully.
> In this issue, journal->d[0] is 7, journal->d[1] is 18446744073709551615,
> so the sum of their u64 type values will definitely overflow.

It doesn't matter. We're already checking that the entries are
nonoverlapping, and within the range of [1, nbuckets), so total_nr can't
overflow nbuckets, much less an s64 (not that that matters).
