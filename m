Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AEA12A160
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Apr 2024 12:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712665201; cv=none; b=dG1g1zrNuTUSQqRIboEPQHWIyIXn1f1ni7qvcLIegmZxTgGbwfS23WuElQvKcmPAx1zLLn0VOWRJAZHj2pPlac+CwJa7pxEXzMoGR43PfgJ84aGvTx+f0hWFOxV1+uevAcHGANxtzwgb8SIVWdwbkj9ArfNVM2BMO2+Z5MGcR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712665201; c=relaxed/simple;
	bh=8txGig02p3dYQPbvCXxiUyZnAOFbmF5y2JKedJ7p9uE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SW75HN+Fi/s5YmWFkmviUt//D13gLj/aBQXOx2E8dwKNYzNfcz4xHMnyvOP+5jAsNmumb8dCrCXc2JFnVbEjwjELD/9vivzGVTyb4gBZpHPC3/mJoGjhzrbVG0niWo707MA48Z5GODxDVNB8FbiYB3DzaGY2zKZ7Id+rqauoyNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFG+P3Oj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFG+P3Oj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712665198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=38ANcwOzb+SJPN9KWn5q/+NYLzX+W+zXEwG2dC5+jdI=;
	b=ZFG+P3OjLcZZCXWSvHaawZaAzLj3c2FX5GqDRdgXMe2vsDVQhqu7cJ0SJ4iCvk3Q96XTsr
	uzfhV0zoyYQ27x6U0zJIurPTcOOdY92qR1MkySD/V8bmpg5meKQyfG/zcOg0eLHAax6+C2
	VSlZjZL9VBiI3PtUi5YYAmfp0m0wzi4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-NqVkThPwOQaX1QuLJ2zygQ-1; Tue, 09 Apr 2024 08:19:53 -0400
X-MC-Unique: NqVkThPwOQaX1QuLJ2zygQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30B0580171E;
	Tue,  9 Apr 2024 12:19:53 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3C6F47E;
	Tue,  9 Apr 2024 12:19:52 +0000 (UTC)
Date: Tue, 9 Apr 2024 08:21:51 -0400
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	Eric Van Hensbergen <eric.vanhensbergen@linux.dev>,
	v9fs@lists.linux.dev
Subject: Re: [PATCH v3 0/4] bcachefs: fiemap delalloc support and cleanup
Message-ID: <ZhUy3805KxOYbkQz@bfoster>
References: <20240408144846.1001243-1-bfoster@redhat.com>
 <bytl4gftjro45osrlzqeokzci2imtdidne5a7pkn3xtr6fdbhf@mxjefwpljsto>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bytl4gftjro45osrlzqeokzci2imtdidne5a7pkn3xtr6fdbhf@mxjefwpljsto>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Mon, Apr 08, 2024 at 11:33:05PM -0400, Kent Overstreet wrote:
> On Mon, Apr 08, 2024 at 10:48:42AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v3 of the fiemap delalloc support patches for bcachefs. The main
> > difference from v2 is that the pagecache seek calls are now using
> > nonblocking mode to avoid deadlocks between fiemap and the write path.
> > The write path locks in folio -> extent btree order while fiemap walks
> > the extent btree and scans for folios in transaction context. Therefore,
> > the latter must restart the iterating transaction in the event of folio
> > trylock failure and restart the scan from where it left off.
> > 
> > The series is pushed to CI via my test branch, as usual:
> > 
> > https://evilpiepirate.org/~testdashboard/ci?branch=bfoster
> 
> So our testing is currently busted because of a bug in 9pfs - I need you
> to rebase onto my 9p-revert branch so we can get test results we can
> look at:
> https://evilpiepirate.org/git/bcachefs.git/log/?h=9p-revert
> 

Huh, Ok. I also noticed an issue recently related to some sysfs
directory structure changes. That required me to rebase on
bcachefs-testing, though it appears that has since been resolved in
master (and 9p-revert).

I just rebased my test branch on 9p-revert and pushed. What failures are
being caused by 9p, anyways?

> Eric, is this getting fixed? If it's not, and _soon_, we need to send
> this revert to Linus - then put it through more testing, more asserts,
> whatever you need and send it again next cycle, _after_ you've figured
> out what wwent wrong.
> 
> Patch series looks good, though - if there's nothing you think needs
> special attention I'll go ahead and merge it.
> 

Not really, mainly just making sure the new locking and transaction
restart parts looked sane.

> I wonder if at some point we could clean up the indirect extent lookup,
> that's common between this code and the read paths, but that's low
> priority.
> 

I'll make a note to read more into that area. Thanks.

Brian

