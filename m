Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301C44501A;
	Fri, 17 Nov 2023 22:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaMnTsHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E39C433CB;
	Fri, 17 Nov 2023 22:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700259274;
	bh=PNYfVQ+zO7InrXBryqJTm7E9w6l0Va52AZcS/gJ58Q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IaMnTsHTEskPPg5ElYnV8jD9pEzJzf5iWm12C7VdcB3Ja4WwVA7qjo9O87/yKF97z
	 aaFQX0Q3pVaCeZ2KxHzMQF0TLGf/P3vyfTzQ5KZA/NjbEpLcrapuBuG5VqMX5e1d/F
	 jyyMyE8pzbMuanT+5X584deFygDISDo8DcOupoB/jMX2i00sBH9eZnRq2nN+Bnn09z
	 O6N10s2QbZTGxQ/bM0QtNdZcZRg9wdtOgjo+bw4Y+L+c56NvvIQ4DCc/Q0PaQzSACB
	 INAAkGdktP/70XnO3f3ggQA73xyCSlpcA76hmyrbqe+E5h3GsSpqpe3qxWVFnM1R0N
	 iUG3wHJRFKBjw==
Date: Fri, 17 Nov 2023 14:14:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] generic/459: improve shutdown/read-only check to
 accommodate bcachefs
Message-ID: <20231117221434.GI36175@frogsfrogsfrogs>
References: <20231117144317.10882-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117144317.10882-1-bfoster@redhat.com>

On Fri, Nov 17, 2023 at 09:43:17AM -0500, Brian Foster wrote:
> generic/459 occasionally fails on bcachefs because the deliberately
> induced I/O errors caused by exhausting the overprovisioned thin
> pool can lead to filesystem shutdown. This test considers this
> expected behavior on certain fs', but only checks for the ext4
> remount read-only behavior. bcachefs does a similar emergency
> read-only transition in response to certain I/O errors, but it
> behaves more similar to an XFS shutdown and doesn't necessarily
> reflect "ro" state in the mount table (unless induced by userspace).
> 
> Since the test already runs a touch command to help trigger the ext4
> error handling sequence, this can be tweaked to serve double duty
> and also more accurately detect read-only status on bcachefs.
> Refactor into a small helper, check for an EROFS return to the touch
> command, and consider the fs read-only if either that or the mount
> entry check indicates it.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Something I realized when writing up the commit log is that the EROFS
> check doesn't technically cover XFS, which IIRC returns EIO in response
> to any sorts of writes once the fs has shutdown. I'm not sure this
> matters currently because XFS doesn't shutdown due to the default
> behavior to retry failed I/Os, but technically if XFS were configured to
> not retry I/O errors and go right to permanent failure, I suspect it
> would fail this test in the same way bcachefs does.
> 
> That could be addressed fairly easily by also checking for EIO error
> message output, or just assuming touch failure == shutdown, etc. I don't
> have much preference on that, so thoughts appreciated.

I wish there was a better way to signal that a filesystem has shut down,
though ATM that isn't even a VFS level concept.  I generally assume that
touch failure == shutdown if the fs was previously writable.

OTOH with statmount landing soonish, perhaps we ought to apply for a new
SB_SHUTDOWN state flag for it to export?

--D

> Brian
> 
>  tests/generic/459 | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/tests/generic/459 b/tests/generic/459
> index 4dd7a43b..d0c48325 100755
> --- a/tests/generic/459
> +++ b/tests/generic/459
> @@ -57,6 +57,26 @@ origpsize=200
>  virtsize=300
>  newpsize=300
>  
> +# Check whether the filesystem has shutdown or remounted read-only. Behavior can
> +# differ based on filesystem and configuration. Some fs' may not have remounted
> +# without an additional write while others may have shutdown but do not
> +# necessarily reflect read-only state in the mount options. Check both here to
> +# cover the various scenarios.
> +is_shutdown_or_ro()
> +{
> +	ro=0
> +
> +	# if the fs has not shutdown, this may help trigger a remount-ro
> +	touch $SCRATCH_MNT/newfile 2>&1 | \
> +		grep "Read-only file system" > /dev/null
> +	[ $? == 0 ] && ro=1
> +
> +	_fs_options /dev/mapper/$vgname-$snapname | grep -w "ro" > /dev/null
> +	[ $? == 0 ] && ro=1
> +
> +	echo $ro
> +}
> +
>  # Ensure we have enough disk space
>  _scratch_mkfs_sized $((350 * 1024 * 1024)) >>$seqres.full 2>&1
>  
> @@ -113,13 +133,9 @@ ret=$?
>  #	- The filesystem stays in Read-Write mode, but can be frozen/thawed
>  #	  without getting stuck.
>  if [ $ret -ne 0 ]; then
> -	# freeze failed, filesystem should reject further writes and remount
> -	# as readonly. Sometimes the previous write process won't trigger
> -	# ro-remount, e.g. on ext3/4, do additional touch here to make sure
> -	# filesystems see the metadata I/O error.
> -	touch $SCRATCH_MNT/newfile >/dev/null 2>&1
> -	ISRO=$(_fs_options /dev/mapper/$vgname-$snapname | grep -w "ro")
> -	if [ -n "$ISRO" ]; then
> +	# freeze failed, filesystem should reject further writes
> +	ISRO=`is_shutdown_or_ro`
> +	if [ $ISRO == 1 ]; then
>  		echo "Test OK"
>  	else
>  		echo "Freeze failed and FS isn't Read-Only. Test Failed"
> -- 
> 2.41.0
> 
> 
