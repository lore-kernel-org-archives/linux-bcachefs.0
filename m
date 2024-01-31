Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AD080C0F
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706710315; cv=none; b=hushtBqeu4LptCoo5VVE5YT5a8v4RL41E2dOGWdsyqvbXhI0CPmzBofTRBBnCR9Ad15ax42DYtW1Eo9mgbASSO6DA6+wGzP90t0d7UrC61mWHfPHYQkctLA9E9CckFoIUvTy7YAo/TeYo61ZrO/84ZAlRRl7yy9L6itExJqry04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706710315; c=relaxed/simple;
	bh=rVR7BNBZBtNMx2j/+oKZJxghwXHKX9iut7QXMbHxjN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6aqEGB2Tt23IXNtwD0BcEe/2T+Aej3Dedh9f/Hc6ndhhF6IcqnfHJio0DAqaxWK6hyMKapQkvRL+i11U1hQEwThvnjjMB7CYwGV+BRZbMRw6Nug02A0rF1o0viIYPXWtM7jElox3NlTY6WhhS5ifgZTQZfwszegYVf5SHCHywU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvRl8yXR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvRl8yXR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706710312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AMjcP4lz0fQtJiuXGiD0XLKEQG2nHpsVAsiofujyr0U=;
	b=fvRl8yXRBcgQ2qxuA8ChkdwclnmPbeIzK+COmRH8pUpEWIlPExY1eOiG0kM1tK/HSmqWlt
	MO8vfCvI0dqysnQyxWRENHnp1lpmptvicSji2FFMdo/2RB0mGH1uOHbsRSp43HrNWSVP6r
	5BvyrLjmnEVGrV0vcTbospr9jNqbtHA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-apwUABmkM1K-GOL4titjeQ-1; Wed, 31 Jan 2024 09:11:48 -0500
X-MC-Unique: apwUABmkM1K-GOL4titjeQ-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5ce67a3f275so3713089a12.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 06:11:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706710307; x=1707315107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMjcP4lz0fQtJiuXGiD0XLKEQG2nHpsVAsiofujyr0U=;
        b=prjmUeeLAOeqRILvequLtIA9CTHqV/U/Wv4XKL9jNALqdzZ3Nv3PUsNESbxecA6WGH
         xp78Sirid6k5MIorYuQCQEytZkCUk7aCadrKMEKGTAufFCLicD0yepsXi7QUuagcn+Vy
         /2ZnWQ77lQSeKqS/hfLbmAMyGHmxlCg9AFM9JrC/EBNG+JwTpUdVMAOH82A/Gg3uO6Ns
         m/cH5LnJ0fb4eXsq3e7w4jw3YPTzPkTuANVzVyMSMgSP/DtD7Lrj5Z/hJ5mqE7cXESSJ
         eQ8p1NxoAoBSy/xTOEktqFHYTzYdogE2HANlXzkxi6c08eVIbE0KAeZG8Z2dC483qhrG
         EXGg==
X-Gm-Message-State: AOJu0YxpqvI/9OcIDKJRtJSS8CDEXBDi1UO1E+9nP6loZTKNKU8vukLu
	Uns+6GhB2wLYBS23CPgj/58TuHUmuR/vTn8UDiRiGfJwoVRX/+jX0KrvGnuybiMqPpS1mqRwXnQ
	5QbTFVg1jGmu9THTDt3YU33ydXQOoGYiXFWSd5mZkvsTHLjcatvjEPKEMW5LEp1trOMOzFXCXgY
	M=
X-Received: by 2002:a05:6a21:32a3:b0:19c:a988:24b9 with SMTP id yt35-20020a056a2132a300b0019ca98824b9mr1904612pzb.25.1706710307502;
        Wed, 31 Jan 2024 06:11:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzo2Qd33nCbPvMgXORy+rq2hkew1ZZjh96/HTu6onc924vg6puW7DvQgM4aOjCuH1JYiMreg==
X-Received: by 2002:a05:6a21:32a3:b0:19c:a988:24b9 with SMTP id yt35-20020a056a2132a300b0019ca98824b9mr1904588pzb.25.1706710307199;
        Wed, 31 Jan 2024 06:11:47 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCV6cTZZXe+vFjg1zlwg73JXpM1OTkI9xZKxCMJIMNOUsryu+JOD3rAVbd7/UF9mZ5DHMUM4bDaDKs7Xxp86myrMBIUKCarLVLZP2qg7RlJTNhAm6sDvPO1kZxQiWE4saEqf4wwaMtpjqpbNmbz7tOEPDw==
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x7-20020a636307000000b005c259cef481sm10526630pgb.59.2024.01.31.06.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 06:11:46 -0800 (PST)
Date: Wed, 31 Jan 2024 22:11:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org, l@damenly.org,
	bfoster@redhat.com
Subject: Re: [PATCH v4 2/2] common/rc: improve block_size support for bcachefs
Message-ID: <20240131141143.st3gpqn4iivdyfey@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
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

Thanks for helping fstests to support bcachefs better, feel
free to send more patches for bcachefs testing.

Reviewed-by: Zorro Lang <zlang@redhat.com>

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
> 

