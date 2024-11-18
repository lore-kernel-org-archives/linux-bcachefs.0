Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FCC4A35;
	Mon, 18 Nov 2024 01:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731891643; cv=none; b=ixF+woLHXKHTyZ94Bg7J8ZefVT5+E3ba9MUriJ4tVGkHYYyJFtsy+n0e4i4m9LZeCZJgyIKES221ILd8tRjKV5+eea6kMeZmlDGkFLG8qvS9gnOoAVJ3l3wSPVuEmoh1l+DxvqqIdBjYP/vdGEzTRgZkhmelcQHxd5ef6zzShUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731891643; c=relaxed/simple;
	bh=Cd87xfvt+xDaiNXRe88pN17P05Pejn7OP7xc2z+Lb10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgdOOCCprEF3PFerpr7h7+A1aJSNYcYARAElLWM4MrD70hCiizdkWuZUr8nXJhopFUH3Rmma6ETAT1qstT+ySreo6fko6swXa3A/Y7D5zJLuMnB2byZ/YauBKNYGsuoGQmeSzbeyeuhpdqLpbfl16c76caqxe+3BLtY1HVp2pek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/sbYKbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/sbYKbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DE9C4CECD;
	Mon, 18 Nov 2024 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731891642;
	bh=Cd87xfvt+xDaiNXRe88pN17P05Pejn7OP7xc2z+Lb10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a/sbYKbBhHo+HBD5o/qZn0iUltf2E+Bo4qRp4unvn0CiZvcrUjWUUwT+6l/iRdy0G
	 3nt9ine8ancIP0x0T2+yYgwARrWfuJUpx1k1wYXBzABDkkGOc0g16L7RCZTfl5odov
	 KgbnGMwhiiJjMN1LZ55WIVR1BqBc6pPFHiyo62cyaUe43mEFHzBHmgl795QPB5vQ/u
	 D4tVAxELG1BCzmX3ytJplowRiSyOU/QnL2ORMFbhH25CwRi7tOfcj/Dqk5BRYdaC1N
	 7FNtk7V5bjSrZEqT24WfN8fv/ULAdFEfYkc4khH9GJExvpkmwv1nmjiK6Ga2ZerqIz
	 npQyqYd+jtYFw==
Date: Sun, 17 Nov 2024 18:00:40 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Piotr Zalewski <pZ010001011111@proton.me>, kent.overstreet@linux.dev
Cc: ndesaulniers@google.com, morbo@google.com, justinstitt@google.com,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, skhan@linuxfoundation.org
Subject: Re: [PATCH] bcachefs: initialize local variables in
 bch2_evacuate_bucket
Message-ID: <20241118010040.GB3588455@thelio-3990X>
References: <20241117234334.722730-4-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241117234334.722730-4-pZ010001011111@proton.me>

On Sun, Nov 17, 2024 at 11:48:23PM +0000, Piotr Zalewski wrote:
> Compiling bcachefs sources with LLVM triggers uninitialized variables
> warnings.
> 
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
> ---
>  fs/bcachefs/move.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
> index 8c032ef3a567..94cac498d372 100644
> --- a/fs/bcachefs/move.c
> +++ b/fs/bcachefs/move.c
> @@ -674,8 +674,8 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
>  	struct bkey_buf sk;
>  	struct bkey_s_c k;
>  	struct data_update_opts data_opts;
> -	unsigned dirty_sectors, bucket_size;
> -	u64 fragmentation;
> +	unsigned dirty_sectors = 0, bucket_size = 0;
> +	u64 fragmentation = 0;

Shouldn't these just be removed altogether...? They are only used in a
trace event and now only zero.

$ rg 'dirty_sectors|bucket_size|fragmentation' fs/bcachefs/move.c
677:    unsigned dirty_sectors, bucket_size;
678:    u64 fragmentation;
814:    trace_evacuate_bucket(c, &bucket, dirty_sectors, bucket_size, fragmentation, ret);

Something like below seems to compile.

Cheers,
Nathan

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 88ab9d7e1a1b..412ef9897361 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -674,8 +674,6 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	struct bkey_buf sk;
 	struct bkey_s_c k;
 	struct data_update_opts data_opts;
-	unsigned dirty_sectors, bucket_size;
-	u64 fragmentation;
 	int ret = 0;
 
 	struct bch_dev *ca = bch2_dev_tryget(c, bucket.inode);
@@ -811,7 +809,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 		bch2_btree_iter_advance(&bp_iter);
 	}
 
-	trace_evacuate_bucket(c, &bucket, dirty_sectors, bucket_size, fragmentation, ret);
+	trace_evacuate_bucket(c, &bucket, ret);
 err:
 	bch2_trans_iter_exit(trans, &bp_iter);
 	bch2_dev_put(ca);
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 5597b9d6297f..f67914367acf 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -846,18 +846,13 @@ TRACE_EVENT(move_data,
 );
 
 TRACE_EVENT(evacuate_bucket,
-	TP_PROTO(struct bch_fs *c, struct bpos *bucket,
-		 unsigned sectors, unsigned bucket_size,
-		 u64 fragmentation, int ret),
-	TP_ARGS(c, bucket, sectors, bucket_size, fragmentation, ret),
+	TP_PROTO(struct bch_fs *c, struct bpos *bucket, int ret),
+	TP_ARGS(c, bucket, ret),
 
 	TP_STRUCT__entry(
 		__field(dev_t,		dev		)
 		__field(u64,		member		)
 		__field(u64,		bucket		)
-		__field(u32,		sectors		)
-		__field(u32,		bucket_size	)
-		__field(u64,		fragmentation	)
 		__field(int,		ret		)
 	),
 
@@ -865,17 +860,12 @@ TRACE_EVENT(evacuate_bucket,
 		__entry->dev			= c->dev;
 		__entry->member			= bucket->inode;
 		__entry->bucket			= bucket->offset;
-		__entry->sectors		= sectors;
-		__entry->bucket_size		= bucket_size;
-		__entry->fragmentation		= fragmentation;
 		__entry->ret			= ret;
 	),
 
-	TP_printk("%d,%d %llu:%llu sectors %u/%u fragmentation %llu ret %i",
+	TP_printk("%d,%d %llu:%llu ret %i",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->member, __entry->bucket,
-		  __entry->sectors, __entry->bucket_size,
-		  __entry->fragmentation, __entry->ret)
+		  __entry->member, __entry->bucket, __entry->ret)
 );
 
 TRACE_EVENT(copygc,
