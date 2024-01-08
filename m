Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D651016
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C29zPXjw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704727447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oP+sCTl7D3d9bP7Xl6OvNpgwjx1t2TZx9bxzBFInDho=;
	b=C29zPXjw+OPbB+BwPQSIwe6yfsRyVjUMDFgXEXQNamYgXRZDpNbqfGpZA8+O5YrOFDrrLj
	fTk3LjPUGcjAzGTk00/crlYLp4iAFzcz5scDnG1DLcy/E227NUAoCWa7+9SEjvIn/wRAPb
	/yZRH3i9cwaqPC6Ham570MzhPihWgkk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-gm1AfSY-NS2Kk8N5iMMjHA-1; Mon, 08 Jan 2024 10:23:59 -0500
X-MC-Unique: gm1AfSY-NS2Kk8N5iMMjHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD74F85A5A8;
	Mon,  8 Jan 2024 15:23:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.167])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E6C55190;
	Mon,  8 Jan 2024 15:23:58 +0000 (UTC)
Date: Mon, 8 Jan 2024 10:25:15 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH v3] bcachefs: fix memleak in bch2_split_devs
Message-ID: <ZZwT22xOjpeDDWlr@bfoster>
References: <20240108151108.1115630-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108151108.1115630-1-glass.su@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Mon, Jan 08, 2024 at 11:11:08PM +0800, Su Yue wrote:
> The pointer dev_name can be modified by strseq(),
> then causes the memleak:
> 
> unreferenced object 0xffff9d08a2916c80 (size 32):
>   comm "mount.bcachefs", pid 9090, jiffies 4295856224 (age 17.564s)
>   hex dump (first 32 bytes):
>     2f 64 65 76 2f 6d 61 70 70 65 72 2f 74 65 73 74  /dev/mapper/test
>     2d 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00  -0..............
>   backtrace:
>     [<00000000c5d3be7d>] __kmem_cache_alloc_node+0x1f3/0x2c0
>     [<0000000052215d26>] __kmalloc_node_track_caller+0x51/0x150
>     [<0000000069fea956>] kstrdup+0x32/0x60
>     [<000000000877fcf1>] bch2_split_devs+0x3f/0x150 [bcachefs]
>     [<000000007ee93204>] bch2_mount+0xcb/0x640 [bcachefs]
>     [<000000002dd1e04b>] legacy_get_tree+0x30/0x60
>     [<000000006afc31d3>] vfs_get_tree+0x28/0xf0
>     [<000000007b0c538e>] path_mount+0x475/0xb60
>     [<0000000092de5882>] __x64_sys_mount+0x105/0x140
>     [<0000000054fc05d8>] do_syscall_64+0x42/0xf0
>     [<00000000df584910>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> 
> Fix it by copy pointer dev_name at beginning and free the copied
> pointer at end.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
> changelog:
> v3:
>     Add the missing the memleak report.
> v2:
>     Remove the unnecessary assignment.    
> ---

LGTM, thanks for the tweak:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Now that I think about it, I suspect Kent might want to move the *s
declaration to precede the while loop, but that's a separate topic. ;)

Brian

>  fs/bcachefs/util.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index c2ef7cddaa4f..f927c8a19e24 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -1186,7 +1186,9 @@ int bch2_split_devs(const char *_dev_name, darray_str *ret)
>  {
>  	darray_init(ret);
>  
> -	char *dev_name = kstrdup(_dev_name, GFP_KERNEL), *s = dev_name;
> +	char *dev_name, *s, *orig;
> +
> +	dev_name = orig = kstrdup(_dev_name, GFP_KERNEL);
>  	if (!dev_name)
>  		return -ENOMEM;
>  
> @@ -1201,10 +1203,10 @@ int bch2_split_devs(const char *_dev_name, darray_str *ret)
>  		}
>  	}
>  
> -	kfree(dev_name);
> +	kfree(orig);
>  	return 0;
>  err:
>  	bch2_darray_str_exit(ret);
> -	kfree(dev_name);
> +	kfree(orig);
>  	return -ENOMEM;
>  }
> -- 
> 2.43.0
> 

