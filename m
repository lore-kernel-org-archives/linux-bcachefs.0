Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B31C6882
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718632227; cv=none; b=NGyht6y97A3x1uHsOoCLzMXQENzU4/XiCOrCmUr7qaOcxJb9zKqhbAFNgmcuf6BhQSKQJJDtgoafOm9QYqKzWaRUmBh03CxCcY0Vtk7W/xM7In3TuMYHR0eEcZtouHr9uzPgPss6vf66zoIP0rQFx0NCXf5VlzZmV9DdOaGL1SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718632227; c=relaxed/simple;
	bh=D5p2SE0eHG1JvQH6hxT3l8r0DOSeEOFDSIG+C0YDKwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pvfe31qOGaFR6kGZAuhwuWYJRDhf3FVMAh8Ag4A/wBGs5bgvH/56fLJ8G2ANsD8XAO5D6KCz7dZWmmi8hNFvizJJODs2F3WI18s4HtOjK5BXUUTRWwG2XiBv5+5g9IJZof1qZeMu/cg6ngkSUgA5JCX8+d5RkrUKfLNMOKiIXx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EIvEfnXO; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EIvEfnXO"
X-Envelope-To: eadavis@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718632223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C62PbaCEWfaouXUkkTaXGkDjjhNjBVFwmkpkQFT9P00=;
	b=EIvEfnXOJg8bh0AbA74ouCqzkJwiFZWf9T1eNE4eN7JHV6iaPo1h7eG87OahDjFBKIMrDj
	2c59h5PSrxBkzq2hJtB5rnnFP1LV6skqiXqYDcBqaV8dItJcn+MvPbnbe7zF9wZ2XbJ9CY
	3av/XD1RLQfAkChb+K9+C/Q3KHHXS08=
X-Envelope-To: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Mon, 17 Jun 2024 09:50:18 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com, 
	bfoster@redhat.com, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: bch2_fs_read_write_early needs to hold write
 lock
Message-ID: <pols2a6hnmgwb6tnszy3d2gqlyomstowhozqp4pu7rbgakdtj5@uozspcarep3h>
References: <00000000000053e574061ad89521@google.com>
 <tencent_724B611BCF250EBAF7BBE333DF9E271BB208@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_724B611BCF250EBAF7BBE333DF9E271BB208@qq.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 15, 2024 at 07:44:04PM +0800, Edward Adam Davis wrote:
> bch2_fs_read_write_early() needs to hold state_lock to pretect and sync data.
> 
> Reported-by: syzbot+4366624c0b5aac4906cf@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

this is incorrect - delete_dead_snapshots() may be called synchronously
or asynchronously, and if it's called asynchronously we do hold
state_lock, so this will deadlock

> ---
>  fs/bcachefs/snapshot.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
> index 51918acfd726..b27a4327274d 100644
> --- a/fs/bcachefs/snapshot.c
> +++ b/fs/bcachefs/snapshot.c
> @@ -1566,7 +1566,9 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
>  		return 0;
>  
>  	if (!test_bit(BCH_FS_started, &c->flags)) {
> +		down_write(&c->state_lock);
>  		ret = bch2_fs_read_write_early(c);
> +		up_write(&c->state_lock);
>  		bch_err_msg(c, ret, "deleting dead snapshots: error going rw");
>  		if (ret)
>  			return ret;
> -- 
> 2.43.0
> 
