Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9B927AC37
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Aug 2025 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755792586; cv=none; b=mR5yfAuyiR7AoVwg34XMVqNs5p3wh6H9iiCtTndTGbvzzHw1T2NPgCgd8uXLC0dbVgOjP70CkzraeNvscQ6quCPM8cjIA/Zcux/mTwgfyq6UlRWh8k178p8FpDQr1KluLwvAH+sBzPLFYKP4p3C55NoO3FMyHprNCuYSpJ1qS64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755792586; c=relaxed/simple;
	bh=6WjcSP6SOFTt6Yu67V6Wv3TS+KrfNiKNYqKA4b4phW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGuDgCURq67e1MfekHf4uwXRHqj0f9gPBmyT+W1qvx950slaSyObg5EYT9d3V1YxTj2OjR7R321m9gK9Er4njHkDo+ho9dVGPIM9eILnoly+vzHu3Kv2TSCO/hPI87coFtb7mzkXpmQMBasgEvHhL4gi9QH7PVy5J0A1TaSnBhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pSvfK21o; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pSvfK21o"
Date: Thu, 21 Aug 2025 12:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755792570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LWps1BVOFzJixHZTrp3fOYbUvOGqY5I9MFzq6N8LXt4=;
	b=pSvfK21oVCgvO4FQR3/LQzQWy8T7T4y0UKEIyteQnH3P9PdSrogY2/roxuua0QGPVzsUBc
	BexcYvgYEMa0kbgAwVq+9KJlohNThkJT68E8V3hhCx40n0mVIgRRouOjxEXmkswacvSijL
	UE9OHb6Ld9YcXlsObVx2YUmca09mtUc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Documentation <linux-doc@vger.kernel.org>, Linux bcachefs <linux-bcachefs@vger.kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2] Documentation: bcachefs: Add explicit title for idle
 work design doc
Message-ID: <hsvtot4ds63jktba7chymx4d5qs4cbmnwakf6elornrlj53lmk@lld5rgm7rcbp>
References: <20250821004620.10772-2-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821004620.10772-2-bagasdotme@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 21, 2025 at 07:46:21AM +0700, Bagas Sanjaya wrote:
> Commit 9e260e4590e044 ("docs: bcachefs: idle work scheduling design
> doc") adds design doc for idle work scheduling, but misses explicit
> title heading, causing its two section headings to be toctree entries
> instead.
> 
> Add the title.
> 
> Fixes: 9e260e4590e0 ("docs: bcachefs: idle work scheduling design doc")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Applied

> ---
> Changes since v1 [1]:
> 
>   * Keep original "design doc" title (Kent)
> 
> [1]: https://lore.kernel.org/linux-doc/20250820002218.11547-1-bagasdotme@gmail.com/
> 
>  Documentation/filesystems/bcachefs/future/idle_work.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
> index 59a332509dcd97..8519fdcaa5ff49 100644
> --- a/Documentation/filesystems/bcachefs/future/idle_work.rst
> +++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
> @@ -1,4 +1,5 @@
> -Idle/background work classes design doc:
> +Idle/background work classes design doc
> +=======================================
>  
>  Right now, our behaviour at idle isn't ideal, it was designed for servers that
>  would be under sustained load, to keep pending work at a "medium" level, to
> 
> base-commit: 37c52167b007d9d0bb8c5ed53dd6efc4969a1356
> -- 
> An old man doll... just what I always wanted! - Clara
> 
