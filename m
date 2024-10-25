Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3AA15D5A1
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729875303; cv=none; b=Guvc2pMSOPnNnUlMcyoCkLy08O+i+bCBgelIALt3H7dSeKsesrwQ+l8dqxnR66qrmUv30qak7QOKovUQe5L1P6T9fBaCX7rV8hb4FFdCQlw9a+T2+iwz/sp/gUogYzet+STwrA+cjZp1CzgkgMSXIYGN+KpOslB5ez+5dwdEhBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729875303; c=relaxed/simple;
	bh=XsDRiPF4GTDvq99UzyGYEZSuJoYWVf2j7flx5peKA1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8XeQXVB4CdMJn5knNiaj1oITEz5OnHGi/WUM8EnXLGXaDkx6Utl7wCj8UjmkZxhLb6SXUmNmlc2rmItLw8Ncy/jDJFx/93BlSHWN/a+HyJrnilL56RkOW87dnVBlkzfoOxWrygJuNAPdivUho0ZZd6PW0I5uXuRnl0LOFUL8ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jCpmp2Sj; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jCpmp2Sj"
Date: Fri, 25 Oct 2024 12:54:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729875297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cf6d/KEl9yestGdJTi8aLwum34Ify9orE/WKOv1JRok=;
	b=jCpmp2SjxWPxfU97LrbbqxMci+dUUclN1b8nwuFInamGFMHlBYQf9+MdNYDofuc1WpXJq/
	bMXnNuzZgSxKZhhYqrucq3qg6mwMkFRxe5rY8y8HSIccfG7dnh3pgEMMRhjZInAKjjokMu
	pK6jERJYPL6fGeAoiLhE0KkfJXSEIAo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jeongjun Park <aha310510@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: fix null-ptr-deref in have_stripes()
Message-ID: <n6nisrv3mklka3whfosvhrcevivri76clgijy3ijdxfbzjkuc3@wuogkgi5kf4s>
References: <20241025115618.2908-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025115618.2908-1-aha310510@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 25, 2024 at 08:56:18PM +0900, Jeongjun Park wrote:
> c->btree_roots_known[i].b can be NULL. In this case, a NULL pointer dereference
> occurs, so you need to add code to check the variable.
> 
> Reported-by: syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
> Fixes: 7773df19c35f ("bcachefs: metadata version bucket_stripe_sectors")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>

This looks identical to the v1? It's already in my testing branch

(But it should be in my hotfix branch, doing that now)

> ---
>  fs/bcachefs/sb-downgrade.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
> index ae715ff658e8..8767c33c2b51 100644
> --- a/fs/bcachefs/sb-downgrade.c
> +++ b/fs/bcachefs/sb-downgrade.c
> @@ -143,6 +143,9 @@ UPGRADE_TABLE()
>  
>  static int have_stripes(struct bch_fs *c)
>  {
> +	if (IS_ERR_OR_NULL(c->btree_roots_known[BTREE_ID_stripes].b))
> +		return 0;
> +
>  	return !btree_node_fake(c->btree_roots_known[BTREE_ID_stripes].b);
>  }
>  
> --
