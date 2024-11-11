Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5C41A2846
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 20:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731355808; cv=none; b=X5IN1N081/7F7JJua8z7gjQsZPHAFtIcgLIzttNYDmcS9LNRxrURUy3alkiDULq1RXeIGlW789wc8xPA883MSu6NYVzfD7KcnwlZ+tUwlwz95XudhQshttJO1zO2yai6eJ1oTWPdsud7K/ytiKKGNFwewT3Zmm7weRVoMoXqFTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731355808; c=relaxed/simple;
	bh=lq7p7ypp4TN3d83VFQ8h2R1FXXi61Q7cmbLpx8zTkG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZrutELrBAhmkFqNXEwjk9UbO94bp2D2npxuPnnX8wnQaMcoZ5himKUqU/78vKVUqOIEQyPTSpXvKeg+W/8hJr9xr/O96qpUV3ETC7iAxERKYuZKsoeZz+2tOX8Y4LwPiIsAS7l+jhpPjKaiN4LklJRhUsVIO8ll9rtHDByPEoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eKMLKTsB; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eKMLKTsB"
Date: Mon, 11 Nov 2024 15:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731355804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dsNlIubHNBjceBMTLdroRRy7Slq6tAzbxUUj5TPWCd4=;
	b=eKMLKTsB14gvDHJyMe9L+c4WaDWKaek8nl8GTYhAhKyShjB2NU6nA9Q/W28PNH1oAutKx/
	jGIWckcDmZTgVgHuYeEAU4rb3BFjqUhu2wE4XIiDEUkmSDzT9W45bv3xSauvm19u/OYrcd
	q2hHByO7jOZPhIsCKKL51i9qX5D7ly8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gianfranco Trad <gianf.trad@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: zero-init move_bucket struct in
 bch2_copygc_get_buckets()
Message-ID: <vtm2n2sjx4kpkx4slzpve6pv4lxhmotnvrhtqp2qobrmubvz35@s33ak2pst3h2>
References: <20241111144242.757798-3-gianf.trad@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111144242.757798-3-gianf.trad@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 11, 2024 at 03:42:44PM +0100, Gianfranco Trad wrote:
> zero-init move_bucket struct b fields in bch2_copygc_get_buckets() 
> to mitigate later uninit-value-use KMSAN reported bug.
> 
> Reported-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=8689d10f1894eedf774d
> Tested-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
> ---
>  fs/bcachefs/movinggc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
> index d658be90f737..cdc456b03bec 100644
> --- a/fs/bcachefs/movinggc.c
> +++ b/fs/bcachefs/movinggc.c
> @@ -171,7 +171,8 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
>  				  lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
>  				  lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, LRU_TIME_MAX),
>  				  0, k, ({
> -		struct move_bucket b = { .k.bucket = u64_to_bucket(k.k->p.offset) };
> +		struct move_bucket b = { 0 };
> +		b.k.bucket = u64_to_bucket(k.k->p.offset);
>  		int ret2 = 0;

Providing any sort of initializer should cause the whole struct to be
initialized, are you and syzbot sure this is the right fix?
