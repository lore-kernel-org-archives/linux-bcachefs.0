Received: from delta.arachsys.com (delta.arachsys.com [91.203.57.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A95AEF4
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Dec 2023 06:16:23 -0800 (PST)
Received: from richard by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <richard@daviesmail.org>)
	id 1r9nGg-0002Y3-Tv; Sun, 03 Dec 2023 14:16:22 +0000
Date: Sun, 3 Dec 2023 14:16:22 +0000
From: Richard Davies <richard@arachsys.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove obsolete comment about zstd
Message-ID: <ZWyNtrC69FB6ndcL@delta.arachsys.com>
References: <ZWxtuIL8nbIHQ3bw@delta.arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWxtuIL8nbIHQ3bw@delta.arachsys.com>

Sorry, broken whitespace context in this version.

I've sent a v2 with git send-email, not my mail client...


Richard Davies wrote:
> Remove obsolete comment about zstd, since approach changed during
> development of commit bbc3a46065d08f9ab3412b1f26bbfa778c444833
> 
> Signed-off-by: Richard Davies <richard@arachsys.com>
> ---
>  fs/bcachefs/compress.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
> index 51af8ea..33df8cf 100644
> --- a/fs/bcachefs/compress.c
> +++ b/fs/bcachefs/compress.c
> @@ -572,10 +572,6 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
>  	ZSTD_parameters params = zstd_get_params(zstd_max_clevel(),
>  						 c->opts.encoded_extent_max);
> -	/*
> -	 * ZSTD is lying: if we allocate the size of the workspace it says it
> -	 * requires, it returns memory allocation errors
> -	 */
>  	c->zstd_workspace_size = zstd_cctx_workspace_bound(&params.cParams);
>  	struct {
> -- 
> 1.7.0.3
