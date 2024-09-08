Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAA7EACD
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Sep 2024 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725804877; cv=none; b=J8jgkHZH4q3hjZON4BYNOfYFBDZKUirYkkjfvTb6WbczY76/7VI8ZY/cYfFn+3aXR5F+FILgt/UgRZXnsY5Hs/dO8NuDhPLG5CdnqPxMxLe8WkEVjxjh9dhYfYxYR5NWTIiXi9YbwbpbNvbU10RImH8b4eCSpnKMB98+TSPhLEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725804877; c=relaxed/simple;
	bh=pVG0GXqZOUpd40QUu1Jnj0BaAzBx8sg/oLdk6Nts00g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/pv6qisAdtqU4USfBLSsYo53cZv+gQ6lzDuPyRnXiSrOpKbUNfMoAhX0IBzMvChJGhu4Hbsqvd0Mj+WiPQKkwNjkr8DJgPmK7PiszMs6s8lk3UkiDSFP7yR8kg4KPE8lPbO1nR3t/pVPSsiPFnKW24rxt7pEWyHQx8x/cNgTCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vJXeX0+B; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vJXeX0+B"
Date: Sun, 8 Sep 2024 10:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725804873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFddgAzZNjUy5uTssPOtVJWQ0TFEeB5OYPJI1zXfgGk=;
	b=vJXeX0+BJZ3NH+qYik7gTN8hsHp25uAG/QWXJjIqz7YnU4jz2jfbmLKmNT3OjpM6EJD4Gj
	2bBS1vYkEOUI/Gc/KoYpK6fpdPHXufjjRBwl/xDBMNazl3c2t8JQr0bSfRVtA7enEzFsBF
	ic3VQ5Nzm8H5L0nJWMDGYYA6HkcPmU0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Edward Adam Davis <eadavis@qq.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in member_to_text
Message-ID: <rr2rkewhp7c4fcewi5mlpda44cjikwfuycrgaplpk53vgrp5vp@q7sj5mlnkm5c>
References: <hqzhbzxbp3rjbal3z4kdwygvus76h22o2br3iwuzohgniivw5q@etyntoz75vyp>
 <tencent_6FF377237A096263A9C4469779777566C805@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_6FF377237A096263A9C4469779777566C805@qq.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 08, 2024 at 08:59:37PM GMT, Edward Adam Davis wrote:
> On Wed, 4 Sep 2024 15:39:37 -0400, Kent Overstreet wrote: 
> > On Tue, Sep 03, 2024 at 10:13:02AM GMT, Edward Adam Davis wrote:
> > > Because the value of m.btree_bitmap_shift is 69 in this case, it cause
> > > shift-out-of-bounds in member_to_text.
> > >
> > > Add a check for btree_bitmap_shift in validate_member, when it bigger than 64
> > > return -BCH_ERR_invalid_sb_members.
> > > Simultaneously adjust the output mode of btree_bitmap_shift in member_to_text.
> > >
> > > #syz test
> > >
> > > diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> > > index 39196f2a4197..85a4245ea6a3 100644
> > > --- a/fs/bcachefs/sb-members.c
> > > +++ b/fs/bcachefs/sb-members.c
> > > @@ -162,6 +162,12 @@ static int validate_member(struct printbuf *err,
> > >  		return -BCH_ERR_invalid_sb_members;
> > >  	}
> > >
> > > +	if (m.btree_bitmap_shift > 64) {
> > 
> > should be >=, no?
> Yes, you are right, here should be "if (m.btree_bitmap_shift >= 64)"

Send me a proper patch and I'll apply...
