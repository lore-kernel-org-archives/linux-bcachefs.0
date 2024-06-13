Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E70814C596
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Jun 2024 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718304063; cv=none; b=EfeFb299H5PwdVCg+pEKNq8XjzqWA43EK6rMQ5YkFeCbQcPRwZkdggotlBPewVYRVyo/2lN4w9RIsr4SaWycncYBzJMW/JdZtmUPdN1JTDP03NgOFOTbEmlBk5G72JXNZs3hhVj8IwOf7b4/Yks9ySLzHYB5vQx2d6LtwQSpP3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718304063; c=relaxed/simple;
	bh=0drzEZNfMpyQdo4um8DsbvK6FJhKNWsZyH1L3gB17HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqQZqZr+15FyzZACLp+ttvUxllCAZeyJ1xTkqst/JYmCEn1sHnXagWc0A1HENwuSgWdCeyiOEEBBzT29yOIzRiPhIiGHIBc4alE0EB+BwewjsCAX4UzuCrleOaoYFPJFdJYBss1c7CG9BjlGzi4APl35yaOHp5Tt93l8krUoG+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r/64EXve; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r/64EXve"
X-Envelope-To: ariel.miculas@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718304058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CbLeA3rhxrsb/kZJDdJ3SKI0ZGUF7tygNv6zjqd79Nc=;
	b=r/64EXve3DZI37Ox+Qs2Bv3QtpoBYMtr2m9nazglQz1EPGEEOo5L+pAB9j5FObYWPUOang
	E7w/WzJq8D9nk0dpNNX8APIFFvKX7j39RS6FL6ZlY5ShAOhylP5fifQUhO7gu69gOcCPKf
	v0Knv1HJMZEQhUhABI1qV02wadVkWJc=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Thu, 13 Jun 2024 14:40:55 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Ariel Miculas <ariel.miculas@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/4] bcachefs: allow initializing a bcachefs filesystem
 from a source directory
Message-ID: <4ewvaxk6vfogqymbcqiagt6mzcqgq4vbnyjhbfcuoord5ln7q5@skpnxdtsksct>
References: <20240604074325.798349-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604074325.798349-1-ariel.miculas@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 04, 2024 at 10:43:22AM +0300, Ariel Miculas wrote:
> Add a new source command line argument which specifies the directory
> tree that will be copied onto the newly formatted bcachefs filesystem.
> 
> This commit also fixes an issue in copy_link where uninitialized data is
> copied into the symlink because of a round_up of the buffer size.
> 
> Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
> ---
> +enum COPY_TYPE {
> +	COPY,
> +	MIGRATE
> +};

enums need to be namespaced in C, do

enum bch_migrate_type {
	BCH_MIGRATE_copy,
	BCH_MIGRATE_migrate,
};

this follows existing bcachefs conventions; if we do an enum-to-str
table later we don't have to deal with renaming the enum or silly
uppercased names in to_text() functions

Other than that looks good - if you can do that as a fixup patch I'll go
ahead and apply the series.

Thanks!
