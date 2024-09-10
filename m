Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DC923774
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Sep 2024 21:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726003743; cv=none; b=fMCp/MbACSAQ/gzBNt7BLKOXi0/kraZ7OGamyzjYmMlKr4v4FeiPV+mlDuX9hOr91AJ6tX5rfzlAYjtwL9GqavMNPo8cvwpUmVUGIr8GDEwYl139NixdNp3orVxSQgUma2eH3RBGYvKFbKwRKHboIS0lkYsmBdwJxgsNiaZqU9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726003743; c=relaxed/simple;
	bh=JB8QPYV6wZvd+8554qqYMyfYwk/jZ3Z7SuNwc5aQ1ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWFMmMa8YJXXqLEIXu3wgDlPZUMjVha+Y+nQ8K6i4giXBmZFw1Oq9XScAc3lQ+OO6GhcxH2gRbz8stMDna91uB/v4xEq2X0pGkGJUp87NdKP8MU7T4neD7SgSKL1R/1PQrXrr0n5EGm2THlNIy6+eQ7ghMXslVwBptdjBN1C7mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ev1clNQT; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ev1clNQT"
Date: Tue, 10 Sep 2024 17:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726003738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hQdZ/Xk3IZq0P/QkpkVbrTV28jX3yXisSZN66Q35tXE=;
	b=ev1clNQTafKiThScdYgVP+exBlsxPUvoo+prJZsHvrEkVD6+JVBTM+EeH5gHJcByAN88X4
	gmCvaTzjJ4C4WtWZJCHWAa/FlS67eOuFORW0XZ5wfZ4fUh2hqmxPUbnz8qP9JoTK6gIfbW
	o2FDmCJ+yyV2LLyEuL2ryzE1QETJX/M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Diogo Jahchan Koike <djahchankoike@gmail.com>
Cc: syzbot+1cecc37d87c4286e5543@syzkaller.appspotmail.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: return err ptr instead of null in read sb clean
Message-ID: <hz3mj5qtutvjddnfhhbeu74hoxu67qzzgwmpxzcldbslsj7fed@53sfkbbxpriq>
References: <20240910211912.96356-1-djahchankoike@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910211912.96356-1-djahchankoike@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 10, 2024 at 06:18:34PM GMT, Diogo Jahchan Koike wrote:
> syzbot reported a null-ptr-deref in bch2_fs_start. [0]
> 
> When a sb is marked clear but doesn't have a clean section
> bch2_read_superblock_clean returns NULL which PTR_ERR_OR_ZERO
> lets through, eventually leading to a null ptr dereference down
> the line. Adjust read sb clean to return an ERR_PTR indicating the
> invalid clean section.
> 
> [0] https://syzkaller.appspot.com/bug?extid=1cecc37d87c4286e5543
> 
> Reported-by: syzbot+1cecc37d87c4286e5543@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1cecc37d87c4286e5543
> Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>

Thanks, applied
