Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3E517583
	for <linux-bcachefs@vger.kernel.org>; Sun, 13 Apr 2025 09:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744538364; cv=none; b=CJ2vv9idYGCmRPSASlLJ3/SMo8/1IALdturRaveM5aO8A7np/c5oPQtHrLC0dFvQ/z2Sr4FGPG+NtH0TYPAb4ABf5l86IizZ26D1vWOHnZMzPdcvEXsHcm8mWF96m3lQoEDHun7NXdF/0oXqFvQd1rXZR0ruqjdrDfb4Uj8V5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744538364; c=relaxed/simple;
	bh=N8wT9ixFIDclk0lqh/sxrMIXzD3Tl/0mBmdxWFEAp90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAI9X/V0vErSipOlq1uDq+9TL/znPRXU/yO/8nHF4AAEzJR3UdQy7QVNdRwYIvNb2SFJC4OBZEJPlxezmhhisDIgF1Nab1PoKWIpbRXxEfeY699JZQRrDC5GSyS3kwqQvsah9lIcKilCJ3ESPRtmir2rlI03HWWLtRnfV1kSeqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dBxijiqd; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dBxijiqd"
Date: Sun, 13 Apr 2025 05:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744538360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yhqi8mQRdgt/NjaVbLj2nHlmv9WxDd5CqzxusEbba0I=;
	b=dBxijiqdXH9T53twx+F0DqqaFQo1FpALeiDXCIHV/6jYssm+6YZs0XFXfJ3F+5ewrjPVbR
	RiOo4jyJBWIKWg2pIseaTzBBdrWMt4WWk23hv/mta8VH6yEVr+hW1Hlidiw2h3493oa6re
	IC0IKfws8XYL6DIDHNCmIppYikN603g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Add missing error handling
Message-ID: <tjbg7uavlujkxoijtfagmbl7sdewnzgsgo4jmlghoywwgd7vum@d7vbnrrm7dtq>
References: <20250412102049.19199-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250412102049.19199-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 12, 2025 at 06:20:49PM +0800, Alan Huang wrote:
> Reported-by: syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

This was a silly mistake.

In the past I've thought about going through and marking huge swaths of
functions as __must_check, maybe that would actually be worth doing?

> ---
>  fs/bcachefs/recovery.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index d2b07f602da9..606d684e6f23 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -1125,7 +1125,10 @@ int bch2_fs_initialize(struct bch_fs *c)
>  	 * journal_res_get() will crash if called before this has
>  	 * set up the journal.pin FIFO and journal.cur pointer:
>  	 */
> -	bch2_fs_journal_start(&c->journal, 1);
> +	ret = bch2_fs_journal_start(&c->journal, 1);
> +	if (ret)
> +		goto err;
> +
>  	set_bit(BCH_FS_accounting_replay_done, &c->flags);
>  	bch2_journal_set_replay_done(&c->journal);
>  
> -- 
> 2.48.1
> 
