Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9FB208A0
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 03:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727148860; cv=none; b=heHxpIiTpgKpmX3ggMWgtISphr6II6kzinUGEuz1IJiwjwq7C+paw851KwgyC6K/cSMiQNJBCyCsV4OJnugqvWyJSj66AIRoeVl4BN0a61y4PtTOLhbouNjP1jHg8g4ZQkULUbpTcNBpyMhmtToWo1dsp3BcLEK6R75c2w/nZPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727148860; c=relaxed/simple;
	bh=z1dOkhvrMWny0ohbL42mv6n+7Xdf2nXp1JIvTFKjenw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZfyuaGuFD1IyigxXdsqhG5sajuIAT+6ck89iamm/FRqIHQesRROprC8xqxwrwqdvMj8PwVmgG3FTXkn14z3xaRlQZVcoxQT4tLZ2IbmUWx3aix9RYTgkt28XhhnlSlmWIUg/7GSjx1g4hE80xXIJxzg4phxGFhk/Z/0IlvQyhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YUpd9d/J; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YUpd9d/J"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20696938f86so39427445ad.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 20:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727148858; x=1727753658; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4/SKj4lWI1yJlZOtC07mR6A3SxW5HcZiLXldmOIyxwo=;
        b=YUpd9d/JlzZtdSZt+6CIO3OiWz7shf2HDWMi8QMtLoPNe1QbAfHjHmAgBjrtq7ypQJ
         GY6SBxFCJDUpcxV1rv+OOwQYS3XVjV4ffuyZmaAp54hx3SyTOCG6zukb691Tjh27pk4Q
         jsctXYtIm4s6kdvIfLfyMZ/vCBuJJgtxMysNWujULBltquRUYw2m6Sz8faOHRVaucI55
         3NHqhp3T+RYRCYPeir7bfZDfSTWKQsaVw5KLZ32i5jMwfF/gH+PTCTwVl7XuOTVFPUMr
         /Ys3oI+fq25fEldvQOogVZaqRm37fXiBvA11LSy2x2ZOhIVgWfUMe8eP1Bbw9Nz3v9FQ
         fcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727148858; x=1727753658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/SKj4lWI1yJlZOtC07mR6A3SxW5HcZiLXldmOIyxwo=;
        b=w8gBbu/ckJgxM+VuXz6Q3eCMg+8iGYjvyz0HMA2YvT4YXn20oLGXfFD0aM5PnLjkB7
         pQAzugeL5gHR+3AslVEfP438to3Ov75rEctA1adHr8ylfUCv/IET4tpEusNHb8J0SA/l
         Kgth/DRZYzZUH9FepgkigtQBmAu/GSKpTMNCMtmBjzwyqo7jMaBnFjcWdFTU2HvSpfk3
         xLdSei82GhVdVBqZRjyhLLlNjvLDLUieD7V/skWlkid0Wx2kTuVoF4NGzqgncVTrrEkt
         oRwFeiUR4kd8UiosnqDiPhIsunPWDGmHCY0JONUQBkudmRLZBoRk6DhABDFN7AEI7Xah
         bf9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTlY6r/rGSOLGwLUtvNkXxa3IQ6xWVjTn6hGUCnaqgzIMIbqkaKeYTZZRDUGIJI9FF9w6FjAfSGELSpC1wxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5OBzRVAoNEu5+SHXUh2QLGUQurk3ZmN+xGt4KdYUlJ2k99tqY
	6aehGm5zhXMhu69EprSaipdsYUMdun7Ks9rMbyq3m9YqGsUZ97esejYvidR3fig=
X-Google-Smtp-Source: AGHT+IH3lRAeJYZlmh0xwaPd9RsTWL2j6QkCXJrNFRv9mB3OVeKtUOXeyHBewN2Wk8kyVcvwOLtk2Q==
X-Received: by 2002:a17:902:d2d1:b0:205:40a6:115a with SMTP id d9443c01a7336-208d9872fc8mr201072425ad.48.1727148857727;
        Mon, 23 Sep 2024 20:34:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af16e0435sm2435535ad.13.2024.09.23.20.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 20:34:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sswJa-009GFU-0W;
	Tue, 24 Sep 2024 13:34:14 +1000
Date: Tue, 24 Sep 2024 13:34:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
Message-ID: <ZvIzNlIPX4Dt8t6L@dread.disaster.area>
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
 <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>
 <ZvIHUL+3iO3ZXtw7@dread.disaster.area>
 <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
 <74sgzrvtnry4wganaatcmxdsfwauv6r33qggxo27yvricrzxvq@77knsf6cfftl>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74sgzrvtnry4wganaatcmxdsfwauv6r33qggxo27yvricrzxvq@77knsf6cfftl>

