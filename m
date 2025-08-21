Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449232D47F3;
	Thu, 21 Aug 2025 03:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755745265; cv=none; b=NXq6qKAdRw1L6MOCHwl6XxuD03/fcNinGkpCf0FR823JjVesf8DFcHw4FkPibUb6u4gBYsVn5trZJAYjbaM9jbtNDKZjKcWcg1PUjHiP/KLApuQKWmGCtx91ns9cqlA7tYY1iNAauk1bQC56qIu5XVXwc2xcH953Ozi74Hi9jig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755745265; c=relaxed/simple;
	bh=YSomtZR6Iz7wSwrI5TeM7V9WNaumQMzoGVwrf7QRGz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pQvUHi1fMhXfeB1XM8iWjqSjcVlxtZDuO/MCI8Uc9KyIdW0F4t/h2p/pEdmPVLtwhboy/uYwTV9Cbauvj4QAS8wZBYY6cAN0VRZ47CFVNronlUopZH5D9TtDylhodZjMq29RMkJnc4cxlhN7pPinInAEJjYCEz96yzbdgfHy/as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LHaJIIP/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LHaJIIP/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Ym4acFbpyZkWo01fruGU50a8fZfe3lsN3Yu1x/gnGho=; b=LHaJIIP/BPmL3xSWO79c9LvL5y
	48vJFiCPAdGFQmIKAvt3seRkVwfg1GoPtdmXrLF1DxicRhO6vLEGe2qPmmR5WxaLTWA2Za7g30Gy5
	Fi4/8Uu8afz9oSjqNKJHkwQ1nE//3L/aV43yTiniSTe4cRrZzpeuQ1Uqb3GT04OwmZzAU9eHeJs2i
	fHYYiLGrao8Rw4f/2MKdtoF+27JQNh5AZZcucH19Lz4kORPeA2Tc6R0I0f2DyLo4KV4My/kLeznWJ
	aWh28vl0KT17Q7oBPbosSn+lIyP0ZeTdyYzwbc6xHrQEMUuLUzWoMXsqIheKuaGrfp+gnzo0mbe/i
	3OS3HQcg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uovXs-0000000FaOF-1FQU;
	Thu, 21 Aug 2025 03:00:56 +0000
Message-ID: <5e0fdb1e-08c5-4d32-92d1-00bc547d62d9@infradead.org>
Date: Wed, 20 Aug 2025 20:00:55 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Documentation: bcachefs: Add explicit title for idle
 work design doc
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>
References: <20250821004620.10772-2-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250821004620.10772-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/25 5:46 PM, Bagas Sanjaya wrote:
> Commit 9e260e4590e044 ("docs: bcachefs: idle work scheduling design
> doc") adds design doc for idle work scheduling, but misses explicit
> title heading, causing its two section headings to be toctree entries
> instead.
> 
> Add the title.
> 
> Fixes: 9e260e4590e0 ("docs: bcachefs: idle work scheduling design doc")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

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

-- 
~Randy
