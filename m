Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EB81AED38
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724935454; cv=none; b=Q7Q9dC1M+xoTbdn+BhBpt57dWW7ut2A+41oEPcSY5IZTTr9dJ2N1PGa4S9ykX36BPHHgWT+eAOTl3l2ej5x2SYwBUcz6P6z+R7buEOACxGQ50IxCVPiZUChE9gxWk7zrCY1s7PwsZVYY95JY2Wlpy+2l05yCGtGXqW5oYtabZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724935454; c=relaxed/simple;
	bh=lfLTdafcsEuGOFPjpMNV0KJ8fzSonvm3FwaiG/nOhSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dBMYAZkUKZFzKE3X3B8IYZjaQDkhWSx62IkRBhD6eCVjJZEon7PfalxJStOAxjgpaZ3OTG9mcpNp9k3gdMGQ7RXQb0nQaIHc1IRfPr1Rc9z5lZDfvY4BdWS6c7VxErtC6fPg/HSpAflELXN25AZPZAAH94UMUs6/aQ9CnXzXKUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=qMRmDIA1; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="qMRmDIA1"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7a8053dc6e3so30275385a.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 05:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1724935452; x=1725540252; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hDIUYBC2L7eWcoilq2cxGMLRTB2i97rgqz+O/DAOWVc=;
        b=qMRmDIA1veopNUgau6SyPjMAWgEqOpt6QGxnsHzLiOjLdei54dC7F8j3PEid7pcy2P
         SJ+7BUbfjhSBsmaB4QbpK5V1CL0Q3Zi8bwRmjiC0p7EN95MoIXkGL5HACiIl+qGog+Se
         46wldyKzKDj57Re+AiMV39IYAWDMkf0yTrQmPVJfklwn4fzDcnKN5M/jMZ03DrCrascR
         NnPkBnoB0C26iC+ZzOG3RXHzvpfQtKdBFT9aT8eH0pMor7eJ6+6D4b35QIa0G7N9TEF1
         wTmqLJgxwvyKxm7gfrbDxTDkNtrrjgpl1M5ZDUPO0py7YXm20uskuXOzhIeQ2yuPGAV9
         l7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724935452; x=1725540252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDIUYBC2L7eWcoilq2cxGMLRTB2i97rgqz+O/DAOWVc=;
        b=w9mvhlp+trqf4qOdSFp9AWl9VIZd+AbXnx+Q3r3DZqOUkEjzX1/F07fxoFY7r8uc/D
         Z3bvStAPrIalV1aXvWY2CoyQ+gX93XQCR+twYU8WcOMcQ8W21B7lmVuqKxaZxTmtnep7
         LWGlWw5vpytbNMRw/cmcarkoVPLteKDvolu5sjj1Hkyl/laPpL7VBrdnYW08fjtLNhp2
         53JVZhLNLl9JlUsdrHjHvz86+9F3VT4EFF6XY/iGuLq7WpzauugdGFVvG7sx7lbnCBvf
         hgD70pNmaU2Clmt+mIbj+COV4fbaxmvKULNwZE7qgL+J2Z5kidGl9C2nFnFM8zb3PoHv
         S9DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdC/7GA7yePg7kKSs2l/+hRn1Z7qSJ5Z2V4XzlUfYWtNS9K4TdVQgqYfVvdftsyFcZ7RnasWViZSavta0g0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl1SsyJxPwd3K5rqw1ogCEjpA1duBX3+TWnSgrrW58hDd4rv6r
	WrehTjJssQH//qqF0/Qs9uS6UTEdd3xUpy0Nm938rrzXYogsWHFoVH4SE7AG15M=
X-Google-Smtp-Source: AGHT+IHKcKyxZbUbgoivcvWawCijARBN/hVWbwXg6/SpcUTxZzYYgp0UF6oGOYlxdfUyl58/xqWpDg==
X-Received: by 2002:a05:620a:1a11:b0:79f:84f:809f with SMTP id af79cd13be357-7a8041c6eafmr291062585a.33.1724935451586;
        Thu, 29 Aug 2024 05:44:11 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45682c82744sm4499191cf.12.2024.08.29.05.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:44:10 -0700 (PDT)
Date: Thu, 29 Aug 2024 08:44:09 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Jan Kara <jack@suse.cz>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v4 11/16] fanotify: disable readahead if we have
 pre-content watches
Message-ID: <20240829124409.GB2995802@perftesting>
References: <cover.1723670362.git.josef@toxicpanda.com>
 <9a458c9c553c6a8d5416c91650a9b152458459d0.1723670362.git.josef@toxicpanda.com>
 <20240829104805.gu5xt2nruupzt2jm@quack3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829104805.gu5xt2nruupzt2jm@quack3>

On Thu, Aug 29, 2024 at 12:48:05PM +0200, Jan Kara wrote:
> On Wed 14-08-24 17:25:29, Josef Bacik wrote:
> > With page faults we can trigger readahead on the file, and then
> > subsequent faults can find these pages and insert them into the file
> > without emitting an fanotify event.  To avoid this case, disable
> > readahead if we have pre-content watches on the file.  This way we are
> > guaranteed to get an event for every range we attempt to access on a
> > pre-content watched file.
> > 
> > Reviewed-by: Christian Brauner <brauner@kernel.org>
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> ...
> 
> > @@ -674,6 +675,14 @@ void page_cache_sync_ra(struct readahead_control *ractl,
> >  {
> >  	bool do_forced_ra = ractl->file && (ractl->file->f_mode & FMODE_RANDOM);
> >  
> > +	/*
> > +	 * If we have pre-content watches we need to disable readahead to make
> > +	 * sure that we don't find 0 filled pages in cache that we never emitted
> > +	 * events for.
> > +	 */
> > +	if (ractl->file && fsnotify_file_has_pre_content_watches(ractl->file))
> > +		return;
> > +
> 
> There are callers which don't pass struct file to readahead (either to
> page_cache_sync_ra() or page_cache_async_ra()). Luckily these are very few
> - cramfs for a block device (we don't care) and btrfs from code paths like
> send-receive or defrag. Now if you tell me you're fine breaking these
> corner cases for btrfs, I'll take your word for it but it looks like a
> nasty trap to me. Now doing things like defrag or send-receive on offline
> files on HSM managed filesystem doesn't look like a terribly good idea
> anyway so perhaps we just want btrfs to check and refuse such things?
> 

We can't have HSM on a send subvolume because they have to be read only.  I
hadn't thought of defrag, I'll respin and add a patch to disallow defrag on a
file that has content watches.  Thanks,

Josef