On Mon, Sep 23, 2024 at 10:55:57PM -0400, Kent Overstreet wrote:
> On Mon, Sep 23, 2024 at 07:26:31PM GMT, Linus Torvalds wrote:
> > On Mon, 23 Sept 2024 at 17:27, Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > However, the problematic workload is cold cache operations where
> > > the dentry cache repeatedly misses. This places all the operational
> > > concurrency directly on the inode hash as new inodes are inserted
> > > into the hash. Add memory reclaim and that adds contention as it
> > > removes inodes from the hash on eviction.
> > 
> > Yeah, and then we spend all the time just adding the inodes to the
> > hashes, and probably fairly seldom use them. Oh well.
> > 
> > And I had missed the issue with PREEMPT_RT and the fact that right now
> > the inode hash lock is outside the inode lock, which is problematic.
> > 
> > So it's all a bit nasty.
> > 
> > But I also assume most of the bad issues end up mainly showing up on
> > just fairly synthetic benchmarks with ramdisks, because even with a
> > good SSD I suspect the IO for the cold cache would still dominate?
> 
> Not for bcachefs, because filling into the vfs inode cache doesn't
> require a disk read - they're cached in the inodes btree and much
> smaller there. We use a varint encoding so they're typically 50-100
> bytes, last I checked.
> 
> Compare to ~1k, plus or minus, in the vfs inode cache.
> 
> Thomas Bertshinger has been working on applications at LANL where
> avoiding pulling into the vfs inode cache seems to make a significant
> difference (file indexing in his case) - it turns out there's an xattr
> syscall that's missing, which I believe he'll be submitting a patch for.
> 
> But stat/statx always pulls into the vfs inode cache, and that's likely
> worth fixing.

No, let's not even consider going there.

Unlike most people, old time XFS developers have direct experience
with the problems that "uncached" inode access for stat purposes.

XFS has had the bulkstat API for a long, long time (i.e. since 1998
on Irix). When it was first implemented on Irix, it was VFS cache
coherent. But in the early 2000s, that caused problems with HSMs
needing to scan billions inodes indexing petabytes of stored data
with certain SLA guarantees (i.e. needing to scan at least a million
inodes a second).  The CPU overhead of cache instantiation and
teardown was too great to meet those performance targets on 500MHz
MIPS CPUs.

So we converted bulkstat to run directly out of the XFS buffer cache
(i.e. uncached from the perspective of the VFS). This reduced the
CPU over per-inode substantially, allowing bulkstat rates to
increase by a factor of 10. However, it introduced all sorts of
coherency problems between cached inode state vs what was stored in
the buffer cache. It was basically O_DIRECT for stat() and, as you'd
expect from that description, the coherency problems were horrible.
Detecting iallocated-but-not-yet-updated and
unlinked-but-not-yet-freed inodes were particularly consistent
sources of issues.

The only way to fix these coherency problems was to check the inode
cache for a resident inode first, which basically defeated the
entire purpose of bypassing the VFS cache in the first place.

So we went back to using coherent lookups once we stopped caring
about the old SGI HSM SLA requirements back in 2010:

commit 7dce11dbac54fce777eea0f5fb25b2694ccd7900
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Jun 23 18:11:11 2010 +1000

    xfs: always use iget in bulkstat

    The non-coherent bulkstat versionsthat look directly at the inode
    buffers causes various problems with performance optimizations that
    make increased use of just logging inodes.  This patch makes bulkstat
    always use iget, which should be fast enough for normal use with the
    radix-tree based inode cache introduced a while ago.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

Essentially, we now always being inodes into cache as fully
instantiated VFS inodes, and mark them with I_DONT_CACHE so they get
torn down immediately after we've used them if they weren't already
cached. (i.e. all accesses are done in a single task context with
the inode hot in the CPU caches.)

Without the patchset I pointed to, bulkstat maxxes out the VFS inode
cache cycling on the sb->s_inodes_list_lock at about 700,000
inodes/sec being cycled through the cache. With that patchset, it
maxxed out the bandwidth of the NVMe SSDs I was using  at ~7GB/s
read IO and cycling about 6 million inodes/sec through the VFS cache.

IOWs, we can make the VFS inode cache scale way beyond what most
users actually need right now.

The lesson in all this?

Don't hack around VFS scalability issues if it can be avoided.

If we fix the problems properly in the first place, then most fs
developers (let alone users!) won't even realise there was a
scalability problem in the VFS to begin with. Users will, however,
notice every inconsistency and/or corruption caused by fs developers
trying to work around VFS cache limitations...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
