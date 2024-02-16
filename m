Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0943647
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 00:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708042514; cv=none; b=BiwqdSSvUDy1qWTTor1dl6jMjPQNUA4yAflrQVeFLIlrOs/Ju49eGCfqwpnoB6HfEAbPlNj2eok2ql4uHrFE2KW77phwkvbVGU3wEz/YZeTcIfjMhhSAs4D0iORudgl0/T6wPfvOfjmXBmVyDnrvstIHUzQuVo+MkWi4fQsVxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708042514; c=relaxed/simple;
	bh=W7fi5FC0WfcMj8qOW2SUL1Ho1zTtr9P6BJTduGAa1UA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rj1tMLOcGLM7eVM1thJbLGfqdBkqyr8FnQe2u5+EB1z5KS3Pb0JODggych65tbIxrZjtnU8RKHchqQk+iSEnfRpBTFMpdWgjhstwJUHKWwZ1+rRDNEjjsPn1pJTsfu47qRqpe91eIFyibBdIKRANAgQXFPMiHJ6xWOe8hgJ4odA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=siFc+g9t; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="siFc+g9t"
Date: Thu, 15 Feb 2024 19:14:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708042508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6AexVGYmbWRHyL7xsQpEytyeTZQalpQBNVnD/QF7M+U=;
	b=siFc+g9twABX9An7q16ujvMuPP0rxokm6yMKVgymMSXdR2gNZXcLdoQcLCr/MEL40i60+/
	9PkXGpg3SbdQuWBWkg5ssN3Tg+81cPuQjcXV8z508+XIVWkT2V+IgTiWDFfi1+QXtxnVp5
	QBxq+TGv2IDnyAjjhGt5ubsdFoZJ+SQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Su Yue <l@damenly.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: fix iov_iter count underflow on sub-block
 dio read
Message-ID: <qsiwkhpljiicwhj2idhynueeoqwphyu2b2ttlq7hyh6mdwkdcm@crxfjvmxdmmd>
References: <20240215171605.162107-1-bfoster@redhat.com>
 <34ttb7ge.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34ttb7ge.fsf@damenly.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 16, 2024 at 07:58:34AM +0800, Su Yue wrote:
> 
> On Thu 15 Feb 2024 at 12:16, Brian Foster <bfoster@redhat.com> wrote:
> 
> > bch2_direct_IO_read() checks the request offset and size for sector
> > alignment and then falls through to a couple calculations to shrink
> > the size of the request based on the inode size. The problem is that
> > these checks round up to the fs block size, which runs the risk of
> > underflowing iter->count if the block size happens to be large
> > enough. This is triggered by fstest generic/361 with a 4k block
> > size, which subsequently leads to a crash. To avoid this crash,
> > check that the shorten length doesn't exceed the overall length of
> > the iter.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> LGTM.
> Reviewed-by: Su Yue <glass.su@suse.com>
> 
> Since imap.google.com is blocked by GFW, I use my personal email address
> in mu4e + emacs hosting on remote machine daily.
> I am no clear what is required(gpg?) if I use my personal address to
> give a review by in my employer address.

Most people don't gpg sign their regular emails, just pull requests, so
I'm not going to sweat it :)
