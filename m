Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1760D1E2834
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 21:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728507613; cv=none; b=AZT/wzs4W6McPr3cZHG+yAU9Hg+6mfVjH0cdvFU2XXbm6Ny2zgM2Oa+MB2xiO3mPmvajHOa/XJ5NGci9UZrCA2SqB/yBH9l0pLx91/2KCxXojvpkzP/ah/MJc6PiLpkwPQurMISgTpSJVNCMH0/QX8jhimWNCRZQPE0aGAUK9KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728507613; c=relaxed/simple;
	bh=ZW22SvAo6uvuQySmcir9X/JWceVAdqvESpahZNGfBks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wg477/AedfE+TQHGAEgAl1BAvpDYiEBqf7LlmQHuznVu1uGr7+Q1kSP51lrZMjl3vX+UI9HnAZsFF4RRE8PN0ps9MZlImd47qpyGg8Di7f9eddIh3bd41nXbFdzuJ9miDymTWbnzAxFr1c4y4+IxNEWEdrY2mK8eWe/A/ATgUWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qRo5fUct; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qRo5fUct"
Date: Wed, 9 Oct 2024 17:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728507607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dfqtL8Rss6960Ad+UXfM4cuZsP++8TdUNl8ky01qZvg=;
	b=qRo5fUctsyncVR2blXzjEcFwtoBPtLWbzSRVGnGiYWvj8RAK3j5BiAMxn5cp225C9+CV77
	J8sOSE9r+Ld/Xn2UEtoT/16QH+62qxIFF/fKMWjCxb6m338V/acLjBUyLZ+akN42YHwayx
	c58qHCp8r1BmxtpFpZt6DnYrJkNdKDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs:
 bcachefs_metadata_version_inode_has_child_snapshots
Message-ID: <aj5qm4opbnezysvooxfbvbfw3rsur7oqxky724rsvmbqvd3z4j@45ynmdko5mwv>
References: <f18f39b9-cf61-46cf-9112-19dd59e36dfe@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f18f39b9-cf61-46cf-9112-19dd59e36dfe@stanley.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 05:53:40PM GMT, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> Commit 6375feaa7a3b ("bcachefs:
> bcachefs_metadata_version_inode_has_child_snapshots") from Sep 29,
> 2024 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	fs/bcachefs/fsck.c:1183 check_inode()
> 	warn: should this be a bitwise negate mask?
> 
> fs/bcachefs/fsck.c
>     1168 
>     1169         ret = bch2_inode_has_child_snapshots(trans, k.k->p);
>     1170         if (ret < 0)
>     1171                 goto err;
>     1172 
>     1173         if (fsck_err_on(ret != !!(u.bi_flags & BCH_INODE_has_child_snapshot),
>     1174                         trans, inode_has_child_snapshots_wrong,
>     1175                         "inode has_child_snapshots flag wrong (should be %u)\n%s",
>     1176                         ret,
>     1177                         (printbuf_reset(&buf),
>     1178                          bch2_inode_unpacked_to_text(&buf, &u),
>     1179                          buf.buf))) {
>     1180                 if (ret)
>     1181                         u.bi_flags |= BCH_INODE_has_child_snapshot;
>     1182                 else
> --> 1183                         u.bi_flags &= !BCH_INODE_has_child_snapshot;
> 
> This was intended to be u.bi_flags &= ~BCH_INODE_has_child_snapshot otherwise
> it's the same as "u.bi_flags = 0;"

Thanks, fixed
