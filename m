Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2054B1FB4
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 19:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720811815; cv=none; b=nf6jHM/r2DK5D6viklgTIhbwgkozL+NrgoWOCrx4sZVhh1Pbn7HjUoWUMhcQS74EpCs3z0FDh2X84Iq1Su0Rh3PCpU1Odb248LJlRf1f3p4avuOkYnffzLSm+S7DwUoTyqCBv2JFDOjj+QkVBB16UeNpL2n8cdqDNF0JZjLJc2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720811815; c=relaxed/simple;
	bh=Fghj4XLDaSCY9gAtTXf9v6drI/C/K2/trjhD0bSJXSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+X+0YNZtT4aMUZuqdkYX6iNm2oHji3x530ercgKZu9eyE1rxAHpYLH9eQr3Gh+ptDZKYThTtbZbhdLjDXL4IwsuCForkxBtW9aC++5AVV7OEKnAkx9eprukeFA28w6aDUWmeXn3E6HyeHkvBYPf/xb1Kny0yoRC8NWgglgFpuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OMdfqxnQ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OMdfqxnQ"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720811810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UpFcwI2d58l2hh8J+eC2hdM9QYqQNQGInQXGz370STQ=;
	b=OMdfqxnQK/nM+fDtSqBIlQ9ywFLZCxIk5SiIxiLr2Ta2c8bWULrA2n/MEfeLzEkPV4Kv3C
	/jBvyEES7sC8bY/SWqthjkb6EO5op6DtII8NQA158ttw6xI+AnTZJsy/CCbaqbfUdNPxRi
	Rf22i+2UMDuJpNkkoUGDhh3bANkRSPM=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 12 Jul 2024 15:16:47 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: show none if label is not set
Message-ID: <hoybv3el4jziwvmyf2gylbuk2hvwpmteefmgzy6bymzedo23uc@p5coski5oary>
References: <20240712070925.1589874-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712070925.1589874-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 12, 2024 at 03:09:25PM GMT, Hongbo Li wrote:
> If label is not set, the Label tag in superblock info show '(none)'.
> 
> ```
> [Before]
> Device index:                               0
> Label:
> Version:                                    1.4: member_seq
> 
> [After]
> Device index:                               0
> Label:                                      (none)
> Version:                                    1.4: member_seq
> ```
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/super-io.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> index b156fc85b8a3..8bc819832790 100644
> --- a/fs/bcachefs/super-io.c
> +++ b/fs/bcachefs/super-io.c
> @@ -1312,7 +1312,10 @@ void bch2_sb_to_text(struct printbuf *out, struct bch_sb *sb,
>  	prt_printf(out, "Device index:\t%u\n", sb->dev_idx);
>  
>  	prt_printf(out, "Label:\t");
> -	prt_printf(out, "%.*s", (int) sizeof(sb->label), sb->label);
> +	if (!strlen(sb->label))
> +		prt_printf(out, "(none)");
> +	else
> +		prt_printf(out, "%.*s", (int) sizeof(sb->label), sb->label);
>  	prt_newline(out);
>  
>  	prt_printf(out, "Version:\t");
> -- 
> 2.34.1
> 

Thanks, applied
