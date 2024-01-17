Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5472222EE0
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 17:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705514021; cv=none; b=bJdDog/pKGFKvFq/R/jn0Aw/2ICmly7IrnF0/kemEUf7wHBwPZpPbNAfM9ey1ulHXbgkFC67XI9rtJxSdmo507VvsDyD+qmv4lSrrqliHPE4ZUFVhmMU7SITdXLvUUsnuw8zktNBmSMY2m3ZwJCI+1FGKtcuneyxcCnYa/7JTws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705514021; c=relaxed/simple;
	bh=8stMnKWlVWRumIkmEpircuAHhW03YejWG9oad+6SARg=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Scanned-By; b=UP1G1Xaiy2pEex4Shr7QmobA+h6HHZbG2EjyLTHpKp9/gDVh5Ozi9bjnuB/016+REt+huG0Ux+Ppz9ndN46pXDinjbZfRQsFnnoNa08ooQ6njr6Acxs0+GOL7z7gmA7kDYLSwwQdIXymFhHzzKC8yyWyDo96K5st9Fv4lOd/4hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=brf9GbOt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="brf9GbOt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705514019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wLyK4UQX1uk+DKpLigRyoucRp76GD7hyM2eePs6ERw8=;
	b=brf9GbOt7RbaeWROM3vMcChYC5QmKhEfTiIsInQpdBsuTc7Reb7kv+cLoMz8Pz628+1in5
	A6J/2+PW94ThKPLb7UOQ15bAFnTmCAOeRCQoN97ZLX7cj4IJhMgnMsDP8cnyGkQfLuO8jT
	yarBSVitT3zASOhF88BlijnGnpye/CQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-IZoMrSISMJGFyDv4AA7uoA-1; Wed,
 17 Jan 2024 12:53:36 -0500
X-MC-Unique: IZoMrSISMJGFyDv4AA7uoA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF2D52812FF3;
	Wed, 17 Jan 2024 17:53:35 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EE7B1121306;
	Wed, 17 Jan 2024 17:53:35 +0000 (UTC)
Date: Wed, 17 Jan 2024 12:54:53 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH v2 1/2] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Message-ID: <ZagUbTaW4S29aN2N@bfoster>
References: <20240117092309.1134595-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240117092309.1134595-1-glass.su@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Wed, Jan 17, 2024 at 05:23:08PM +0800, Su Yue wrote:
> mkfs.bcachefs supports force overwrite when option '-f' is given:
> $ mkfs.bcachefs --help | grep force
>   -f, --force
> 
> There are some tests which call _scratch_mkfs multiple times
> e.g. tests/generic/171. Without '-f' in MKFS_OPTIONS,
> these tests just hang in overwrite confirmation.
> After this commit, MKFS_BCACHEFS_PROG will contains ' -f' so
> we don't have to add '-f' to MKFS_OPTIONS manually to make
> these tests pass.
> 
> It also fixes generic/466 which unsets MKFS_OPTIONS causing
> that test hangs in mfks.bcachefs waiting for confirmation of
> the force overwrite.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
> changelog:
> v2:
>     Add more details about why MKFS_BCACHEFS_PROG should contain '-f'.
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
> index 524ffa02aa6a..31c21d2a8360 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -611,6 +611,9 @@ _test_mkfs()
>      xfs)
>  	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* $TEST_DEV
>  	;;
> +    bcachefs)
> +    $MKFS_BCACHEFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null

Whitespace looks off on this line, but I suppose the maintainer can fix
that up if desired. That aside this LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

