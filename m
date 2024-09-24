Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5351B85CF
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 00:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727137622; cv=none; b=klTJR9DPk1sPmRlv0rdYPTGBdlEsruIsjrQbKSeD0FrfZpiMG/GyQuCA95HaEcO9LBeGTlIQitMw0HZ3p81UgMYpckxzj7JQbXr81p4l95m6HmNNRFwzaWAnVG6YcKeaYOFs1RuauBqJo3xhkpuaSM5Cuf/jf0zSkapTdJKR45Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727137622; c=relaxed/simple;
	bh=MiqrNSlg+44f01IzPJi9mHsBBi1DomNGgqfbi3VVwEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Anjn3vBxrRht6tRoE7thdfCdeXICPt9IJdWkTVBaw08CsbIODJNqC2y9qkMDqp45NV8DibKFqVCLPenxNKQTrR7g92BxU5slOVZ0yyKBNrHnt9d2/bG0qRi3+PlObN90UPTt3Si8aor9i0i+iYCGEQhD/3xJ7iN6WUNNy2XL6MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=d4fT87Xp; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="d4fT87Xp"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2d87a1f0791so3337499a91.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727137620; x=1727742420; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JK4Kr1m/oVIakm4mWT76ufbvRCh+HsuClIHKd5DZ0t4=;
        b=d4fT87XpnoKp18EmzEM9Mc5z+04sJ51i8Z4d9vUWzpZthe56O2Lixsk9q+AigWOguS
         0fca5dpfMyrSyyf8bDvUzEGSdoy4lFPgo7c357zzJSQh3oQEtsnuscLlA1zkvfzhHFHP
         yuwFU0CynhesGxAtG72vvlw97a3hZTOjLsolmTPkYnfiwHGgVbQBcqbbaR30FHMPBI/z
         bzKi88jIcRUudvufe1LViAl/eOtjuD2ReL4z18IqfgMdOyA3RjJ/LkGrC0tmD2Ns+Q3u
         4TDEerAy3HpwXf2QZzYF68ZsBFQIPoQkskaDG0Q+3Arm4NrbuzaRQFirOyjmPZY9pPS9
         u67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727137620; x=1727742420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JK4Kr1m/oVIakm4mWT76ufbvRCh+HsuClIHKd5DZ0t4=;
        b=OtcOmVkEW/dB/5ty5po2LJa3MNKRfz/sX80X0njs7JuZzBKljz5P6blDX+c7T8JQWY
         dv9xiwTvBwnewLF33kfpaGb+pbX+guyltSje9hQQmLn/koK0IOWXT3G0q2bTyKBVNt37
         0qrqPq/XduRxSGOMuVFwG2Egm1pag00e6NrZ6QJyDNi3F1u4ebSaKCVYKCScv45DbfHh
         Q2pPMjQiRRlfmURp7Hi2phF/avln72+vyuQILb9KRU5a0ROdLTwv7DzPgUGdUaPO1/bm
         rRQ4Wzd+rBAjc340wDQOlRhIwjOogeTMRWSy7DA29eFqT7HbsQUkTJgcEyQEqMRfqPAP
         VBuw==
X-Forwarded-Encrypted: i=1; AJvYcCXUiNzkUkz7yoVv5WGl+QHIM2OWDZd+NSgvQ15ftHVT5hZnJtdukYfd6b/2dNrYtmcKvwHSFWQXRvyRq3JIYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGChtexyB9q4dTBxAzD8bg6UPzvEVBsD+g0w21vNWBsV2r5Nli
	sNuZv/TlVzGWG4WVfoY9ZS3yhk9b1J0W3+K6k0aXuA/0N+xP3o88fF1uLAlSEhhDNgNzLY9Xd/k
	P
