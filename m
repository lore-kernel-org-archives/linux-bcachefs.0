Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277D1991C9
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 21:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742075378; cv=none; b=q1I+tiiawWiRNGdTMFftqBrejTReQD1zmU6OoCGkcDXultHu6xVegaYdDdtYzvCxWdEZAGAyfKudA8NyXX1cjPOmtY9CCxe/stGH+crdPTl3yQZLpkkAau9EjABXMZ0E5zdxJCxlJYfM8qnS+sc0rOVgCm5oLudVhsDrB0mVKhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742075378; c=relaxed/simple;
	bh=lfZLCdN3XdwBJwR9/Ay60m6CocvPv1nFFKX+tqVmmt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9pzsBh7p4y+BxvGe7BYN0+qTos00214FXGUZBbT+R8sWqsmUXe36gfZkT0FA7XwNWqrifWrfnrSWanajGmXFH1WwCxQaPu1ZnJH/d+iu0hKMfkocovVnRIrzl9euisYGerb8dcmxMTYqg1NKXwXYyxxCOa89CeJq1EndtPLs6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HvyYXBqR; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HvyYXBqR"
Date: Sat, 15 Mar 2025 17:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742075373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tLLJMbC7vdgDL3D/wHXOxLAG5MNh3/yrmod8JgyC0HA=;
	b=HvyYXBqRjPuDFUajLAE/dznkarCCjJ031S6vAivX+/UC+Qp11L3wLvY7pMuMvCaIZeHkGj
	+zRh4wCkFD6ueUCiDT2+/JYIs5cGZqaHA1Ztv2Jp4NSi6uY4EBmsEKoX8PGypi5AdSoOVB
	YMMo7H4Wo+Fij80MOBLKF1YkbiDgoeU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Increase blacklist range
Message-ID: <5vwdw2xnbrcwgldzzz2aqn4uumycnjaspkzqdixveyxs4xo2uj@m4flzvcjzudl>
References: <20250315073942.1909895-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315073942.1909895-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 15, 2025 at 03:39:42PM +0800, Alan Huang wrote:
> Now there are 16 journal buffers, 8 is too small to be enough.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied! Thanks

> ---
>  fs/bcachefs/recovery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 71c786cdb192..a6e26733854d 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -899,7 +899,7 @@ int bch2_fs_recovery(struct bch_fs *c)
>  	 * journal sequence numbers:
>  	 */
>  	if (!c->sb.clean)
> -		journal_seq += 8;
> +		journal_seq += JOURNAL_BUF_NR * 4;
>  
>  	if (blacklist_seq != journal_seq) {
>  		ret =   bch2_journal_log_msg(c, "blacklisting entries %llu-%llu",
> -- 
> 2.48.1
> 
