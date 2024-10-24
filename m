Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681041CB53A
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 11:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729768996; cv=none; b=IyjKpWxqLi6sdEU0zGvXREi95jbmq5jKogXfQ03v6DD4AmF4YWKUgGALPwQ8CfIlDiY4AviVo9olRDe08tL3ChxkPYHxcfAuQ2dPcpyqtoHqOUe7U/v0Gp44c9uTf/lwtL1yhTdcq1xcJ4CYufYK4k6+tIGyg2bZClXByd9dmd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729768996; c=relaxed/simple;
	bh=5JS1hte6L1tdRN+iG2eYIB5SFBy5MIOfr2vuL77PB4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkEr3s12phT9VKRpZjJ6r5DtYro79Jq8Zc92ufZ8f/zGSTbxEh21E5S++6fd8HzTjJ3MCtaxTqLq+B6mM1oN4XRyCBtHN+Nx9oOmHFPVBgXMcl1EdzZDKCgOpUl+avMb1HqvWos1AhIO/37cn5H0CxOijUELV3IVaogk+NFjlKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o22coFYk; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o22coFYk"
Date: Thu, 24 Oct 2024 07:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729768987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9Tna3Og/ReoYiJDgTfZM74+VZ3yQX/1aRBGqDU6NjWw=;
	b=o22coFYkQTj2GB+HK6hvYPPGS3MDu3GWaqFx4QBrTQM8wlUefDud6vyu+6YIU910uLZejV
	oA8T/hwlQD+k5n69TO53AoqP9FEFhLvFOYHhMkB4QaS3J4qfDY1T5o27oDDPBFMdXdVg2r
	FrS0HvFhHIketC/qM3aRZCHUShppvhk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gianfranco Trad <gianf.trad@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix invalid shift in validate_sb_layout()
Message-ID: <v4ylesmu73htrqf6voqz2r7yw5ngwoasamlgfpi7fjbbbjzh6a@h46y5uvefkvo>
References: <20241023213043.47846-2-gianf.trad@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023213043.47846-2-gianf.trad@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 23, 2024 at 11:30:44PM +0200, Gianfranco Trad wrote:
> Add check on layout->sb_max_size_bits against BCH_SB_LAYOUT_SIZE_BITS_MAX
> to prevent UBSAN shift-out-of-bounds in validate_sb_layout().
> 
> Reported-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=089fad5a3a5e77825426
> Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
> Tested-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>

looks correct, applied

> ---
>  fs/bcachefs/errcode.h  | 1 +
>  fs/bcachefs/super-io.c | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index 649263516ab1..b6cbd716000b 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -222,6 +222,7 @@
>  	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_type)			\
>  	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_nr_superblocks)	\
>  	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_superblocks_overlap)	\
> +	x(BCH_ERR_invalid_sb_layout,    invalid_sb_layout_sb_max_size_bits)     \
>  	x(BCH_ERR_invalid_sb,		invalid_sb_members_missing)		\
>  	x(BCH_ERR_invalid_sb,		invalid_sb_members)			\
>  	x(BCH_ERR_invalid_sb,		invalid_sb_disk_groups)			\
> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> index ce7410d72089..44d0ac9b00dd 100644
> --- a/fs/bcachefs/super-io.c
> +++ b/fs/bcachefs/super-io.c
> @@ -287,6 +287,11 @@ static int validate_sb_layout(struct bch_sb_layout *layout, struct printbuf *out
>  		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
>  	}
>  
> +	if (layout->sb_max_size_bits > BCH_SB_LAYOUT_SIZE_BITS_MAX) {
> +		prt_printf(out, "Invalid superblock layout: max_size_bits too high");
> +		return -BCH_ERR_invalid_sb_layout_sb_max_size_bits;
> +	}
> +
>  	max_sectors = 1 << layout->sb_max_size_bits;
>  
>  	prev_offset = le64_to_cpu(layout->sb_offset[0]);
> -- 
> 2.43.0
> 
