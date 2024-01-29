Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23EB66B42
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706543018; cv=none; b=PO6pu978YwKqgGuwuh/9t1bc6OSVPC7dI2pYhAEoBQCXb21IG/VpqsPmNNqszmzAPDE2gX7BWi7xTgj+VSo6aBnjQrVsMtCCGtP6hd5raU4czDA+SLVy3CE945gqV0FhVga9VOq5S2E6rByNJsmMN1ZvRzNNYpXVogNI3UJ8/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706543018; c=relaxed/simple;
	bh=iTl8hq7LJFCR6hx30Y38/ov7JcEgFy85KxrQV2YLif4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SkZWIwrkDzcP6adsAgdY+PT79tUZcOBFX7p1ZV3RTuOYF5oGVcH02KwH8NoLTi5LCiupAuLdVnJW+RMeOD4yaZbbPWAh2ZMwpGupQXO084rjx0wh4lf1uPgF1oG8ZpuiUkRzaajKrnLYnTVu4FrOCM7rW0etWfNv1Ql39vDPc98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KzH7jJjo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KzH7jJjo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706543015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6szSBSJ4uBrfEuCdPBvngnI33WI8uEUmp7SgYCHGf6U=;
	b=KzH7jJjo5JCAxe4QyIWqcs5Q/mqP8ss8cMh/e6yYK8inEA4iYtM+FnLlOwo5BlMenHeTMI
	JGBgIc+C2lQOTvFOfwlCeR5NHwIx60kOMCH8OW5KhmsXvcIWO0bIlnKP5nMLYDCLsa5VyP
	MD3uBf+ltLclboHzblJxPycGMT0sx8s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-3mvo6otjNdCB1c61PDAM-g-1; Mon, 29 Jan 2024 10:43:33 -0500
X-MC-Unique: 3mvo6otjNdCB1c61PDAM-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF62385A589;
	Mon, 29 Jan 2024 15:43:32 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 704072166B31;
	Mon, 29 Jan 2024 15:43:32 +0000 (UTC)
Date: Mon, 29 Jan 2024 10:44:50 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH v3 2/2] common/rc: improve block_size support for bcachefs
Message-ID: <ZbfH8nFO12Q0tSIp@bfoster>
References: <20240129140101.4259-1-l@damenly.org>
 <20240129140101.4259-4-l@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129140101.4259-4-l@damenly.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Mon, Jan 29, 2024 at 10:01:01PM +0800, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> mkfs.bcachefs now supports option '--block_size' to allow
> custom block_size.
> 
> Add the pattern to set def_blksz if MKFS_OPTIONS contains the
> option in _scratch_mkfs_sized.
> Also let mkfs.bcachefs decide blocksize if no option is given in
> local.config or _scratch_mkfs_sized parameter.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
> changelog:
> v3:
>     Add logic to Let mkfs.bcachefs decide blocksize if no option is given in
>     local.config or _scratch_mkfs_sized parameter.
> v2:
>     Born.
> ---

Looks like the series duplicates the patches for some reason..

>  common/rc | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 31c21d2a8360..315a2413f963 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -930,6 +930,7 @@ _scratch_mkfs_sized()
>  	local fssize=$1
>  	local blocksize=$2
>  	local def_blksz
> +	local blocksize_opt
>  
>  	case $FSTYP in
>  	xfs)
> @@ -950,6 +951,13 @@ _scratch_mkfs_sized()
>  	jfs)
>  		def_blksz=4096
>  		;;
> +	bcachefs)
> +		def_blksz=`echo $MKFS_OPTIONS | sed -rn 's/.*(--block_size)[ =]?+([0-9]+).*/\2/p'`
> +		[ -n "$def_blksize" ] && blocksize_opt="--block_size=$def_blksize"
> +		[ -n "$blocksize" ] && blocksize_opt="--block_size=$blocksize"

This seems reasonable to me, but if I follow this function correctly the
behavior when both the param ($blocksize) and MKFS_OPTIONS specify a
block size is that MKFS_OPTIONS overrides the former. For bcachefs it
looks like the above does the opposite. Should we switch around the
above two statements?

Brian

> +		# If no block size is given by local.confg or parameter, blocksize_opt is empty.
> +		# Let MKFS_BCACHEFS_PROG decide block size on its own.
> +		;;
>  	esac
>  
>  	[ -n "$def_blksz" ] && blocksize=$def_blksz
> @@ -1051,7 +1059,7 @@ _scratch_mkfs_sized()
>  		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
>  		;;
>  	bcachefs)
> -		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize --block_size=$blocksize $SCRATCH_DEV
> +		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $SCRATCH_DEV
>  		;;
>  	*)
>  		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
> -- 
> 2.43.0
> 
> 

