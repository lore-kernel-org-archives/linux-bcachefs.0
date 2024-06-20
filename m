Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133EB1AB91C
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 12:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718887970; cv=none; b=e5ybH+hrPQyUZpxO47qtj4twDM7ezKZUrxIKPvNJyDlzR62yhcDZDzYf++bSluxl1cDexqWFQ+RPm7HBE7LXZuArxms+ZqFDHkdfftA6ARt1pesivB+agu1IQCAdc4bXO+hQht0B7d8cpSVAGF2fZvR3ZlNW8V20lmrBKmFl9gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718887970; c=relaxed/simple;
	bh=dv1i2TQU0nKuB2IieKXcn7PpqUJZiWJE8IJP51nJzXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6S/CssnUAADD4tsM1OSw7FPu/1WZCi2TS3+KtNFcp7Hfq4QY0vnQYBBXceE59EiH/ZmBOJEn5b/njyKtlUSSJLcwk2SGfsig4cikxw0ksU1FnCnJQ9jqYf6MM2jzP5bMLxgwhMGkhJj4F1jEyUwyG8XC8QV8XwxZbZnRqHnJCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jKhYcvqi; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jKhYcvqi"
X-Envelope-To: ddiss@suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718887965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeqW5qGLeZSHZqZPPWUDA3lMNb0Krxbb27wVAhOXPcE=;
	b=jKhYcvqiKRY1NRzsnN2qQjYAw7TiXFe81xPf1YOGAlJxw+s+jv1HtYfqzRFdh+OFiDHyL/
	PFlYT7q3kP4H0O1Y+oI1bRURt2w5dXEgUOcvbbiioJBB7yK/X/nQzCbaRADF7tRjLDNgLJ
	bpEX4dZ0YjVzimOV1+ZrPx8eN5Axvf0=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Thu, 20 Jun 2024 08:52:43 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [tools PATCH 1/1] key: use c_long type for keyctl_search()
 helper fn
Message-ID: <d2b4vsppw3tsfmy3rndnf7ah42oes36rypodw2uejqzlw7glpb@oal2dp4ke6zp>
References: <20240620045804.27888-1-ddiss@suse.de>
 <20240620045804.27888-2-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620045804.27888-2-ddiss@suse.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 20, 2024 at 02:58:05PM +1000, David Disseldorp wrote:
> The keyctl_search() C function returns a long, which is already
> reflected in the KeyHandle._id type. The search_keyring() helper
> function currently returns a Result<i64>, which breaks 32-bit builds for
> e.g. armv7l:
>   error[E0308]: mismatched types
>      --> src/key.rs:121:16
>       |
>   121 |             Ok(key_id)
>       |             -- ^^^^^^ expected `i64`, found `i32`
>       |             |
>       |             arguments to this enum variant are incorrect
> ...
>   error[E0308]: mismatched types
>      --> src/key.rs:135:24
>       |
>   135 |                 _id:   id,
>       |                        ^^ expected `i32`, found `i64`
> 
> Fix this by changing search_keyring() to return a Result<c_long>.
> 
> Fixes: f72ded6a ("fix(key): search for key in all relevant keyrings")
> Signed-off-by: David Disseldorp <ddiss@suse.de>

Thanks, applied
