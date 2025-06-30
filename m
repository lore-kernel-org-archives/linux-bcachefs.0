Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EE222836C
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 21:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751318951; cv=none; b=Ww/gOfo9wDqSEInDtV+v9tRTYvvs1YVkF8SvrinFOLmveelYwV6vHHygHcKnztIlqiiDIjVrNCjHhyNOWst2AdYUj4pFm+P2cMEK+ei4/i4uf/kh4ujpNApTAFfZwV8MdZVK0/s/3kdheAcG/sW8Lg7UxuXzIw7SzTwfIuDbqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751318951; c=relaxed/simple;
	bh=d6nbQQLUnQCZs+0NfGRAvQiWPwJa7lrnlBERPkajEaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoPgv2+vWqIUxtdir89IlUe1VXlf5pbBLgrxhOjJJV8iOkVnVF7zbIXbjESxbuJ8gDf9uknG25aMBgpI+L+kZzJfVV1HybXWUG0S9XYgrxXN5KRzdec9y0NX1RA5RW7GFsP2QLk++ffdqI7Un3lNuFli5bSnnaoiFukWOBti9I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ApFj8SJd; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ApFj8SJd"
Date: Mon, 30 Jun 2025 17:29:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751318947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BEtZwekMiQTS4WiAwNiZ1d60U0WnkohKbKseJdq5+FI=;
	b=ApFj8SJdZXe04GcEvACAq1dRYMlf9J7IUTophrmD7qBW7tQi4CrP1zYnr0rFuMfO4Re6ad
	n8axjmgsJhD2RHgV9N3wDG8F13ql0Aadl37fCQLQc1Fgrvt1m+I2xKTvrx2jUx/b6AFWVz
	tC8Tr4qTNX+Su8dKDYLRu9Yb4xcHh3g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+cc7567f096079cb4146f@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix incorrect transaction restart handling
Message-ID: <vjlptffcawetdfjtcnjpengsa6yfk7at6fseg4by2iajlzndd2@jdehkyczxdty>
References: <20250630123633.30702-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630123633.30702-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 30, 2025 at 08:36:33PM +0800, Alan Huang wrote:
> Reported-by: syzbot+cc7567f096079cb4146f@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied, thanks

> ---
>  fs/bcachefs/fsck.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
> index 4ceb28a6b9b1..453a5c3184ea 100644
> --- a/fs/bcachefs/fsck.c
> +++ b/fs/bcachefs/fsck.c
> @@ -2811,7 +2811,7 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
>  				ret = remove_backpointer(trans, &inode);
>  				bch_err_msg(c, ret, "removing dirent");
>  				if (ret)
> -					break;
> +					goto out;
>  
>  				ret = reattach_inode(trans, &inode);
>  				bch_err_msg(c, ret, "reattaching inode %llu", inode.bi_inum);
> -- 
> 2.48.1
> 
