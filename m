Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C280F16BE16
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 Aug 2024 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722616261; cv=none; b=TuyMSW2zU8kD+R/X8XoM92OJ8w8q/WtZ/t3RqTC5KXSfcKWmHuuYTNLeZhuxRwbiTwDQoyBjMaRrDKU7dZh6uR4CAYOTeu6X/55H/D1qQX8OYoGUn+KFI8sJuv19o6V7uX/xrf+Y5+fWCtxU58Ox5DD45/3M8MhXIRh9ilMsazE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722616261; c=relaxed/simple;
	bh=2SxaU0mT12o6Bl2jx2MqiTjKjVwYivXcEsdDw2SUwz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBA7ck6aqe9LOxZHeiw/KLXiEEmxGySKkd+3z53hqGA15cyEGgJZ+kVN+UeUW04y7sXzzzn8RX/52Mu3PvY117Ndp/IBGW6ue+fvO2RQDb4nfO8jybIr1eTMur8WBTkdk9HNljmuBqItJAmtFR/bONezuTQoAvMvSWQP9Uso7Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q6gQAtMQ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q6gQAtMQ"
Date: Fri, 2 Aug 2024 12:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722616255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Ozwy6taMQ03I7AoUstgAGU/ke/Rn1/4ce/KBpkiht0=;
	b=q6gQAtMQKIXlVxRGMVQrZvJ1jqynztP8V5ha/iA7TeinozTgbkfCN6O8f8WCrWYds89pVi
	3rwgKaMk0Th3JD31NvBq7Z81bv6xL41eFIrPZZJcbDSlTu3GAuunjd31GqoBE/YRCjEIt9
	Jdrafrx/WDMZnO1+O9XHAzU1VMjh9bY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Camila Alvarez <cam.alvarez.i@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_trans_srcu_unlock
Message-ID: <brefgiw6mbvnpg5dmxhuwmoxfrh6upw3zslzn6qa6lfvbvhgi4@7vzwd55illrn>
References: <20240724010759.1631178-1-cam.alvarez.i@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724010759.1631178-1-cam.alvarez.i@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 23, 2024 at 09:08:00PM GMT, Camila Alvarez wrote:
> bch2_extent_fallocate should not return -BCH_ERR_transaction_restart_nested when there are no buckets available.
> Returning -BCH_ERR_transaction_restart_nested causes the sector allocation to retry even if there's no space available.

It seems like you're saying this fixes a livelock, but I don't see that:
if we return operation_blocked, the closure_sync we do before we return
will still wait.

More explanation?

> 
> Reported-by: syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com
> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
> ---
>  fs/bcachefs/io_misc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
> index 82f9170dab3f..b5b92ef030df 100644
> --- a/fs/bcachefs/io_misc.c
> +++ b/fs/bcachefs/io_misc.c
> @@ -90,8 +90,6 @@ int bch2_extent_fallocate(struct btree_trans *trans,
>  				opts.data_replicas,
>  				opts.data_replicas,
>  				BCH_WATERMARK_normal, 0, &cl, &wp);
> -		if (bch2_err_matches(ret, BCH_ERR_operation_blocked))
> -			ret = -BCH_ERR_transaction_restart_nested;
>  		if (ret)
>  			goto err;
>  
> -- 
> 2.34.1
> 
