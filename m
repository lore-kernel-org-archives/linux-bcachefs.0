Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D67C0AB
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 13:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522524; cv=none; b=XWS4LKYXH9HuUU26MBbGnUGij2JspVhaU3BjGA7c1w8iLxGs0XW6Qmo4Ozl+Zoql7KrIdsrLQwGvXMW5Yaur32uSHoCSkgCZXXmilLpRY1TzF0q2D5v+p3gh+OuCDORmTe5gf9sECEGouBcwjJRibRK16rNCq2C0SLfF/5GqoPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522524; c=relaxed/simple;
	bh=+8dD9lh+IQNS8j6w+k04OWM6Au9Xj302BzE6wvAmPoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=luhLhmTev9QQ08Wa2IshoRQOD1tdKTserbNw2bRO3OpuxdRU6byfAbgVPuQIMX6WF1PLCx2/TZW1A6ttpqOf+aikWBIiyZFu0+JYrtJ63MqMQANgQJKnYMZNrrATSKMIQakbUnaoRJdKlQLNVoOiH+UISaf586ECiDCM8ZoPeEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cKqKUB8h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKqKUB8h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708522521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1fuIlkvUhZeNbBxgLZXn/AP7QKY8J72sj0E6pTg0r8=;
	b=cKqKUB8hlaoH553qYCLkIHKtgSB9Lueaa7sgbdHm9lBMS14DsRuK7AJa/q9vNc05w3zlm0
	28gHaqefqttJIfCqiTAVn296fWLHPVly8Za3jy6YKcilmvBwsRKPQq2sMu/oJxpvxfX2i9
	FVnKlZvxi0YARANjxD53KvyTXX/Hkuw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-18KVdt7jO3mNZlZPQM3RpA-1; Wed, 21 Feb 2024 08:35:17 -0500
X-MC-Unique: 18KVdt7jO3mNZlZPQM3RpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C15783B8E7;
	Wed, 21 Feb 2024 13:35:17 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.149])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE54BC0335F;
	Wed, 21 Feb 2024 13:35:16 +0000 (UTC)
Date: Wed, 21 Feb 2024 08:36:58 -0500
From: Brian Foster <bfoster@redhat.com>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	ruanjinjie@huawei.com, chris.zjh@huawei.com
Subject: Re: [PATCH] bcachefs: intercept mountoption value for bool type
Message-ID: <ZdX8ek1o6MQErZMr@bfoster>
References: <20240221093704.3924287-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221093704.3924287-1-lihongbo22@huawei.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Wed, Feb 21, 2024 at 05:37:04PM +0800, Hongbo Li wrote:
> For mount option with bool type, the value must be 0 or 1 (See
> bch2_opt_parse). But this seems does not well intercepted cause
> for other value(like 2...), it returns the unexpect return code
> with error message printed.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/opts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index b1ed0b9a20d3..fe1f17830694 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -314,7 +314,7 @@ int bch2_opt_parse(struct bch_fs *c,
>  		if (ret < 0 || (*res != 0 && *res != 1)) {
>  			if (err)
>  				prt_printf(err, "%s: must be bool", opt->attr.name);
> -			return ret;
> +			return ret < 0 ?: -EINVAL;

It might be nice for that error message to be more specific in that the
bool value must be 0 or 1, but LGTM regardless:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		}
>  		break;
>  	case BCH_OPT_UINT:
> -- 
> 2.34.1
> 

