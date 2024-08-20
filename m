Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD7A14A4F0
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Aug 2024 23:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196868; cv=none; b=mawSn3PuyxJyRNWCjT1d0irsie1ZYmKFVAHn2tAf+l754MhpYmDiAlfbnP/PHu+xV6V2Li/LEgkLzEVnay2Sb7OO9FHDkpqblKVMOzDURMUnKRqfVPSJNNYhFQw/yDd1B9gh8HOu+o5ngEWmht86XeOd67XLSPpKSwr+gcdsvVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196868; c=relaxed/simple;
	bh=syn+XDhv+5W5sGaxvkCD1Cf/uLhSBsAomgMfjeFIlqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mdQ49WuMYnVMXNWtevW6Mj4UzOGK5C4ckNqnrG/z7IvkYV1WFj2My6Utap33FQdme0lLai9i72TiybcEdRUC89NyD/6Y+suGRwftPAcYHBCueRAiAm9SmALJ+Eq5EdsklRb3v/zbl2EkY2ubOdepAXA+QTw6PDPovBo1aDIUkks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h+cGN+vM; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h+cGN+vM"
Date: Tue, 20 Aug 2024 19:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724196863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yjri1bvpCDcJTfjHDDEUJmZWU96ylEGFys1S9b6VxAQ=;
	b=h+cGN+vM5RvmWRXMMUY2ZLWUL+DmojfJ7M3Jo/2vnjPFzrF8nEWFxbKz4WaevZZsnEfFlO
	pLZ2NchbHX/81OwfR8YDO+LgHldA/606Wp1FjiBiNsrYiIQyto1zrDVA0mJLL9BSHY+F+s
	cuYNQxQ+iostCqIjd0KdJtQZZ0ZduBw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] bcachefs: Add journal v2 entry nr value check
Message-ID: <rtuy45ppvbi7yoighz2uvxwauotsyt5jr6kwfp4bsp2g43f342@k4hnm3xmqotz>
References: <m5tgdpvt4bzaikdmhlxzwrceww5vh5b237qesdosf6nn4hyhan@4brk2v5w26u4>
 <20240820071145.1109560-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820071145.1109560-1-lizhi.xu@windriver.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 20, 2024 at 03:11:45PM GMT, Lizhi Xu wrote:
> When journal v2 entry nr overflow, it will cause the value of ja->nr to
> be incorrect, this will result in the allocated memory to ja->buckets
> being too small, leading to out of bounds access in bch2_dev_journal_init.
> 
> Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/bcachefs/journal_sb.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/bcachefs/journal_sb.c b/fs/bcachefs/journal_sb.c
> index db80e506e3ab..db2b2100e4e5 100644
> --- a/fs/bcachefs/journal_sb.c
> +++ b/fs/bcachefs/journal_sb.c
> @@ -119,6 +119,11 @@ static int bch2_sb_journal_v2_validate(struct bch_sb *sb, struct bch_sb_field *f
>  	for (i = 0; i < nr; i++) {
>  		b[i].start = le64_to_cpu(journal->d[i].start);
>  		b[i].end = b[i].start + le64_to_cpu(journal->d[i].nr);
> +		if (le64_to_cpu(journal->d[i].nr) > UINT_MAX) {
> +			prt_printf(err, "journal v2 entry d[%u].nr %llu overflow\n",
> +				i, le64_to_cpu(journal->d[i].nr));
> +			goto err;
> +		}

no, you need to sum up _all_ the entries and verify the total doesn't
overflow UINT_MAX
