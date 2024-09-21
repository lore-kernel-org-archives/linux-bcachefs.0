Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F761F957
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 18:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726944814; cv=none; b=f/hq7rMRDtG+9KMSYbFi4V5Td8mHFF7XSNvL/g7Ywpfrrf+rhYqoUXgDmRB0vfZ/XeUW7Idi73CblHYCJsrhYq8I18JVGGdEezkNqYTAyyv4Yy8pS84KkdPsVJdOZrPQlwqrMQRCnalgQf+gsWMpvq1nZaUqlIiBrmHBsaplilU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726944814; c=relaxed/simple;
	bh=/vae6MyLNQhuA7VzoYc1K39b4X4WJn+T5aMmKUOXkIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzfeONrPWFlgT904ibBcIOAYEHsqRA3my+pj64HH1jPv6gyH3LUbCWXXXN994+m6TKXPvjTWCz/HKhJI9PhvmD2lz5F3/ZKVc09wW8OqhLHTJc8SL0ObOSb0V7y1VxH63LqBVYOX/U2gaE5y1AvRlMfoiko0hIBVCk2KQ2ViI0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wOunZkZs; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wOunZkZs"
Date: Sat, 21 Sep 2024 14:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726944810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qh3mamW53cxYQZiM7q+Uia3rN/UUZYv5uK9O1lHQbZo=;
	b=wOunZkZsHCxXnQLIt2Wp/uzzl+gT88CejIfp3Ky9BRbjG9Vr/DRZphcaM4e2XtOSj2t2hD
	N4PKqESdseZXQr2qwDp2l/fkfxwwLYs1pKLjUeU6xW6jT1gUGvR2cL+6StoXdd4Jrax+3a
	wk+mQ9PVTI9QvHauM25KqgS9e+9sNHc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Ahmed Ehab <bottaawesome633@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	syzkaller@googlegroups.com, syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com
Subject: Re: [PATCH] Hold read lock in bch2_snapshot_tree_oldest_subvol()
Message-ID: <gire2ul2mlbkrn7jsndwzfxybfijhcse3c2gcq6rmzqaguaz2h@gimiz6gtsgyu>
References: <20240921210036.99386-1-bottaawesome633@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240921210036.99386-1-bottaawesome633@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 22, 2024 at 12:00:36AM GMT, Ahmed Ehab wrote:
> Syzbot reports a problem that a warning is triggered due to suspicious
> use of rcu_dereference_check(). That is triggered by a call of
> bch2_snapshot_tree_oldest_subvol().
> 
> The cause of the warning is that inside
> bch2_snapshot_tree_oldest_subvol(), snapshot_t() is called which calls
> rcu_dereference() that requires a read lock to be held. Also, the call
> of bch2_snapshot_tree_next() eventually calls snapshot_t().
> 
> To fix this, call rcu_read_lock() before calling snapshot_t(). Then,
> release the lock after the termination of the while loop.
> 
> Reported-by: <syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com>
> Signed-off-by: Ahmed Ehab <bottaawesome633@gmail.com>
> ---
>  fs/bcachefs/snapshot.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
> index 8b18a9b483a4..678e9fdee348 100644
> --- a/fs/bcachefs/snapshot.c
> +++ b/fs/bcachefs/snapshot.c
> @@ -8,6 +8,7 @@
>  #include "errcode.h"
>  #include "error.h"
>  #include "fs.h"
> +#include "linux/rcupdate.h"

unnecessary, this is already pulled in - but I'll fix that nit and apply

>  #include "recovery_passes.h"
>  #include "snapshot.h"
>  
> @@ -469,6 +470,7 @@ static u32 bch2_snapshot_tree_oldest_subvol(struct bch_fs *c, u32 snapshot_root)
>  	u32 id = snapshot_root;
>  	u32 subvol = 0, s;
>  
> +	rcu_read_lock();
>  	while (id) {
>  		s = snapshot_t(c, id)->subvol;
>  
> @@ -477,6 +479,7 @@ static u32 bch2_snapshot_tree_oldest_subvol(struct bch_fs *c, u32 snapshot_root)
>  
>  		id = bch2_snapshot_tree_next(c, id);
>  	}
> +	rcu_read_unlock();
>  
>  	return subvol;
>  }
> -- 
> 2.46.0
> 
