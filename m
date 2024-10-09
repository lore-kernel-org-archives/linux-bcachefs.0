Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC5426AEC
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 03:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728443518; cv=none; b=ihvtnZOpe/kkZR5WQmNmS8go297x3IulYUadSJD+pPY/cOFtG6irABa5Z6a8LzKyh1f1auzMRTokuWRpQFUMcggtSZAz83g0X3dvnCdvr+dc/EvljgiSlO8rCP1snpqsaufWWGAE4Y7ScOqo9w36SRhrGjmtWkP91+Aoj1TpyCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728443518; c=relaxed/simple;
	bh=2Uu8tP8tsaxI+XESrwlIdx6zOPTDulALO5sJudgD23k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOxbbYP2tUICOZkpTQ0TahWg32vtXmghZ99u7P0Y2NLyq/j8dMQE/107Db0Deu1y8mhY0G0ExDZ6ciEdU7oK+21WGAVDitt5np8J17paphzBzUXSUE7/G6rGv5gESTAHZ6X9wSsyvorbnsbwHkRiUP6HlOOOwI3BmsmCFZmZHQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AAq//bX+; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AAq//bX+"
Date: Tue, 8 Oct 2024 23:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728443512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d28mcHpd/btxLT1zqD5HZmtvpQ7uT561D+cVA7Gkuzs=;
	b=AAq//bX+BLAnHelB53iwcT1tHYOIGWVbJa6EGe9cQkqVDNXsdE8asve5RVF15tscSBRmPg
	PwTp6oK4bbGRG0Jb+NzWLC3wZVYJ5EawQhOphPysq5ql0Ndyv+FxEDNBZAAljK1WRTyzuV
	nzm1lRQrwu6EV9qgHwhUPRLP8B6C7lo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, chris.zjh@huawei.com, ddiss@suse.de
Subject: Re: [PATCH v2 2/2] bcachefs: fix incorrect show_options results
Message-ID: <agluyphgxxccznv7d3cusj7eklom34lnbo5aksqhguojro6gin@lhrxn7ahrf6r>
References: <20240926020002.1746333-1-lihongbo22@huawei.com>
 <20240926020002.1746333-3-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926020002.1746333-3-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 26, 2024 at 10:00:01AM GMT, Hongbo Li wrote:
> When call show_options in bcachefs, the options buffer is appeneded
> to the seq variable. In fact, it requires an additional comma to be
> appended first. This will affect the remount process when reading
> existing mount options.
> 
> Fixes: 9305cf91d05e ("bcachefs: bch2_opts_to_text()")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Applied!

> ---
>  fs/bcachefs/fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index d6e26b5056f3..b42c293f71f8 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1931,7 +1931,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
>  	if (buf.allocation_failure)
>  		ret = -ENOMEM;
>  	else
> -		seq_puts(seq, buf.buf);
> +		seq_printf(seq, ",%s", buf.buf);
>  
>  	printbuf_exit(&buf);
>  	return ret;
> -- 
> 2.34.1
> 
