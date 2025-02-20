Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6675E1D5CDD
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740072776; cv=none; b=KgcQPgvRQvLOBAoR8SGdNf/6nRKvFr7knaYrg/XOTCCX45NVLUn/HXsA6L0h2Rdip8btd17fjcKyqLBDoitMY0zvmAZVYWXyT8JL1oyHXOYntdQyf3EJkvluKKLp5rnLHCxyW2mJQodBofWhP0P4j1+ow9/tB3PsXD7u04qHlpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740072776; c=relaxed/simple;
	bh=hSVOTt5eC2vfbCcnnptyy3eQ6PsQrFEJfegylzuIslE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdF/5lvA1DHK+zl5L7WX36Xa3XIxQYc9JhSr0bO5g2aADgUrsgL2X38MEn6Vr+Y6QU02j4567SrqrcSZwZKens/S72Tuar4SujdbX2W/OcQYNzsY52RqT8AjDL35N/HUSjMJbrrkTlBWZzc+hNAL4oQslmtW9HvPMufGrzM80Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nkdndspI; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nkdndspI"
Date: Thu, 20 Feb 2025 12:32:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740072772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s6WSXSwOwCKQQuYXMrMth0bpAoj3ruGMjyrRX6u5odE=;
	b=nkdndspIAPnJtsw+ykWOXoxWRr9WQLenoV1j487KSdaEXw9GwBe9HBl6uusbHS5okXPCZr
	ry96jI8H5XpikCPdaKdHuYijPDAKEir3A/w7EASt9HgtSjY8pqaliK/d7NMPAkoauOW4So
	D7nxpvValssf5Jl2CmGtA0+ZMviS4lQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, ryncsn@gmail.com
Subject: Re: [PATCH] bcachefs: Fix memmove when move keys down
Message-ID: <tv4lixdazd7m7d4hw2ou37hfpd6xdud7wrr3mlcpbwjs4lf2h3@y45ymp6szsqo>
References: <20250220105608.1174912-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220105608.1174912-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 20, 2025 at 06:56:08PM +0800, Alan Huang wrote:
> The fix alone doesn't fix [1], but should be applied before debugging
> that.
> 
> [1] https://syzkaller.appspot.com/bug?extid=38a0cbd267eff2d286ff
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/btree_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index e71b278672b6..80a0094be356 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, struct btree *b,
>  		}
>  got_good_key:
>  		le16_add_cpu(&i->u64s, -next_good_key);
> -		memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64 *) k);
> +		memmove_u64s_down(k, (u64 *) k + next_good_key, (u64 *) vstruct_end(i) - (u64 *) k);
>  		set_btree_node_need_rewrite(b);
>  	}
>  fsck_err:
> -- 
> 2.48.1
> 
