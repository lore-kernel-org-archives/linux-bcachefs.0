Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DCC22D4FA
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 May 2025 13:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711897; cv=none; b=cK3Tt8gIpHPa0MdghmMOtC5EbkEnUy/spVAYFMyYUxc2frfsZqMrClJgzapq90iFgdWw+5qwxGB0wZ3OV3uDL93rHEfh62u3iBAlxGBw8gkBkmlaWzHXX2Y8UZBIbVhJE9kR4i0H2DDyidpMDilr8M+ZvAr4M4DwByFjj4/zT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711897; c=relaxed/simple;
	bh=hgcMlNSdmigLkEILuLr+cZXLHGXLHg9IsWpEPKMEq4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvANWuEjDP+lPS4q2awGt+izNitKsHqk14Em0fWH+VYwUMrINI58zKisp2eqn4pebs3VpS2gVnZvmhM6H7Y7XQa0KWkXuoFUE4yv2SFRpuWMT3OOYnu91fn0dl9mKHAx12KZF8JWRQG+7FKQenYEZPedYo0UA/uF40vbS8pcmMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pV6dq2lh; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pV6dq2lh"
Date: Thu, 8 May 2025 09:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746711891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Hp85b8hIDolOowRMwcAnw25ZKnQfOPpBI9KtOoWVJ4=;
	b=pV6dq2lhKtYqERlUyN92rawE9h6L8oyQZCsVtJRyYtcuLo28POjkvGHMpjT/Qw0pWc3Lp8
	lJXYYgVxAyI2hp67O7qN77hdzvdIIZGBKD6XYmQIC6gYscEoQrkp+RbHrPSgbx2wJqyEyw
	mh88S+AhE0GvC85TL9QP0OJWCK/DfxI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jamie McClymont <jamie@kwiius.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Sanity check request: reduced replication of alloc btrees
Message-ID: <mc6ewehvde6ylkrzvd3x5bhkpitxkdxgg7li2kfcdq5luqorvu@oh5s2moiuian>
References: <9C75AB03-4EC9-4482-AA6C-539626A28244@kwiius.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9C75AB03-4EC9-4482-AA6C-539626A28244@kwiius.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 08, 2025 at 07:02:34PM +1000, Jamie McClymont wrote:
> Hello,
> 
> Would it be a sane idea to support a reduced metadata_replicas value
> for the types of btrees that fall under btree_id_is_alloc, and could
> thus be recreated by `-o reconstruct_alloc` (or, I think,
> automatically via bch2_btree_lost_data) if lost?

Backpointers, perhaps. I wouldn't recommend doing that for the main alloc
btree, reconstructing that one from scratch will fail if your filesystem
is big enough because currently we have to do it before going RW, so the
whole thing has to fit in memory (in the journal_keys array).

Once we have check_allocations working online that will be easier.

> 
> For context, my filesystem (2x280GB SSDs for metadata + caching,
> 4x16TB hard drives for data, all types of replicas=2), reports around
> 220GB of Btree usage:
> 
> extents:             104 GiB
> inodes:             8.11 GiB
> dirents:            1.78 GiB
> xattrs:              512 KiB
> alloc:              26.5 GiB
> quotas:              512 KiB
> stripes:             512 KiB
> reflink:            12.0 MiB
> subvolumes:          512 KiB
> snapshots:           512 KiB
> lru:                 763 MiB
> freespace:          6.50 MiB
> need_discard:        389 MiB
> backpointers:       86.6 GiB
> bucket_gens:         299 MiB
> snapshot_trees:      512 KiB
> deleted_inodes:      512 KiB
> logged_ops:         1.00 MiB
> rebalance_work:      855 MiB
> subvolume_children:  512 KiB
> accounting:         1.00 MiB
> 
> I figure reducing alloc replicas to 1 would save 55GiB of btree space on the fast SSDs, which could be better used for user-data caching, without sacrificing any durability – just a one-off recovery-pass penalty in the event of an SSD failure (or a one-off read/checksum error, but I have thankfully had none of those from these drives).
> 
> Am I missing a situation where this could lead to data loss? If not, I might look at implementing it.
> 
> Thanks,
> - Jamie McClymont
