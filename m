Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFAD3F9C5
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Jun 2024 19:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718567363; cv=none; b=S1QrYU+beaIFmh9P+yPG2KA8xSNQly8/MNG2AeEkgpvW/ovLrICs5hgGdUUJ8TSZHc+eEiBAlih9NnYVPEz4K73HZU1zaYBpb6VrLpSwqTRQL+4DOMpzg+UqC1+josRVhIdKqlDT7CH5TUuezeF/VCoFPto2toxv9zYPCJTw6N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718567363; c=relaxed/simple;
	bh=CvoYIJQh+AIbth3lf0oQQW+Pff2p1ZzgxVFl3dIOiBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSP/I2JxQDJNJWaXC0Lo/9i/Z3LrCPtDYr+7J8o3skWezNr78iXxQ6DgpazGkt8aE/ytwhjCI+x9W/OhQDjMpvOjKoH6IAmMyack6Vokr8DWvEDpxVmNMPN0kvwXenZGPxYs2KjkuEPT8l5hMv+MrC5lUmpFno1zLHyy4LpwP3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WxXhsXsc; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WxXhsXsc"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718567357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih3rAhILGUubprLwXSQjzCJ9ZRBbgElSLd8sEJvZWEg=;
	b=WxXhsXscUxpCOnfmQoOJ9nI6TrcF6bL9kK/D9dLOBLh9WS5YibBR5zqhPS3VJsm7P8kGnv
	vMQ+CwH7Kj7fo0rsh02Ei8v3X4ZHuTozLWwS4n81fam1Rcvom3e35BxeUx9tFpr9jAOp6d
	08w6xFX2DvaEm/gXEXYLXw8rbxYhpgM=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: christian@brauner.io
Date: Sun, 16 Jun 2024 15:49:14 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	christian@brauner.io
Subject: Re: [PATCH] bcachefs: support idmap mounts
Message-ID: <fhgec4fmisjfp3sirxlkwl5napoitzxkjdhvvmebmrvlalcqba@mmh2m45hpojb>
References: <20240615102038.3110867-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240615102038.3110867-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 15, 2024 at 06:20:38PM +0800, Hongbo Li wrote:
> We enable idmapped mounts for bcachefs. Here, we just pass down
> the user_namespace argument from the VFS methods to the relevant
> helpers.
> 
> The idmap test in bcachefs is as following:
> 
> ```
> 1. losetup /dev/loop1 bcachefs.img
> 2. ./bcachefs format /dev/loop1
> 3. mount -t bcachefs /dev/loop1 /mnt/bcachefs/
> 4. ./mount-idmapped --map-mount b:0:1000:1 /mnt/bcachefs /mnt/idmapped1/
> 
> ll /mnt/bcachefs
> total 2
> drwx------. 2 root root    0 Jun 14 14:10 lost+found
> -rw-r--r--. 1 root root 1945 Jun 14 14:12 profile
> 
> ll /mnt/idmapped1/
> 
> total 2
> drwx------. 2 1000 1000    0 Jun 14 14:10 lost+found
> -rw-r--r--. 1 1000 1000 1945 Jun 14 14:12 profile
> ```
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

new test failure:

https://evilpiepirate.org/~testdashboard/c/a7d9a88f5cb151b7b9e513f5d40a949a3eda4662/xfstests.generic.689/log.br
