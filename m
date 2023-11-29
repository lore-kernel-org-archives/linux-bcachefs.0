Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VLiS20OM"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCD895
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 13:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701293806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5GixFoov6jiXZ9zFkX121wR8CuGEds8cNEpO8FfpBkU=;
	b=VLiS20OMRUHAfqzF0bJ/CEhvoutrQFjyuqb43n2mG0v0ceC2WDm7WS75j9E73PiUwHCN6p
	NYXnHVUDzIuJHsFqVkFw+oKgr2B/VurlUvWsvJUihk5KIJ12uuGBinYiiRAFB93EcZDULH
	slXgXIExja73/KKqgZtKcyJVQihfV4E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-PNTOOKvLOqu9sHIp4FlKfg-1; Wed, 29 Nov 2023 16:36:45 -0500
X-MC-Unique: PNTOOKvLOqu9sHIp4FlKfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEE8785A58C;
	Wed, 29 Nov 2023 21:36:44 +0000 (UTC)
Received: from redhat.com (unknown [10.2.17.161])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82FE35028;
	Wed, 29 Nov 2023 21:36:44 +0000 (UTC)
Date: Wed, 29 Nov 2023 15:36:43 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] generic/459: improve shutdown/read-only check to
 accommodate bcachefs
Message-ID: <ZWeu623M2xNW7IlH@redhat.com>
References: <20231129201614.347901-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129201614.347901-1-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Wed, Nov 29, 2023 at 03:16:14PM -0500, Brian Foster wrote:
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
> Refactor into a small helper, check for touch command failure, and
> consider the fs read-only if either that or the mount entry check
> indicates it.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine.

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
> 
> v2:
> - Drop error filtering and just check touch failure.
> - Comment tweaks.
> v1: https://lore.kernel.org/fstests/20231117144317.10882-1-bfoster@redhat.com/
> 
>  tests/generic/459 | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/tests/generic/459 b/tests/generic/459
> index 4dd7a43b..c3f0b2b0 100755
> --- a/tests/generic/459
> +++ b/tests/generic/459
> @@ -57,6 +57,24 @@ origpsize=200
>  virtsize=300
>  newpsize=300
>  
> +# Check whether the filesystem has shutdown or remounted read-only. Shutdown
> +# behavior can differ based on filesystem and configuration. Some fs' may not
> +# have remounted without an additional write while others may have shutdown but
> +# do not necessarily reflect read-only state in the mount options. Check both
> +# here by first trying a simple write and following with an explicit ro check.
> +is_shutdown_or_ro()
> +{
> +	ro=0
> +
> +	# if the fs has not shutdown, this may help trigger a remount-ro
> +	touch $SCRATCH_MNT/newfile > /dev/null 2>&1 || ro=1
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
> @@ -113,13 +131,9 @@ ret=$?
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

