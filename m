Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4691DF252
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Sep 2025 01:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756775386; cv=none; b=Tx33vu+jPUXxkNSwiuNIO59z/uITc+dMVk66d1FhBUhSZ7mkIbJ5hpbtsorarWNlzmufx3QuYQvihd/Man5bHDlFw9CzQwxUQ6eFbD+hleaAffYlZVTIMkqZtJDMBbslw22UL9JopuV9KS7m5KPxVPpEGxR6T5EQ5/C3Fb+4qCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756775386; c=relaxed/simple;
	bh=8cPj7qJdQOwDC94wLL8jd6Ay1utqYQ5YBZAbbXFMk4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfyYaxnDuFuRZXK+4eyhCuMAM8bvwj0aLhSZ7gaQGAW0F4Clneh4RN9gB4r62jHP3j4xx+lfotvUZ/mWYXYueCkUxesCof2HOSXexG8vaVPV1t028+5z0jIcVVuvU6h7BT0ahXxuQVon7z65tmfR5qI4K1fwLft3eBU3c/Oo924=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u/U3FY/5; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u/U3FY/5"
Date: Mon, 1 Sep 2025 21:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756775380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hDXkZSRZDQyB5psmZ7W2y8beKGEY4RGU0992TTD/QgY=;
	b=u/U3FY/5bmn3zO+rOo11P5YY+J5EivfC2iEusCzmAOLrWxjauok9a3i3SyU2tm00IUag/8
	icwheP0KTSvyiBrkaYqMIK7jqvqaharmaMPNgx6GMXoJVjpquIOFW5N95CBcIL3Qdain/w
	EW3WZOPLPRVEnLOdGtKgTfS+G6gBhv4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Kill duplicate error code
Message-ID: <cjy567hrn2t3campnbxkaalhwebpe7bb7c4dpr4asrdpndyuy7@pgeeogjvwr2c>
References: <20250823184132.235684-1-mmpgouride@gmail.com>
 <frmmbj6oawjwb4dklf4rqico3ajauud6jqw3hspfdewkxhs5qj@b42regdayqhy>
 <87267DB6-1666-440A-B606-F4AC9606E255@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87267DB6-1666-440A-B606-F4AC9606E255@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 02, 2025 at 08:54:14AM +0800, Alan Huang wrote:
> On Sep 2, 2025, at 06:42, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Sun, Aug 24, 2025 at 02:41:32AM +0800, Alan Huang wrote:
> >> btree_node_read_error is duplicate of btree_node_read_err, which impacts
> >> repair path if misused.
> >> 
> >> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> >> ---
> >> fs/bcachefs/btree_io.c         | 2 +-
> >> fs/bcachefs/errcode.h          | 1 -
> >> fs/bcachefs/sb-errors_format.h | 2 +-
> >> 3 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > So the patch builds, but this still doesn't make sense, because
> > 
> >> 
> >> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> >> index 2e3dd9bacac5..3d594c4ae9d8 100644
> >> --- a/fs/bcachefs/btree_io.c
> >> +++ b/fs/bcachefs/btree_io.c
> >> @@ -1902,7 +1902,7 @@ static int __bch2_btree_root_read(struct btree_trans *trans, enum btree_id id,
> >> scoped_guard(mutex, &c->btree_cache.lock)
> >> bch2_btree_node_hash_remove(&c->btree_cache, b);
> >> 
> >> - ret = bch_err_throw(c, btree_node_read_error);
> >> + ret = bch_err_throw(c, btree_node_read_err);
> > 
> > this references an errcode.h error
> > 
> >> goto err;
> >> }
> >> 
> >> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> >> index adc1f9315eab..7106d72fca80 100644
> >> --- a/fs/bcachefs/errcode.h
> >> +++ b/fs/bcachefs/errcode.h
> >> @@ -295,7 +295,6 @@
> >> x(BCH_ERR_btree_node_read_err, btree_node_read_err_cached) \
> >> x(EIO, sb_not_downgraded) \
> >> x(EIO, btree_node_write_all_failed) \
> >> - x(EIO, btree_node_read_error) \
> > 
> > which you delete
> > 
> >> x(EIO, btree_need_topology_repair) \
> >> x(EIO, bucket_ref_update) \
> >> x(EIO, trigger_alloc) \
> >> diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
> >> index aa0ea1ec9f10..483358588abc 100644
> >> --- a/fs/bcachefs/sb-errors_format.h
> >> +++ b/fs/bcachefs/sb-errors_format.h
> >> @@ -73,7 +73,7 @@ enum bch_fsck_flags {
> >> x(btree_root_read_error,  59, FSCK_AUTOFIX) \
> >> x(btree_root_bad_min_key,  60, 0) \
> >> x(btree_root_bad_max_key,  61, 0) \
> >> - x(btree_node_read_error,  62, FSCK_AUTOFIX) \
> >> + x(btree_node_read_err,    62, FSCK_AUTOFIX) \
> > 
> > and rename the persistent error?
> 
> The persistent error is never used, renaming it to the same as the error in errcode.h makes sense.

We probably want to hook it up then...
