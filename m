Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE41AF0D8
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 11:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769819; cv=none; b=FPkhqXCORmtuA1xmZ+DoST4U5z+kl8KScX5+Qg56gre28zu64zkj2rzxQq0Kl908vMM7pMOC5nmqw96Zib9g/Lzu8+RbEUsg4kmX+LkRS7z/PNY8ITxYHAb20HEZu8O9cr8SVKnEmV9eMgkjxHB5+TfJ321ISje8jMdRoBxav1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769819; c=relaxed/simple;
	bh=qjtEz4kZZGdGbksIEpM4YMDcwx6w6gKccn0EqeifDxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyRjhcWTpxwXMBKF/KJ8M3ASpj96Y8F8TWG3ygrPTamoaqK3oREjY+iz/aoVLcsBoAXnamPDEApkw0Yk7abyvoqu2IXGNnvqeqnkVgv1fIxskLD6s0VDrv3/RL14VNzdXdTkb4Zb65gfLSkB/Fdpx74KCw2e69uZdS/HFT5+Ul8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ENj1RUpA; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ENj1RUpA"
Date: Thu, 24 Oct 2024 07:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729769813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/1WD+2ABz5IgWsh7qLAkIoYZe0LJBrSeMCq2oWoIQLk=;
	b=ENj1RUpAgxXWtFYB5PKlrwdZvJFxaLK1in0GvKvMh3pcymqaHJoBjz0gRrE8cntOUCmNLR
	zStQr2IZnKTHfog4ybGt6ZvoPi0bvW5RnnJ++EsmENFvSrrSUnz8msIVA5RPDQLOi/D5Ce
	//96EOx+8ESftVcdD1cCbN2GRFtfJlc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: manas18244@iiitd.ac.in
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Anup Sharma <anupnewsmail@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
Subject: Re: [PATCH] Revert "bcachefs: Add asserts to
 bch2_dev_btree_bitmap_marked_sectors()"
Message-ID: <rd4maufxfunrcpzkoo2jszorzl256fiktw3p5yfpnjpu2ajh4l@5wvkfxwzajax>
References: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 21, 2024 at 10:18:57PM +0530, Manas via B4 Relay wrote:
> From: Manas <manas18244@iiitd.ac.in>
> 
> This reverts commit 60f2b1bcf519416dbffee219132aa949d0c39d0e.
> 
> This syzbot bug[1] is triggered due to the BUG_ON assertions added in
> __bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
> 63 '?'. This triggers both the assertions.

The BUG_ON() doesn't need to be deleted; we just need to fix the
validation so it doesn't fire (it doesn't particularly matter if it's
removed or not, ubsan would catch it without the BUG_ON()).

I believe 57 is correct, 64 - (2^6, which is 64, i.e. size of the btree
bitmap), but >= 58 would have been better.

> 
> Reverting the commit does not reproduce the said bug.
> 
> [1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
> 
> Signed-off-by: Manas <manas18244@iiitd.ac.in>
> Reported-by: syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
> ---
> This syzbot bug[1] is triggered due to the BUG_ON assertions added in
> __bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
> 63 '?'. This triggers both the assertions.
> 
> I am unfamiliar with the codebase, and there wasn't a lore discussion
> about the assertions in the commit, so I am unsure about the relevance
> of these assertions.
> 
> Reverting the commit does not reproduce the said bug.
> 
> [1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
> ---
>  fs/bcachefs/sb-members.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> index fb08dd680dacf82bca414f424024e4a00bf432de..9790fd47338c46d2af30547e1f41a1e578b71aa4 100644
> --- a/fs/bcachefs/sb-members.c
> +++ b/fs/bcachefs/sb-members.c
> @@ -450,9 +450,6 @@ static void __bch2_dev_btree_bitmap_mark(struct bch_sb_field_members_v2 *mi, uns
>  		m->btree_bitmap_shift += resize;
>  	}
>  
> -	BUG_ON(m->btree_bitmap_shift > 57);
> -	BUG_ON(end > 64ULL << m->btree_bitmap_shift);
> -
>  	for (unsigned bit = start >> m->btree_bitmap_shift;
>  	     (u64) bit << m->btree_bitmap_shift < end;
>  	     bit++)
> 
> ---
> base-commit: 42f7652d3eb527d03665b09edac47f85fb600924
> change-id: 20241021-revert-assert-bch2-25474fe809d1
> 
> Best regards,
> -- 
> Manas <manas18244@iiitd.ac.in>
> 
> 
