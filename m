Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEB016F0EA;
	Fri, 14 Jun 2024 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382183; cv=none; b=ZkFEZjepLIWZgo2TfJjwrjLbXqpit1RvdTO1qiblumR0AQxKcU3EUmSywYwEUQC7QzpbNsfTElBnhuMyTQ33rrpTgPkfiBDzHhuPBQQeVLCbEC2sqDojkxI4UbPi+ef3CosqLJMuMchnF9W9JOR10pXeoJ/lJl2tB23EOL6oIjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382183; c=relaxed/simple;
	bh=9xVj2HYRLM1Bn9KcJv/C/fPJ9SREflQWxolwgh3d9DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPWSF3loIIPvJuuBv0WJAZ6ABcHpBoOSf4KyvnagIioR9JGn93Ewagux4u3z+MBx51os3R5Ardp+KWb3SMzO5VuEiJsC4CH5xYGltLrAYwbnq/nxTPKYHIJ//PUZlkrBxkGNYQjcqBpEOkXqlV48BHRFPzW7shsoWxO18a3KC8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=VwKhLnNI; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="VwKhLnNI"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4W14M55CTXz9syZ;
	Fri, 14 Jun 2024 18:22:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1718382177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4kmNllycobnJxPSc+JrUUAyzHlN3JuewkPkueoOCrQ=;
	b=VwKhLnNIcoz0lhgP5s9Dt41KUzMS3nCkiikd6WnFm31u+xsqgcNudNVsj4mLs2hL3Qtu7+
	LVrxuT2v/f+Fweo6AMqI2r76xJTXs4pYg5LaRPAsX0F54HbV6lLv1qOMeGu3IJre5Mc5c/
	bFLE0Ty0nZ+f3nFBVuUoVYiynvcy4818IZxxcSGPlx75ElOEHEBuh6zdXho+jz+m4j1wDZ
	YQ8Y4C7pnhjGka0ckIrJV8Z4UzHYzwKVvLhOVd4M7DOAhYm0HH+pN7Yd/sTsfj9cd16tlI
	Afi89iaRp/qS9FgYI7669RBHxgoGBnvBio0/youFmba1UXsETdqfR5kDaHRiaw==
Date: Fri, 14 Jun 2024 16:22:54 +0000
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 1/2] bcachefs: use FGP_WRITEBEGIN instead of combining
 individual flags
Message-ID: <20240614162254.wwuoftv6cbm5x5t7@quentin>
References: <20240614105031.57032-1-kernel@pankajraghav.com>
 <20240614105031.57032-2-kernel@pankajraghav.com>
 <ZmxVZiveDdzyByTQ@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmxVZiveDdzyByTQ@casper.infradead.org>

On Fri, Jun 14, 2024 at 03:36:22PM +0100, Matthew Wilcox wrote:
> On Fri, Jun 14, 2024 at 10:50:30AM +0000, Pankaj Raghav (Samsung) wrote:
> >  	ret = bch2_filemap_get_contig_folios_d(mapping, pos, end,
> > -				   FGP_LOCK|FGP_WRITE|FGP_STABLE|FGP_CREAT,
> > -				   mapping_gfp_mask(mapping),
> > -				   &fs);
> > +					       FGP_WRITEBEGIN,
> > +					       mapping_gfp_mask(mapping), &fs);
> 
> Don't change the indentation here.  In the next patch it makes the
> lines too long.

I used clangd to do the formatting. I will probably stick without
changing the format in this patch

Thanks.
> 
> In general, don't change the indentation.  It's been one of the biggest
> pains of the folio conversion.  "Oh, you changed the name of this
> function and now the arguments don't line up".  Don't line up the
> arguments with the opening paren.
