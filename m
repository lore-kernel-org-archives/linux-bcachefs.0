Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2879433A4
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 12:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715603640; cv=none; b=rgsNvMeQej5bCdupCWL7rnXPvkRnfZ8tk3jjZF179+IoNDXyFAw70ALdd6IG64DqXSBaV2gKBENU/TTvGokZXpztuDJgq0p51p2WfTTNYk+Biug9LZLnSUj0eeUzvOtas+IOcsvwfoNWezg9eQqYhAGmsigZ0A1vBG6gA4ctuJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715603640; c=relaxed/simple;
	bh=ByPNY3pYrbstsLH9CANEI1BfqYxJ4qqVHBhHZq72rgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=olveNWX0VTN6WZZto+hAxZ921PLxLDXVFapt6pt3askOI6qfWgKUGR/a9Af6QTs7C8AAyBuYtmJyKkowyzzjnyQMCjhk5zkckeZvvI/GHAceQqQ7FUrvQEEM001WVRLFjILz/cFOAA9FrDUEQuDlrV4EA+AXe6TidyEJI1aQUgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HL0waYPX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HL0waYPX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715603637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pOJfkLM+Rf7F3FxsYrmWURdktWZVYusfrII5DDzcs/0=;
	b=HL0waYPX+JQ8uYOFrVJnhWWGjVVo9Cme0uS1Akvdb9OBnG8wG8lzauh2Eku5au2hbPim25
	V83qwoELl8/3PtNEzYL0bVlL0uBg9aUgZ5L0+4uvH5DbJewfv1RL43pPJEaWaFkjIma/Iv
	DNguniGw2qvZLgWi1+zSL3Ce3zALa6Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-2EkOZVXpNuiXPCxXEkoz-w-1; Mon,
 13 May 2024 08:33:56 -0400
X-MC-Unique: 2EkOZVXpNuiXPCxXEkoz-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC55738135EE;
	Mon, 13 May 2024 12:33:55 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87F2640C6EB7;
	Mon, 13 May 2024 12:33:55 +0000 (UTC)
Date: Mon, 13 May 2024 08:34:14 -0400
From: Brian Foster <bfoster@redhat.com>
To: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: support REMAP_FILE_DEDUP in
 bch2_remap_file_range
Message-ID: <ZkIIxvdRKrgCdoC8@bfoster>
References: <yuG-zWAd7xX9SkysCfG2ELC8drJi3bxsagrf03hf2Aeah__0W1exPDJabqC23NyOzt5BXmYEF95045yO2SfCbZMgGkYqbycmlUIBZqk2vyE=@riley.engineer>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yuG-zWAd7xX9SkysCfG2ELC8drJi3bxsagrf03hf2Aeah__0W1exPDJabqC23NyOzt5BXmYEF95045yO2SfCbZMgGkYqbycmlUIBZqk2vyE=@riley.engineer>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Sat, May 11, 2024 at 12:20:12AM +0000, Reed Riley wrote:
> By removing the early-exit when REMAP_FILE_DEDUP is set, we should be
> able to support the fideduperange ioctl, albeit less efficiently than if
> we handled some of the extent locking and comparison logic inside
> bcachefs.  Extent comparison logic already exists inside of
> `__generic_remap_file_range_prep`.
> 
> Signed-off-by: Reed Riley <reed@riley.engineer>
> ---

Seems reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Have you run any tests just to make sure there are no surprises? If not,
it looks like xfs_io has a 'dedupe' command that would make it easy to
run a quick test or two from the command line. fstests has a bunch of
tests in the dedupe group (which I presume this patch should now allow
to run on bcachefs) as well.

Brian

>  fs/bcachefs/fs-io.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
> index 20b40477425f..4f513f22a66a 100644
> --- a/fs/bcachefs/fs-io.c
> +++ b/fs/bcachefs/fs-io.c
> @@ -857,9 +857,6 @@ loff_t bch2_remap_file_range(struct file *file_src, loff_t pos_src,
>         if (remap_flags & ~(REMAP_FILE_DEDUP|REMAP_FILE_ADVISORY))
>                 return -EINVAL;
>  
> -       if (remap_flags & REMAP_FILE_DEDUP)
> -               return -EOPNOTSUPP;
> -
>         if ((pos_src & (block_bytes(c) - 1)) ||
>             (pos_dst & (block_bytes(c) - 1)))
>                 return -EINVAL;
> -- 
> 2.44.0
> 
> 

