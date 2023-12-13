Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lkYAkaqk"
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [IPv6:2001:41d0:203:375::ad])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A74698
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 18:46:23 -0800 (PST)
Date: Tue, 12 Dec 2023 21:46:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702435581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4tTjib9hcujEFVbs9UAmhXbLn7lUpajBH1hkqTzs0/I=;
	b=lkYAkaqkhQQnt2XomNJotDVDLlmtP66idz86QnMviVc9NBCekO0luMeIs5dsFHxFEwBEPR
	Ea7SoSx5aXT1ZtBElagbubMzuM9UZphWvI3r5sZYTjf1h3+ls6j5WOhqRORRGLMRkozr7Q
	4JYyIEM+1fo+iidwmv5BWhAIauaILks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, Cyril Hrubis <chrubis@suse.cz>,
	Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs
Message-ID: <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-4-pvorel@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207194011.273027-4-pvorel@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 07, 2023 at 08:40:11PM +0100, Petr Vorel wrote:
> STATX_ATTR_COMPRESSED is not supported on Bcachefs, thus skip it
> (it's already skipped on tmpfs and XFS).

Hang on, bcachefs most definitely does hae compression. This would be
just because statx isn't plumbed through?

> 
> Suggested-by: Cyril Hrubis <chrubis@suse.cz>
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> New in v2
> 
>  testcases/kernel/syscalls/statx/statx04.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/testcases/kernel/syscalls/statx/statx04.c b/testcases/kernel/syscalls/statx/statx04.c
> index 58296bd24..c2ed52deb 100644
> --- a/testcases/kernel/syscalls/statx/statx04.c
> +++ b/testcases/kernel/syscalls/statx/statx04.c
> @@ -96,8 +96,9 @@ static void setup(void)
>  	for (i = 0, expected_mask = 0; i < ARRAY_SIZE(attr_list); i++)
>  		expected_mask |= attr_list[i].attr;
>  
> -	/* STATX_ATTR_COMPRESSED not supported on XFS, TMPFS */
> -	if (!strcmp(tst_device->fs_type, "xfs") || !strcmp(tst_device->fs_type, "tmpfs"))
> +	/* STATX_ATTR_COMPRESSED not supported on Bcachefs, TMPFS, XFS */
> +	if (!strcmp(tst_device->fs_type, "bcachefs") || !strcmp(tst_device->fs_type, "tmpfs") ||
> +	    !strcmp(tst_device->fs_type, "xfs"))
>  		expected_mask &= ~STATX_ATTR_COMPRESSED;
>  
>  	/* Attribute support was added to Btrfs statx() in kernel v4.13 */
> -- 
> 2.43.0
> 
