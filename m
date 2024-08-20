Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DBC8F48
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Aug 2024 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724165553; cv=none; b=lRvvy9qPksKtf7CJnS5PJPbu6cBoYoKf5ms/fNHiTcNt/0TQCgGqKfELiJYrAL8xIcV7ihIs3LBnjUDSQOANwVq4uD2ZIShB7IfHKivpWInqUG2mGqY3BDY41BYvDxyUAmdjGTXR3jNr1EEZ2HpIb8qfA3AByTahLTMeeE0GL5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724165553; c=relaxed/simple;
	bh=dpYJfe7GkrHbyc+u3pH0aYQkTzHfIcM9Q6liPShmsn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5FRrH1uKJGlhtu29+wyzV8X2lkkPwa+SGVZg75Zme9XY/+5CgHcee9PEM40PcRf214Iv9BAiKAltaf/x2WH1PxS9EFAcSM+GeNsJHS/QTMnKMV7qqJHHjfTcPuEnXIlcAeBuHG9EzjmWpe1/Jabaxhy67CzYB3q1zEIntfS9K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=URFZeHGb; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="URFZeHGb"
Date: Tue, 20 Aug 2024 10:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724165548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BnzrItzJZ/B3X9CkVlTgsbRJh1ijDKfLOsfAreGi3YU=;
	b=URFZeHGbnar6KAlfqqxzEYYPcVV3keDiWAJxccFyP09/zdTLyRNso18teTU65y2m4bwmZf
	OZZNNEbasCchYRNZgOxSczO1p0hEDANr0IcwPoCUTLHVcBoOGqZf7Q/PpoXhCBpDiR7pr1
	Q1xoPIgQTREGUnUZC1ClT9vfGCZpcN8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Do not check folio_has_private()
Message-ID: <tng73zp3kb4rg5vsvnjxcanturmt5hg74wncxef2qqdqop7mkw@tbtpfsetb5ng>
References: <20240820041013.1790178-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820041013.1790178-1-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 20, 2024 at 05:10:11AM GMT, Matthew Wilcox (Oracle) wrote:
> folio_has_private() is an attractive nuisance; filesystem authors
> generally don't realise that it actually checks two flags (one of which
> is never set by bcachefs).  There's no need to check the private flag at
> all; for folios owned by bcachefs, we know that folio->private is NULL
> when the private flag is clear and non-NULL when the private flag is set.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Applied

> ---
>  fs/bcachefs/fs-io-pagecache.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/fs-io-pagecache.h b/fs/bcachefs/fs-io-pagecache.h
> index fd7d692c087e..fad911cf5068 100644
> --- a/fs/bcachefs/fs-io-pagecache.h
> +++ b/fs/bcachefs/fs-io-pagecache.h
> @@ -99,9 +99,7 @@ static inline void bch2_folio_release(struct folio *folio)
>  
>  static inline struct bch_folio *__bch2_folio(struct folio *folio)
>  {
> -	return folio_has_private(folio)
> -		? (struct bch_folio *) folio_get_private(folio)
> -		: NULL;
> +	return folio_get_private(folio);
>  }
>  
>  static inline struct bch_folio *bch2_folio(struct folio *folio)
> -- 
> 2.43.0
> 
