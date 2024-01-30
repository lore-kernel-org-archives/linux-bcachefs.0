Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9125D6EB4E
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Jan 2024 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706624204; cv=none; b=po/w1Wl185xAM831ogd+exsXFXH1o9buQfR2yA22KnB06T+IYOzmTkasojf+ONp7u7kKz1O+/rsowqnBpD0jcX7xlDYtAJlu97rU29Lj6M9zOzo3em4exZjPo3ArHKZ+8eDUC51kVPH3FSHSKhjZIVehYqeqi8nqThVUPa5DsCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706624204; c=relaxed/simple;
	bh=dIHR7tbVRdRZOZs6p7+4jwYHHAHITBrWAw+mYXsuhAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGdFGZpVpDtjuK14nontVZy6iYe+OMeTkRt4i2xH/c5G0cyxJbfLf+gbXjuMYDAJ1Pc2Z0E9EXpoxSjSN76uMjoMNHGYEouc8H20QRFMMskDh49yIDb5cHdfj4FIMCPFTQe33H0Qojn11KcHK1QZ+zAyQilkF76OcvfBRaD3VOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FQ4r6ivL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQ4r6ivL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706624201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gwISMsoN/5QFwgt7DwVxRuyBX9kYfx56dutv3QfNtwE=;
	b=FQ4r6ivLmYRX4v0kQZXxhSj6Kd85icdc8UYXBBNNHhA4j1vl6bANR9mPruOrCSBZeqegWz
	NAonM3sug8eUHrgLHWnPWd1xsUU3V6AgtXmtMu3Qj7PtbOO2JfCKGXgjhGBtNJrwqJ6iNJ
	xXN2SD+28iA8Z0ysdUFBxsvNsjmvXS0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-equ7zsFAMBmTqFUF3MpcCA-1; Tue, 30 Jan 2024 09:16:36 -0500
X-MC-Unique: equ7zsFAMBmTqFUF3MpcCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FF2C859705;
	Tue, 30 Jan 2024 14:16:36 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.186])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9E6C111E8;
	Tue, 30 Jan 2024 14:16:35 +0000 (UTC)
Date: Tue, 30 Jan 2024 09:17:54 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH v4 2/2] common/rc: improve block_size support for bcachefs
Message-ID: <ZbkFEt+HjOtD+H0P@bfoster>
References: <20240129235104.8976-1-l@damenly.org>
 <20240129235104.8976-2-l@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129235104.8976-2-l@damenly.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Tue, Jan 30, 2024 at 07:51:04AM +0800, Su Yue wrote:
> From: Su Yue <glass.su@suse.com>
> 
> mkfs.bcachefs now supports option '--block_size' to allow
> custom block_size.
> 
> Add the pattern to set def_blksz if MKFS_OPTIONS contains the
> option in _scratch_mkfs_sized.
> Also let mkfs.bcachefs decide blocksize if no option is given in
> MKFS_OPTIONS or _scratch_mkfs_sized parameter.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
> changelog:
> v4:
>     Respect block_size in MKFS_OPTIONS. 
> v3:
>     Add logic to Let mkfs.bcachefs decide blocksize if no option is given in
>     local.config or _scratch_mkfs_sized parameter.
> v2:
>     Born.
> ---

This LGTM, appreciate the tweaks and discussion:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> +		[ -n "$blocksize" ] && blocksize_opt="--block_size=$blocksize"
> +		[ -n "$def_blksize" ] && blocksize_opt="--block_size=$def_blksize"
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

