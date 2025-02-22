Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE90413CA97
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740233276; cv=none; b=BUgumCxsw5I5kwTp0DHmNPDiYKAmHH6UKTGl5cF7CqP9WR27NJaooSOSiKDnFLLcenwBCkNi8bEhlmGQWjw37xKMuumTVKi8W/q292yJ37rfnhUXe2veXsPqeKVyIxmgEZ+dfJmoDY25AL/zzffVR6nzv/TYYfic3mb4OnmbhII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740233276; c=relaxed/simple;
	bh=EETjZrTkti9O54+28/Xr7jUIzro7LuguCyq+FcHbTqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=goEHco6pBmdj/A8vrVSgDJfj9bESUMF5zlt+tpDz5AbnMBegpwSn31oRpO5y3WyuxhkZwm1tLwZanr6FWbGisjikDtgasPGlImPhmZj8Wq7kGi5bf3yLES7uPaqDUHHLGeP7OUBjxXgWW6dFHcs/KiJudoYa4798U6wMhxQsMf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KEGdQtph; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KEGdQtph"
Date: Sat, 22 Feb 2025 09:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740233272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NHNAc95GZAIggoCDMsy4Zih6HwdRERF2x6idzrdDUwg=;
	b=KEGdQtphYdJZSTcGrcnzOOXtZf/uJxELvTt06cSaXzLocuYmkyYYgn9RsVDWyVDSACvHPQ
	/Fxvxl9b9rMPpXmkXWnFNnjfsUMetYbdq2CGpbBT5fTH/gloklHFE5emGkVoKoU1TMlOCj
	sWE/nrDQhG8H1b0TwNDyDovMfpaAVBU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, Joshua Ashton <joshua@froggi.es>, 
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: Re: [PATCH] bcachefs: Use flexible arrays in dirent
Message-ID: <3tk6bxtgunmcwlqxopmbsdxl35qtwypblqcze3ebroxujmlujv@e3rqmexhjso4>
References: <20250213184607.18237-19-kent.overstreet@linux.dev>
 <f048a5a514b41af8523618ab759c3e79df130954.1740161242.git.g2p.code@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f048a5a514b41af8523618ab759c3e79df130954.1740161242.git.g2p.code@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 21, 2025 at 06:26:27PM +0000, Gabriel de Perthuis wrote:
> A fake d_name[0]/d_names[0] flexible array tickled UBSAN.
> 
> Use DECLARE_FLEX_ARRAY to work around a compiler restriction on flex
> arrays in unions:
> https://people.kernel.org/kees/bounded-flexible-arrays-in-c
> 
> Fixes: "bcachefs: bcachefs_metadata_version_casefolding"
> Closes: https://github.com/koverstreet/bcachefs/issues/824
> 
> Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>

Applied

> ---
>  fs/bcachefs/dirent_format.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/dirent_format.h b/fs/bcachefs/dirent_format.h
> index 2e766032e1e91..a46dbddd21aad 100644
> --- a/fs/bcachefs/dirent_format.h
> +++ b/fs/bcachefs/dirent_format.h
> @@ -42,13 +42,13 @@ struct bch_dirent {
>  	union {
>  	struct {
>  		__u8		d_pad;
>  		__le16		d_name_len;
>  		__le16		d_cf_name_len;
> -		__u8		d_names[0];
> +		__u8		d_names[];
>  	} d_cf_name_block __packed;
> -	__u8			d_name[0];
> +	__DECLARE_FLEX_ARRAY(__u8, d_name);
>  	} __packed;
>  } __packed __aligned(8);
>  
>  #define DT_SUBVOL	16
>  #define BCH_DT_MAX	17
> -- 
> 2.45.2
> 
