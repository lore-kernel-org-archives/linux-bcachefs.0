Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7AC22EE1
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705514032; cv=none; b=Yay02NeRBSVB97wkAmwlv9PCBOGID0rsiqOpYpocdfosqzsQn3YHl9gEdXjQQWVjVvp8FQpHRq+P/hQjqJM6Cjupd0uc1D2vF5ywbbt4t2Fs1IXD+wzAmJlNxzz6Yu++EKWpqHKKtO3xU38STcxS3XYuhZUMwY/PdLH4Y1HJnUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705514032; c=relaxed/simple;
	bh=LorBFjJXZ6c/Tk4vvB+ZYDVR1crhwUBrtMiB7O9dpeM=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Scanned-By; b=ELX3dAeHzXfp6OqKyO1ciY314JIRKKSfQn+wCA9qVNdzrP2Z+Ka0sPpHOXxGKBvFcXW4ESxG7+zvdfu2aaVw7wGCD4h7TVFGRjiEljSCDlySpOw0ElofehkWPlmn4pNuSr2WfwG+93fbXnUUGPQL2d/Nn7uhCsqRqh2zl5CxRYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/l1U4y2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/l1U4y2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705514030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uJ7EcqWk/+ROmJlIPTmJh1wWqKrUV6BeOTGW9lHhBDc=;
	b=P/l1U4y2oToA3qdogmE8VKN9LzKa2kt96PfGHj5PHzY1nWORiFMj+dbEWAJQEMBQDtx8hS
	atNMSncg6EgpibctqMPJCXxFs3Sgx8jhGNh/lA9lmGbYiQmoeHy7QrQ3Z1FgFusz8mcb1B
	MvqNHwLvy2KOq3LCOrqkxzV2rv3eqDI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-4p-o36BeNEaO7ol1tSkfNw-1; Wed, 17 Jan 2024 12:53:44 -0500
X-MC-Unique: 4p-o36BeNEaO7ol1tSkfNw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D8BB185A783;
	Wed, 17 Jan 2024 17:53:44 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B1EA492BC6;
	Wed, 17 Jan 2024 17:53:44 +0000 (UTC)
Date: Wed, 17 Jan 2024 12:55:02 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH v2 2/2] common/rc: improve block size support for bcachefs
Message-ID: <ZagUdl+DlxIw+siv@bfoster>
References: <20240117092309.1134595-1-glass.su@suse.com>
 <20240117092309.1134595-2-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240117092309.1134595-2-glass.su@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Wed, Jan 17, 2024 at 05:23:09PM +0800, Su Yue wrote:
> For bcachefs, def_blksz is never assigned even MKFS_OPTIONS contains option
> '--block_size'. So block size of bcachefs on scratch dev is always 4096
> if _scratch_mkfs_sized is called without second parameter.
> 
> Add the pattern to set def_blksz if '--block_size' is given in MKFS_OPTIONS.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
> changelog:
> v2:
>     Born.
> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 31c21d2a8360..6a01de69cf05 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -950,6 +950,9 @@ _scratch_mkfs_sized()
>  	jfs)
>  		def_blksz=4096
>  		;;
> +	bcachefs)
> +		def_blksz=`echo $MKFS_OPTIONS | sed -rn 's/.*(--block_size)[ =]?+([0-9]+).*/\2/p'`
> +		;;

So if the default bcachefs block size is 512b, I wonder if this should
do something like what the udf branch does a few lines above and
override the hardcoded default of 4k. ISTM this whole thing would be
more robust if it just elided the param in the default cases and let the
associated mkfs tool use its own default, but that's probably a separate
issue. Hm?

Brian

>  	esac
>  
>  	[ -n "$def_blksz" ] && blocksize=$def_blksz
> -- 
> 2.43.0
> 

