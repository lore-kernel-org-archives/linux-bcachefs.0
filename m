Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB3910F2
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729989092; cv=none; b=ifa2BlFcSX4WrRGjg0fy6X2BVmEokO77VhCquHfglDZmCSwDcjAiiYgCCjTlWy0AEcOmGfEsG7fCV8ZZM1WWCJAbDIODz1wVgVqkD1ZvgiiAoXhIY25z3+A1eOHFCXpo8911XZ4xPJJLqckzcEBJ1H0Tue8pwjhuLLiwPeGkNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729989092; c=relaxed/simple;
	bh=AxQjNJMNtb5Ig+wEX+3dNxEwcjhsbhyazKjd1QodVoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A7UkdJdlNSJOUbb6kPiK+qCLq+vFScYQhMPkpyE/jSbLRX5lqNYOzEDfyTEtJA9ekgWlOYXUxBEoiEjooiotADixDWxZpYODUgsDWBzJ3rfh5KFPh+s4kY9gNvCB8mJXGFo7+9KdFBjs0X6M+dpA1IDEMtrolXTCh29u+bD1jvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xQbar68o; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xQbar68o"
Date: Sat, 26 Oct 2024 20:31:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729989087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CC5tdvNSbMUta9lym/OW72/o/Ad2YSbYbg3qK9DBOw4=;
	b=xQbar68odFUfkhyPrKdgYTXQ4cWCPlLYNHHHO2z2i8Fq5XlnhEBar86qjKyk27qcbaxFc0
	7nNL/RghMTfcTvLkD5i/LWNuHLG01WmnV3QriOx+1YdcgIR2wmX9ETtPYLcXgOosbb1FRc
	OvMib84KedR+qphTAadsDt/zEp8XcN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] bcachefs: init freespace inited bits to 0 in
 bch2_fs_initialize
Message-ID: <xjjlqqfu6oulfdndotkwr57z7adt6gaq26g67iiy7qv2pk3wv3@y6hv3sr7smjz>
References: <20241026001004.10470-2-pZ010001011111@proton.me>
 <zks5hk34if64nu4t7tsnjc2om4cdyo7fs62fgyxjzetr6njo72@ajmllmpmex45>
 <ZE-D4gWuaHm-NpPnk8yUxXY4ouYy492LCPmnEgWG3fiIleDRGZU9SjbSbYiVWPa2_OYirT-Jx_E7b5NsSh9s6Txvnkc0KRsGHNKHH1umkDE=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE-D4gWuaHm-NpPnk8yUxXY4ouYy492LCPmnEgWG3fiIleDRGZU9SjbSbYiVWPa2_OYirT-Jx_E7b5NsSh9s6Txvnkc0KRsGHNKHH1umkDE=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 01:40:47PM +0000, Piotr Zalewski wrote:
> On Saturday, October 26th, 2024 at 2:30 AM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Sat, Oct 26, 2024 at 12:15:49AM +0000, Piotr Zalewski wrote:
> > 
> > > Initialize freespace_initialized bits to 0 in member's flags and update
> > > member's cached version for each device in bch2_fs_initialize.
> > > 
> > > It's possible for the bits to be set to 1 before fs is initialized and if
> > > call to bch2_trans_mark_dev_sbs (just before bch2_fs_freespace_init) fails
> > > bits remain to be 1 which can later indirectly trigger BUG condition in
> > > bch2_bucket_alloc_freelist during shutdown.
> > > 
> > > Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=2b6a17991a6af64f9489
> > > Fixes: bbe682c76789 ("bcachefs: Ensure devices are always correctly initialized")
> > > Suggested-by: Kent Overstreet kent.overstreet@linux.dev
> > > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > > ---
> > > 
> > > Notes:
> > > changes in v3:
> > > - v2 rebased
> > > 
> > > changes in v2:
> > > - unconditionally set freespace initialized bits to false at
> > > the top of bch2_fs_initialized instead of only if
> > > bch2_trans_mark_dev_sbs fails
> > > 
> > > Link to v2: https://lore.kernel.org/linux-bcachefs/20241021174151.37692-2-pZ010001011111@proton.me/
> > > Link to v1: https://lore.kernel.org/linux-bcachefs/20241020170708.67044-2-pZ010001011111@proton.me/
> > > 
> > > fs/bcachefs/recovery.c | 8 ++++++++
> > > 1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> > > index fdf2aa2ffc13..8d4c93a1f5aa 100644
> > > --- a/fs/bcachefs/recovery.c
> > > +++ b/fs/bcachefs/recovery.c
> > > @@ -1029,6 +1029,7 @@ int bch2_fs_initialize(struct bch_fs *c)
> > > struct bch_inode_unpacked root_inode, lostfound_inode;
> > > struct bkey_inode_buf packed_inode;
> > > struct qstr lostfound = QSTR("lost+found");
> > > + struct bch_member *m;
> > > int ret;
> > > 
> > > bch_notice(c, "initializing new filesystem");
> > > @@ -1045,6 +1046,13 @@ int bch2_fs_initialize(struct bch_fs *c)
> > > SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata_version_current);
> > > bch2_write_super(c);
> > > }
> > > +
> > > + for_each_member_device(c, ca) {
> > > + m = bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx);
> > > + SET_BCH_MEMBER_FREESPACE_INITIALIZED(m, false);
> > > + ca->mi = bch2_mi_to_cpu(m);
> > > + }
> > > +
> > 
> > 
> > I'm also adding a write_super() call here: that's what updates
> > ca->mi.freespace_initialized which the freespace init path will later
> > 
> > check.
> 
> Do you want me to send v4? Or you will add it with separate patch?

I did it as a fixup to your patch
