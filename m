Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EB6320F
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 10:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684320; cv=none; b=JslggJ6MM+Yzfwxg0GFSOFJHG5C3MBpVHab59WDFtF5ZmLJ2RaGCr0Cir7d4RQXIbHpoLZN4GV/xajkCelG0otzOwVOgknWOYGESRtUPPK100BE1KChCpZCG0R+cnHHdK8j1vpQ4OU6/Syyo2YBauMfZbHEvC0uJcjJtScLSjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684320; c=relaxed/simple;
	bh=h3PbAwGakb/t4M79+XxG1vG64LYWcADDoDkEs/KF63o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHbbOSEgHz/VRlp3Kz1YvlhBZ2a36YBMzSqcYhDzJH4L+xgTXNk4aiNYlud4w8ZsACA+y9yCDmhQJu6OvR+ggbICpQp86IKsG4H4bI7veqXdTZf1w5yKF7voOMH2yVyzTKLYJKOadAQkdYuUivu5RUitUVlOZa+H+pijStyN9Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W7vtoXl5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7vtoXl5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715684318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uCRsV/xUWg0w7888xFJ6TfC20xrb8PlJnkiONY3cJgg=;
	b=W7vtoXl5VWWivb7IBMUZYCTAa9LovTsk8r4PRvyu7HX8+th0Szxc8WELSQS7DPLyxrXNVI
	+HG/4zuWeGSaQHiVjfS5Sbr+UtlGgcIW5ZEIswWTaKdU9ncujrxe2JZPe5EEMkd49GKmq+
	ppRbTv/+VpEYjdQ6FUwLiH9UswIV0dw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-139-QFSnbrLWMZCMcsYa_tGPlA-1; Tue,
 14 May 2024 06:58:34 -0400
X-MC-Unique: QFSnbrLWMZCMcsYa_tGPlA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F8DF3C000A5;
	Tue, 14 May 2024 10:58:34 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79D372818;
	Tue, 14 May 2024 10:58:34 +0000 (UTC)
Date: Tue, 14 May 2024 06:58:53 -0400
From: Brian Foster <bfoster@redhat.com>
To: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: support REMAP_FILE_DEDUP in
 bch2_remap_file_range
Message-ID: <ZkND7a95h3pzCrOq@bfoster>
References: <yuG-zWAd7xX9SkysCfG2ELC8drJi3bxsagrf03hf2Aeah__0W1exPDJabqC23NyOzt5BXmYEF95045yO2SfCbZMgGkYqbycmlUIBZqk2vyE=@riley.engineer>
 <ZkIIxvdRKrgCdoC8@bfoster>
 <45_rwv0SgX9alyYyitLlz7CwOVmZZejtbJRAzqVyVnXjhVDxhPp273Pwd1Lpp3n1T-HsBT9EB1ZeXyoinExuozvfk4LNfTFHxa54NBJojOo=@riley.engineer>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45_rwv0SgX9alyYyitLlz7CwOVmZZejtbJRAzqVyVnXjhVDxhPp273Pwd1Lpp3n1T-HsBT9EB1ZeXyoinExuozvfk4LNfTFHxa54NBJojOo=@riley.engineer>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Mon, May 13, 2024 at 11:42:42PM +0000, Reed Riley wrote:
> On Monday, May 13th, 2024 at 5:34 AM, Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Sat, May 11, 2024 at 12:20:12AM +0000, Reed Riley wrote:
> > 
> > > By removing the early-exit when REMAP_FILE_DEDUP is set, we should be
> > > able to support the fideduperange ioctl, albeit less efficiently than if
> > > we handled some of the extent locking and comparison logic inside
> > > bcachefs. Extent comparison logic already exists inside of
> > > `__generic_remap_file_range_prep`.
> > > 
> > > Signed-off-by: Reed Riley reed@riley.engineer
> > > ---
> > 
> > 
> > Seems reasonable:
> > 
> > Reviewed-by: Brian Foster bfoster@redhat.com
> > 
> > 
> > Have you run any tests just to make sure there are no surprises? If not,
> > it looks like xfs_io has a 'dedupe' command that would make it easy to
> > run a quick test or two from the command line. fstests has a bunch of
> > tests in the dedupe group (which I presume this patch should now allow
> > to run on bcachefs) as well.
> 
> I worked with Kent to run his CI tests against the patch (https://evilpiepirate.org/~testdashboard/ci?branch=bcachefs-fideduperange&commit=1945149c8d7549b924cd88f57f0cd938b3bb7125) and also used xfs_io to do some basic sanity checks.
> 

Ah, great. I threw this up on my test branch yesterday as well just to
see what happens. It looks like it enabled more tests (likely the
fstests that _require_dedupe), which is good to see.

> Specifically, I sanity checked that:
>  1. fideduperange doesn’t dedupe if file content doesn’t match,
>  2. fideduperange does dedupe stuff when they do (according to filefrag -v reporting shared extents), and
>  3. That neither of the above operations changed file checksums.
> 

Makes sense. Thanks!

Brian

> I’d be happy to run more tests if anyone can suggest them?
> 
> > 
> > Brian
> > 
> > > fs/bcachefs/fs-io.c | 3 ---
> > > 1 file changed, 3 deletions(-)
> > > 
> > > diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
> > > index 20b40477425f..4f513f22a66a 100644
> > > --- a/fs/bcachefs/fs-io.c
> > > +++ b/fs/bcachefs/fs-io.c
> > > @@ -857,9 +857,6 @@ loff_t bch2_remap_file_range(struct file *file_src, loff_t pos_src,
> > > if (remap_flags & ~(REMAP_FILE_DEDUP|REMAP_FILE_ADVISORY))
> > > return -EINVAL;
> > > 
> > > - if (remap_flags & REMAP_FILE_DEDUP)
> > > - return -EOPNOTSUPP;
> > > -
> > > if ((pos_src & (block_bytes(c) - 1)) ||
> > > (pos_dst & (block_bytes(c) - 1)))
> > > return -EINVAL;
> > > --
> > > 2.44.0
> 

