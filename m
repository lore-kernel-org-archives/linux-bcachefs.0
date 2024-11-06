Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3683F209F22
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730928407; cv=none; b=Es82IypwoBOKhRwNxkGCwlusKWnmcDic9AAryiqALmVdOjIHJpP2gbtlEpMhnCe04Nmza4NbGWeZKe32opQCCUSK/DM2K/qPsRgfXBnupKH9NbMhGzri6SmvQ2L2W7PGWpqgkA2KXj5rY00H8ay5ABDdJOp90tM+Q2YfoJB3Zi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730928407; c=relaxed/simple;
	bh=S00XX/C8auhm6Pd5zfon/GotXfchASnDCDFOCv9fMtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4TXiIpvFipnmnJ3ehk/Uv/upZz/pqQY0uAoN3jxNKoq5bRn7UFW5jMAqEciF+vAqt5Xk5MR6elpsfs1B7XD+25MGti+W1V93wiq/Yg7yneVU093BqwSd+rq2xnFpiaoWwcVuOahLcDtURBCay6n3SEGSTmByRbX0gNYmf6H5xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ut2lGKBX; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ut2lGKBX"
Date: Wed, 6 Nov 2024 16:26:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730928402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K5aUf7Ix/zcmPjHtKUTqy8x0yE0w4ivmboBpvBpPmZA=;
	b=ut2lGKBXvOnxRMM3RNSNKf4XJoAyk1kkF5HzkzM0FzU7Q9G+uraE3jrbCnnweu61FuGtqm
	wJqht213WHQTFwMILvDH9JEA7re6vcsIpAxB0iA3ZqExmQw7nmyxrU3icXRtT7xUb/AYKH
	jtyk2YY/rUB80GTYwT7eqNvbQQixWPA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix io_read/write counter with wrong unit
Message-ID: <zin4x2km66m5oblwnrcnq5ux2hrsrvnbvrsydjvlbignjuzlf3@kendrzgvgre3>
References: <20241105142224.2252301-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105142224.2252301-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 05, 2024 at 10:22:24PM +0800, Hongbo Li wrote:
> In bcachefs, io_read and io_write counter record the amount
> of data which has been read and written. They increase in
> unit of sector, so to display correctly, they need to be
> shifted to the left by the size of a sector.
> 
> Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Nice, I'd been meaning to fix that

> ---
> When I read one 15.7M file, the io_read sysfs interface shows:
> - Before this patch
>   - original:
>     since mount:                   0 B
>     since filesystem creation:     5.11 KiB
> 
>   - after read:
>     since mount:                   31.4 KiB
>     since filesystem creation:     36.5 KiB
> 
> - After this patch:
>   - original:
>     since mount:                   0 B
>     since filesystem creation:     18.3 MiB
> 
>   - after read:
>     since mount:                   15.7 MiB
>     since filesystem creation:     34.0 MiB
> ---
>  fs/bcachefs/sysfs.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
> index 97733c766948..aa46b69da4d8 100644
> --- a/fs/bcachefs/sysfs.c
> +++ b/fs/bcachefs/sysfs.c
> @@ -513,6 +513,11 @@ SHOW(bch2_fs_counters)
>  		if (attr == &sysfs_##t) {					\
>  			counter             = percpu_u64_get(&c->counters[BCH_COUNTER_##t]);\
>  			counter_since_mount = counter - c->counters_on_mount[BCH_COUNTER_##t];\
> +			if (attr == &sysfs_io_read || attr == &sysfs_io_write) {\
> +				counter <<= 9;					\
> +				counter_since_mount <<= 9;			\
> +			}							\
> +										\

But, I really try to avoid this kind of "do something special for one or
two cases" in generic code, this kind of thing proliferates and then it
becomes really hard to track down and see where behaviour is coming from
later.

We've already got a table of counters - BCH_PERSISTENT_COUNTERS(); it
would be better to add a "type" column there, and then it'll make it
easy to spot later if any other counters have the wrong type or need
different behaviour.
