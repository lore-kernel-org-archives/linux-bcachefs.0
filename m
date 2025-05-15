Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E0D221562
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 16:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747327054; cv=none; b=faliQ6NMI/ZQKZc5CBTr5u+XwPsnbEfq4i0LWktmFpiW5DBIIV0epHuN1qqsHdy107KMEue3XzYaMyiozFnGlhsugG4+q48ApTuX59NcmZfV9WxBPMJ7E+woRjsY/e7ecmBFOsD+LwyYRTFgf3Y91Puj1E1waFoFoQy0RXNbyKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747327054; c=relaxed/simple;
	bh=flyB85B4XuNeBe2WDDg2ejMUWK6drqTNWcli3/lSb9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYrYmPl1KiG66Qq7evx2J6s0Bm1wcWeFLa3zzjjHCPUzlLgeDhfxDlmvPND9b/YXYKWrRqZMWY0gHuSm82Ya/f+P6nj2H9Iq8fAEJogXW/9G15oC3XYAU52pbbYeW/yrp0pw45gYYPTlknYdqdk/wFpUjcrW4InNbSnxZklhP54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IWaD/0dA; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IWaD/0dA"
Date: Thu, 15 May 2025 12:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747327040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=63I5DhUG/0DfImS9lLDj6I2042OVqX3DtUBhO+F4V54=;
	b=IWaD/0dAaP+RiR3oAli31TDxZ37gNsog2jp8J5pmFu42LYMCEk11YC4mdFS59fFVtiUUtr
	A7Df23WBT7zIcQoWCxSDvWV9amr7wmU9vajjuVxvx0p4rt2FgkDrH+ZDd3chO78NV4pRyU
	MQb03zJ6imEMCLaTmlLwJX7e4o6Phhc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: syzbot <syzbot+3f0b3970f154dfc95e6e@syzkaller.appspotmail.com>, 
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, jmorris@namei.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, paul@paul-moore.com, roberto.sassu@huawei.com, serge@hallyn.com, 
	syzkaller-bugs@googlegroups.com, zohar@linux.ibm.com, linux-bcachefs@vger.kernel.org
Subject: Re: [syzbot] [lsm?] [integrity?] KMSAN: uninit-value in
 ima_add_template_entry (3)
Message-ID: <l7xs6ea7takb5yvyvobxoce3mudbgen5d7s47onksm4ujpdkib@tvstwbdpvm4o>
References: <6824aea8.a00a0220.104b28.0011.GAE@google.com>
 <38c28bd4dc40b2e992c13a6fdba820a667861d8c.camel@huaweicloud.com>
 <rbab6axciiuomrann3uwvpks2zogx3xfntk7w4p2betq3morlf@5xnl5guhnaxj>
 <576e10238d83f725fbe23c4af63be6e83de9ce48.camel@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576e10238d83f725fbe23c4af63be6e83de9ce48.camel@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 15, 2025 at 04:30:09PM +0200, Roberto Sassu wrote:
> On Thu, 2025-05-15 at 10:18 -0400, Kent Overstreet wrote:
> > On Thu, May 15, 2025 at 04:06:02PM +0200, Roberto Sassu wrote:
> > > On Wed, 2025-05-14 at 07:54 -0700, syzbot wrote:
> > > > Hello,
> > > 
> > > + Kent, bcachefs mailing list
> > > 
> > > I have the feeling that this was recently fixed in one of the latest
> > > pull requests in bcachefs. I don't see it occurring anymore, and there
> > > are more commits after the one reported by syzbot.
> > 
> > I have no idea how any of the ima stuff works or even what it does, I'm
> > not even sure where I'd start...
> 
> Basically, I got a clue that bcachefs would be the cause from the
> bottom of the report:
> 
>  page_cache_sync_ra+0x108a/0x13e0 mm/readahead.c:621
>  filemap_get_pages+0xfb3/0x3a70 mm/filemap.c:2591
>  filemap_read+0x5c6/0x2190 mm/filemap.c:2702
>  bch2_read_iter+0x559/0x21c0 fs/bcachefs/fs-io-direct.c:221
>  __kernel_read+0x750/0xda0 fs/read_write.c:528
>  integrity_kernel_read+0x77/0x90 security/integrity/iint.c:28
> 
> This means that IMA is reading a file and calculating a digest over it:
> 
>  ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:498 [inline]
>  ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
>  ima_calc_file_hash+0x240a/0x3fd0 security/integrity/ima/ima_crypto.c:568
>  ima_collect_measurement+0x45d/0xe60 security/integrity/ima/ima_api.c:293
>  process_measurement+0x2d1a/0x40e0 security/integrity/ima/ima_main.c:385
>  ima_file_check+0x8e/0xd0 security/integrity/ima/ima_main.c:613
> 
> syzbot is complaining that the data the digest was calculated from was
> not initialized (e.g. zeroed).
> 
> There is a reproducer, we would be probably able to do a bisection and
> find the commit that caused it (and maybe the one that fixed it).

Ok, that would be fixed by the - multiple - KMSAN fixes, most of those
were spurious but code was lacking annotations. Probably this one:

9c3a2c9b471a bcachefs: Disable asm memcpys when kmsan enabled
