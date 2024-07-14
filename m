Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24222572
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720988411; cv=none; b=jF2vxYhXMkxw1I4PvmkzsrV3bzemU0G+s0//+ik3jTp6GNAEyaxFLuY8SAoRPqF9MEQ+Sg41396M3PbmrKjdU9U8qA76ri6LRYCX0AEOFhqkFVToAoE/qjj7JSOybxrKhIQze8gdP1BI4w70wAYTt688Fli2EbCANxiUwurHDXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720988411; c=relaxed/simple;
	bh=Xv5B8q1L9+TTT+8EAr2frYdcVoxfTV2xnNJ9oRD0/Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThD9Es5WyleqtfmuQf4sztszxFMU7AisRWyOP9IkZfsSnZQyLN9WNWOxXbtlH7wAAWBAg5HIb9Egzor1r3wYmOeLBrefj9hQCg0H311YjaJlA8AwpK7TvEsMkM6918/fr1vKMGf4e5LUXNjfqTUQEGzwTpTtknvzYOBTaAPbdus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K2cX+p+Q; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K2cX+p+Q"
X-Envelope-To: tahbertschinger@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720988407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6m/YNCZODs1ri99PiK5INKC7LVMZ9lqNa9edOiQEyLQ=;
	b=K2cX+p+QGcWMnXjFeFCl35BHGwdzUQj36d2x7B2ThHPukMjZeK26n6u5jCn5+A3XDy0B7m
	vCu8VfIrr71fyBSOFYWzWV13FGfIr0IsjNPrYbCdx0UKx2VnHd1rL58PMLuOaT97hiS/qk
	X4+SXdlRwk888p1j9MATS4j9CbwQF20=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: bfoster@redhat.com
Date: Sun, 14 Jul 2024 16:20:05 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS v2 1/5] include debuginfo in bcachefs binary by
 default
Message-ID: <gv45bzjk2dxvtpdugepnzedypb2almj3mtbgr7imw2yj6qnpz2@zbshvzczjptb>
References: <20240714200226.746471-1-tahbertschinger@gmail.com>
 <20240714200226.746471-2-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240714200226.746471-2-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jul 14, 2024 at 02:02:22PM GMT, Thomas Bertschinger wrote:
> The debuginfo is used by the "bcachefs debug" and "bcachefs list_bkeys"
> commands.
> 
> Rust 1.77 [1] changed Cargo's release profile to strip debuginfo by default,
> but we always want it included.

Yes please, people who strip debug info should be tarred and feathered
:)

> [1] https://github.com/rust-lang/cargo/pull/13257
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  Cargo.toml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Cargo.toml b/Cargo.toml
> index 9d1756fd..d56d6272 100644
> --- a/Cargo.toml
> +++ b/Cargo.toml
> @@ -30,3 +30,6 @@ zeroize = { version = "1", features = ["std", "zeroize_derive"] }
>  version = "0.10"
>  default-features = false
>  features = ["auto-color"]
> +
> +[profile.release]
> +strip = "none"
> -- 
> 2.45.2
> 
