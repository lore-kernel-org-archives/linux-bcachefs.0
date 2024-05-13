Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BEBA3F
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715603472; cv=none; b=Rmwn31QTDeRsK1fq3JzYkaNQ1QO+TLIYfw96o3qKstdbug0JZ2gkSMHMjwfZCWvNbzN2p/Qmd9OkbjESUETMi0c/v5A6PHYr31GMAnlW1+R4KUpFCzEzeBQPWvXTZ53nAeYjAUKJiY0ufo0JT6iNYNiGg7LCxUmRJj7zg3nP2jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715603472; c=relaxed/simple;
	bh=0+TLWzVsB6jJpfwvMnUMCGhDB2IjR8f78RixUDMnEBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9jbVDDfZ6YqQWeOFhbQvjJlkS4TUVgc2Ecy2XGjWJcz9m1Dk/1LY7L2p1T53JRdpijtqMbULagVvNusHOzhoTILaHJ2hwiwPannTWmViV27Fn44d3PSNMBH2X7rDHYkN5Gwql5DwQ7l8ZmtTMs7BIzbdFBes3t9jJ634X1UAQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dF3BFSWk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dF3BFSWk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715603469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S1Sj+IKGLpRQdW81MrrMjviyjfpcppQRlVAoAeNuGz4=;
	b=dF3BFSWko3NHU4FFurAmnNxucsgxfIU0S30qxUuQnSarHXL5IwqdvpANDiOBuZaIZIUzjk
	7cyec2VPoypMsx8PE/kRAy2KOf+l+r1BN1g5bQvpnUpO2pSXjUuZHTvesG1dnGOfSoP4pu
	V5F58pztvXDJotF8eRxSNNgTKlTtHQg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-Ga_Z0kVFOAOWmSlqbUeAtQ-1; Mon,
 13 May 2024 08:31:04 -0400
X-MC-Unique: Ga_Z0kVFOAOWmSlqbUeAtQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A43F3C025C6;
	Mon, 13 May 2024 12:31:04 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D95E40C6EB7;
	Mon, 13 May 2024 12:31:02 +0000 (UTC)
Date: Mon, 13 May 2024 08:31:20 -0400
From: Brian Foster <bfoster@redhat.com>
To: Youling Tang <youling.tang@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: set FMODE_CAN_ODIRECT instead of a dummy
 direct_IO method
Message-ID: <ZkIIGMlbg4s3GJFb@bfoster>
References: <20240510061058.316819-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510061058.316819-1-youling.tang@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Fri, May 10, 2024 at 02:10:58PM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> Since commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") file
> systems can just set the FMODE_CAN_ODIRECT flag at open time instead of
> wiring up a dummy direct_IO method to indicate support for direct I/O.
> Do that for bcachefs so that noop_direct_IO can eventually be removed.
> 
> Similar to commit b29434999371 ("xfs: set FMODE_CAN_ODIRECT instead of
> a dummy direct_IO method").
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> ---

Seems straightforward:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/bcachefs/fs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index a8d71cec1c17..7ef41ce2d8c6 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1142,6 +1142,8 @@ static int bch2_open(struct inode *vinode, struct file *file)
>  			return ret;
>  	}
>  
> +	file->f_mode |= FMODE_CAN_ODIRECT;
> +
>  	return generic_file_open(vinode, file);
>  }
>  
> @@ -1234,7 +1236,6 @@ static const struct address_space_operations bch_address_space_operations = {
>  	.write_end	= bch2_write_end,
>  	.invalidate_folio = bch2_invalidate_folio,
>  	.release_folio	= bch2_release_folio,
> -	.direct_IO	= noop_direct_IO,
>  #ifdef CONFIG_MIGRATION
>  	.migrate_folio	= filemap_migrate_folio,
>  #endif
> -- 
> 2.34.1
> 
> 

