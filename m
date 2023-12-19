Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE8618E34
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 13:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USVF52fY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702990860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tUwhvUw0qnCfptI8ooiqOHA8nJSPNHswpyInsia33wI=;
	b=USVF52fY2pUdfBAYqgN/qA59LNTPmlpUL7/HTym0dhV8MnwNVMVw52+Wo0Z8ctpi9cuU0b
	RLcwInp5jEctubC+6p3adg4EjrCYUrNmm71HCmRb60l66Uu2qNwzQTwsPuz2lud97Q9uzX
	q9SME5XQfota+yT2SLehH3X3PB+G20g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226--4q0TNHhNnKOXulPaFPpdA-1; Tue, 19 Dec 2023 08:00:58 -0500
X-MC-Unique: -4q0TNHhNnKOXulPaFPpdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F17D101A555;
	Tue, 19 Dec 2023 13:00:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.199])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B6E240C6EB9;
	Tue, 19 Dec 2023 13:00:58 +0000 (UTC)
Date: Tue, 19 Dec 2023 08:01:59 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kevin Hao <haokexin@gmail.com>
Cc: linux-bcachefs@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH] bcachefs: Remove unnecessary kthread_should_stop()
Message-ID: <ZYGUR4qD2mzr1X4F@bfoster>
References: <20231216015140.2085664-1-haokexin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231216015140.2085664-1-haokexin@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Sat, Dec 16, 2023 at 09:51:40AM +0800, Kevin Hao wrote:
> In the macro kthread_wait_freezable(), there is already a check for
> kthread_should_stop(), so there is no need to pass kthread_should_stop()
> as a parameter to kthread_wait_freezable().
> 
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---

Looks right to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/bcachefs/movinggc.c  | 3 +--
>  fs/bcachefs/rebalance.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
> index fd239a261aca..bc1ec877a66b 100644
> --- a/fs/bcachefs/movinggc.c
> +++ b/fs/bcachefs/movinggc.c
> @@ -345,8 +345,7 @@ static int bch2_copygc_thread(void *arg)
>  
>  		if (!c->copy_gc_enabled) {
>  			move_buckets_wait(&ctxt, buckets, true);
> -			kthread_wait_freezable(c->copy_gc_enabled ||
> -					       kthread_should_stop());
> +			kthread_wait_freezable(c->copy_gc_enabled);
>  		}
>  
>  		if (unlikely(freezing(current))) {
> diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
> index ee452aa51a26..b83dd613e247 100644
> --- a/fs/bcachefs/rebalance.c
> +++ b/fs/bcachefs/rebalance.c
> @@ -334,8 +334,7 @@ static int do_rebalance(struct moving_context *ctxt)
>  	while (!bch2_move_ratelimit(ctxt)) {
>  		if (!r->enabled) {
>  			bch2_moving_ctxt_flush_all(ctxt);
> -			kthread_wait_freezable(r->enabled ||
> -					       kthread_should_stop());
> +			kthread_wait_freezable(r->enabled);
>  		}
>  
>  		if (kthread_should_stop())
> -- 
> 2.39.2
> 