X-Google-Smtp-Source: AGHT+IE+8TYB1lIrpzLxFc760Tit5J+12CfpY8WVHSS7floKFRr87w5lnmGZpStHzJ2yd9xn4qqYHQ==
X-Received: by 2002:a17:90b:4b83:b0:2d3:d68e:e8d8 with SMTP id 98e67ed59e1d1-2dd7f752757mr13245883a91.40.1727137620231;
        Mon, 23 Sep 2024 17:27:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee984f0sm10099112a91.19.2024.09.23.17.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 17:26:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sstOK-009Ckm-2u;
	Tue, 24 Sep 2024 10:26:56 +1000
Date: Tue, 24 Sep 2024 10:26:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
Message-ID: <ZvIHUL+3iO3ZXtw7@dread.disaster.area>
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
 <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>

On Mon, Sep 23, 2024 at 03:56:50PM -0400, Kent Overstreet wrote:
> On Mon, Sep 23, 2024 at 10:18:57AM GMT, Linus Torvalds wrote:
> > On Sat, 21 Sept 2024 at 12:28, Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > We're now using an rhashtable instead of the system inode hash table;
> > > this is another significant performance improvement on multithreaded
> > > metadata workloads, eliminating more lock contention.
> > 
> > So I've pulled this, but I reacted to this issue - what is the load
> > where the inode hash table is actually causing issues?
> > 
> > Because honestly, the reason we're using that "one single lock" for
> > the inode hash table is that nobody has ever bothered.
> > 
> > In particular, it *should* be reasonably straightforward (lots of
> > small details, but not fundamentally hard) to just make the inode hash
> > table be a "bl" hash - with the locking done per-bucket, not using one
> > global lock.
> 
> Dave was working on that - he posted patches and it seemed like they
> were mostly done, not sure what happened with those.

I lost interest in that patchset a long while ago. The last posting
I did was largely as a community service to get the completed,
lockdep and RTPREEMPT compatible version of the hashbl
infrastructure it needed out there for other people to be able to
easily push this forward if they needed it. That was here:

https://lore.kernel.org/linux-fsdevel/20231206060629.2827226-1-david@fromorbit.com/

and I posted it because Kent was asking about it because his
attempts to convert the inode hash to use rhashtables wasn't
working.

I've suggested multiple times since then when people have asked me
about that patch set that they are free to pick it up and finish it
off themselves. Unfortunately, that usually results in silence, a
comment of "I don't have time for that", and/or they go off and hack
around the issue in some other way....

> > But nobody has ever seemed to care before. Because the inode hash just
> > isn't all that heavily used, since normal loads don't look up inodes
> > directly (they look up dentries, and you find the inodes off those -
> > and the *dentry* hash scales well thanks to both RCU and doing the
> > bucket lock thing).

Not entirely true.

Yes, the dentry cache protects the inode hash from contention when
the workload repeatedly hits cached dentries.

However, the problematic workload is cold cache operations where
the dentry cache repeatedly misses. This places all the operational
concurrency directly on the inode hash as new inodes are inserted
into the hash. Add memory reclaim and that adds contention as it
removes inodes from the hash on eviction.

This happens in workloads that cycle lots of inode through memory.
Concurrent cold cache lookups, create and unlink hammer the global
filesystem inode hash lock at more than 4 active tasks, especially
when there is also concurrent memory reclaim running evicting inodes
from the inode hash.

This inode cache miss contention issue was sort-of hacked around
recently by commit 7180f8d91fcb ("vfs: add rcu-based find_inode
variants for iget ops"). This allowed filesystems filesystems to use
-partially- RCU-based lookups rather fully locked lookups. In the
case of a hit, it will be an RCU operation, but as you state, cache
hits on the inode hash are the rare case, not the common case.

I say "sort-of hacked around" because the RCU lookup only avoids the
inode hash lock on the initial lookup that misses. Then insert is
still done under the inode_hash_lock and so inode_hash_lock
contention still definitely exists in this path. All the above
commit did was move the catastrophic cacheline contention breakdown
point to be higher than the test workload that was being run could
hit.

In review of that commit, I suggested that the inode hash_bl
conversion patches be finished off instead, but the response was "I
don't have time for that".

And so here we are again....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
