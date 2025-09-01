Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDC3BA4A
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Sep 2025 23:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756770946; cv=none; b=A/Q5LLPvi+NvUiGgF5bfy7Yyl4I3Cts6B1YLgnJHlBo/wsX1clI8cxowYSQIwc8CSSov+krAia4Q1kHIv3kTuGtk+GaVVuiEPcCpk++OEeBUJ7YV9Kko5R+LCL9vPbEYES9uF40hg93LmudtJ/X/b9Dsg1d3U6EhbwxN5bqerm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756770946; c=relaxed/simple;
	bh=dQXFB2HWqX5+/sKBTy4WZ1r30VTK+ewsOxCE4YkIIsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6ECTJLD8nNBNgdmUy4i7TiPgrzjM39QtM8a909S3NtE8V+eRE3kkYKqYtB556rYvM4T+1t9rHCRcxSnbXT68hPxvKeYnlbQAZnlpLJONxw4EgMl+qzXfwV67Ayl5alCjTkh/o11xsEAEUlRh/IHO1lrNWic/njrCbjyI5QcUFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EZYZdGNq; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EZYZdGNq"
Date: Mon, 1 Sep 2025 19:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756770940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nbq6xclVkvC56/NJtcJhGKs1RHD3Azm3HvdoZB0Xz3Y=;
	b=EZYZdGNqvJVmiJFABRlLLp5WcPEnlyL3LtcOZG8cnK5jMKzeixwrBc+Sq4niiWIndvorz3
	lFfGPAcPv2cp11vkafKHkmn/ZTYmd/1jP3bBTfVrAQbpZXmV6j3Ly1ELosUCLbPMxcZma+
	xNYEe8m9Xch0Ez6ND6FUtr75gF49vsE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: himikof@gmail.com
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 07/15] bcachefs: Fix missing c->usage updates from
 early recovery
Message-ID: <gg2jtjsovw24shwtwfhclrmqiq6nqy72xvg55ueftyrduesoxv@zjr6vfst6iqf>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
 <20250828-better-progress-v2-7-c088a2003940@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-better-progress-v2-7-c088a2003940@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 28, 2025 at 05:16:09PM +0300, Nikita Ofitserov via B4 Relay wrote:
> From: Nikita Ofitserov <himikof@gmail.com>
> 
> Make do_bch2_trans_commit_to_journal_replay apply global FS usage
> updates stored in trans->fs_usage_delta, too.
> 
> Signed-off-by: Nikita Ofitserov <himikof@gmail.com>

kicked this patch out for now - run a lockdep test

> ---
>  fs/bcachefs/btree_trans_commit.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
> index 5fa7f2f9f1e9d0ddd1d4675774321b519313f477..e3f069ad4002e2b007600fb41cd220d13386d37f 100644
> --- a/fs/bcachefs/btree_trans_commit.c
> +++ b/fs/bcachefs/btree_trans_commit.c
> @@ -970,6 +970,7 @@ do_bch2_trans_commit_to_journal_replay(struct btree_trans *trans,
>  
>  	struct bkey_i *accounting;
>  retry:
> +	memset(&trans->fs_usage_delta, 0, sizeof(trans->fs_usage_delta));
>  	percpu_down_read(&c->mark_lock);
>  	for (accounting = btree_trans_subbuf_base(trans, &trans->accounting);
>  	     accounting != btree_trans_subbuf_top(trans, &trans->accounting);
> @@ -981,6 +982,8 @@ do_bch2_trans_commit_to_journal_replay(struct btree_trans *trans,
>  		if (ret)
>  			goto revert_fs_usage;
>  	}
> +	/* Only fatal errors are possible later, so no need to revert this */
> +	bch2_trans_account_disk_usage_change(trans);
>  	percpu_up_read(&c->mark_lock);
>  
>  	trans_for_each_update(trans, i) {
> 
> -- 
> 2.50.1
> 
> 
