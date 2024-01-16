Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C978763AE
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 13:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkD66i9E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705412168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Ah6aTcdTYMpyaqib2NnkHjiDGc+iX+PqIWbHGZSyoQ=;
	b=HkD66i9E3COGckohcZn2LvUvTX/j/KgvjBGAFgS43VZnq0fETfD+sDxjY2VsN8P0TKBekn
	By95i6j6Pi2n4n+VDzqHBZpDx90brzPFA9DJTtIRNOsNCTfJAiTtx5f/xJQVHqiBCTISlD
	ziHJTyZtezOS4fb3oMjsAnw23jlZ/2E=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-_RV9yR67PsK88VGvLdpFgw-1; Tue,
 16 Jan 2024 08:36:04 -0500
X-MC-Unique: _RV9yR67PsK88VGvLdpFgw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A38A53C14947;
	Tue, 16 Jan 2024 13:36:03 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BF0B3C25;
	Tue, 16 Jan 2024 13:36:03 +0000 (UTC)
Date: Tue, 16 Jan 2024 08:37:21 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Message-ID: <ZaaGkadipvNY02HM@bfoster>
References: <20240114044120.140111-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240114044120.140111-1-glass.su@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Sun, Jan 14, 2024 at 12:41:20PM +0800, Su Yue wrote:
> mkfs.bcachefs supports force overwrite when option '-f' is given:
> $ mkfs.bcachefs --help | grep force
>   -f, --force
> After this commit, MKFS_BCACHEFS_PROG will contains ' -f' so
> we don't have to add '-f' to $MKFS_OPTIONS manually.
> 
> It also fixes generic/466 which unsets MKFS_OPTIONS causing
> that test hangs in mfks.bcachefs waiting for confirmation of
> the force overwrite.
> 

This seems mostly reasonable to me, but I'm kind of wondering why I
haven't had to add -f to my MKFS_OPTIONS for bcachefs. Is there
something unique to the test environment that affects this? I.e., I
don't see any issue with generic/466 on a recent Fedora, even if I
pre-format the scratch dev with XFS.

> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  common/config |  3 ++-
>  common/rc     | 12 +++++++++---
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/common/config b/common/config
> index c9771ff934cb..1f9edceec57a 100644
> --- a/common/config
> +++ b/common/config
> @@ -105,7 +105,7 @@ set_mkfs_prog_path_with_opts()
>  	# Note: mkfs.f2fs doesn't support the --help option yet, but it doesn't
>  	# matter since it also prints the help when an invalid option is given.
>  	if [ "$p" != "" ] && \
> -		$p --help |& grep -q "[[:space:]]-f[[:space:]|]"; then
> +		$p --help |& grep -q "[[:space:]]-f[[:space:]|,]"; then
>  		echo "$p -f"
>  	else
>  		echo $p
> @@ -313,6 +313,7 @@ export MKFS_REISER4_PROG=$(type -P mkfs.reiser4)
>  export E2FSCK_PROG=$(type -P e2fsck)
>  export TUNE2FS_PROG=$(type -P tune2fs)
>  export FSCK_OVERLAY_PROG=$(type -P fsck.overlay)
> +export MKFS_BCACHEFS_PROG=$(set_mkfs_prog_path_with_opts bcachefs)
>  
>  # SELinux adds extra xattrs which can mess up our expected output.
>  # So, mount with a context, and they won't be created.
> diff --git a/common/rc b/common/rc
> index cc92fe0681d6..f2e900bf1166 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -611,6 +611,9 @@ _test_mkfs()
>      xfs)
>  	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* $TEST_DEV
>  	;;
> +    bcachefs)
> +    $MKFS_BCACHEFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
> +	;;
>      *)
>  	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $TEST_DEV
>  	;;
> @@ -753,6 +756,10 @@ _scratch_mkfs()
>  		mkfs_cmd="yes | $MKFS_PROG -t $FSTYP --"
>  		mkfs_filter="grep -v -e ^mkfs\.ocfs2"
>  		;;
> +    bcachefs)
> +		mkfs_cmd="$MKFS_BCACHEFS_PROG"
> +		mkfs_filter="cat"
> +		;;
>  	*)
>  		mkfs_cmd="yes | $MKFS_PROG -t $FSTYP --"
>  		mkfs_filter="cat"
> @@ -1044,7 +1051,7 @@ _scratch_mkfs_sized()
>  		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
>  		;;
>  	bcachefs)
> -		$MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS --fs_size=$fssize --block_size=$blocksize $SCRATCH_DEV
> +		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize --block_size=$blocksize $SCRATCH_DEV

Should this function have another bcachefs check at the top to set
def_blksize in the case the config specifies a blocksize to use?

Brian

>  		;;
>  	*)
>  		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
> @@ -1128,8 +1135,7 @@ _scratch_mkfs_blocksized()
>  						-C $blocksize $SCRATCH_DEV
>  		;;
>  	bcachefs)
> -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS --block_size=$blocksize \
> -								$SCRATCH_DEV
> +		_scratch_mkfs --block_size=$blocksize
>  		;;
>  	udf)
>  		_scratch_mkfs -b $blocksize
> -- 
> 2.43.0
> 
> 

