Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77A5279DA1
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Jul 2025 09:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753349241; cv=none; b=szulK68BrA2pVWVKQjKxKgzUmLjrYD6D+t9ppib0XEYJ0t6D9pFm/jWktkIj080Lwk2Ru/oRIifbcU/NOfRE0FvkSjGoWeFcXFeDik/QaeJ36MWE9l0zb74eirvjRamwjfJLxPSOGGKoAc/L8z70UjwLlWhj1pxJpDSxW8ctif0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753349241; c=relaxed/simple;
	bh=+ZnY3P2X7S+RjIK7x3kjMud65ddeKN8CGNIBvXvMncQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kUydLNjOHNTr6mQ6hhQ2AzfVfyWQH0R6Oj2LCujizGMMqDRdhg7Xsh5ALD/5t1Y+r1LeLNwFqYZ+DoYMQBKrmd6YbtQuy8tkrh/U3jCwPHKzyXF6UT4Jti5q0uBPC9XjS9E1Q12q0fGZ7HtWEzNPOAzWLbfO2FpAPOdYglQeG1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1UGICBqT; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1UGICBqT"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b7691b297aso540934f8f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Jul 2025 02:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753349238; x=1753954038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsrwKI3F7bGxyMyCeBsCzUls3NPftVxNs1GB3kxRYJM=;
        b=1UGICBqT1ZIWgjiOXCuGr7zQ2PUhDBdeY/6pLHPij1lEpseCP2BOOaLdL6QNVl0r7m
         eMsemEZVgVeWohE71HCszNVOm0L21zODEACYjbRd4ZkFJh5avwAGKRvJLiYjrpyFpsqk
         2FVkPbXxv8cRSX8X9Cm3O573YU3y6Vg+HhnkSLY4bppxhf5V+3UMGwTcb9tyXasVgrXb
         3o7DzIrouI78rOYIlDCMj9pqL28X1x7UN6TYnAIkzxzyJlRmvpV6MrvDzkKCh7VHYzMM
         xleihsh3V4yBoVH6EiMxCrJiLTd2sCD13xJKeOcSspB3BBeNYmY0jhkGav/izNMuM/t4
         eixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349238; x=1753954038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PsrwKI3F7bGxyMyCeBsCzUls3NPftVxNs1GB3kxRYJM=;
        b=VvnuXtJiWnNf5FCw7rPRgdJKU+oNs6lVV21Q2RTrceXo9xLMjDnIzbV5TTOq8BNy+6
         zWa/qEPaUaFpvIqiqAHhCcPPXvJINMzgpKtMyvnQcRfCdilbfZJFpIZHPD7Sywo2mlLY
         vwt2LUitmrI2xpz6uZh+ElxKMDcuy4aPYp0mtYLy2H1NfuzXuXU+wySmwyg7B+1lxCVc
         kfdvVYT5vXIdqyslalELBMdkVffK1SuPzS+57zQCYgS5EvqP88zWHNRLDTAyt0GdEoZo
         AoEsENgSQD5HAn5nULMRS2MPMzPGrpnoaejDL9dcLZHRym4rvAJSlE7Ocloax5i1Pojm
         ly5w==
X-Forwarded-Encrypted: i=1; AJvYcCWhZAjVL4QfpIvSOxxlruyNJ2QqIo874b1ztJz7jgI8o1l8ki3xXfqc83SQKK7x/kfdWxT78Hlyj9vN63+ekQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhlAy/bI2JuDIhcf2q8+TY8678XldlzJ+cx2HNTfFliRjkx3mQ
	C7ucosoUmau5UtRXhgspxodzl620YgqI4YU51aDAHeU2HyApPLr8q56QSJvPZEoBmabk7bDQM6n
	+dixtURBwThlIOIE3vg==
X-Google-Smtp-Source: AGHT+IELtTR5XvjXT9CI/JkCboBp8PAzgWTU7RN+Nu/d1GBEMVnbisQm+epTaSt63SxD8yXeLjeB/JQjltpOZIg=
X-Received: from wmbay36.prod.google.com ([2002:a05:600c:1e24:b0:456:1ccb:7fbc])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4022:b0:3a4:d6ed:8e2e with SMTP id ffacd0b85a97d-3b768efff13mr4278297f8f.41.1753349238077;
 Thu, 24 Jul 2025 02:27:18 -0700 (PDT)
Date: Thu, 24 Jul 2025 09:27:17 +0000
In-Reply-To: <20250715135845.2230333-1-vitaly.wool@konsulko.se>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se> <20250715135845.2230333-1-vitaly.wool@konsulko.se>
Message-ID: <aIH8dULJCe4FUd8I@google.com>
Subject: Re: [PATCH v13 4/4] rust: support large alignments in allocations
From: Alice Ryhl <aliceryhl@google.com>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, rust-for-linux@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="utf-8"

On Tue, Jul 15, 2025 at 03:58:45PM +0200, Vitaly Wool wrote:
> Add support for large (> PAGE_SIZE) alignments in Rust allocators.
> All the preparations on the C side are already done, we just need
> to add bindings for <alloc>_node_align() functions and start
> using those.
> 
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
> Acked-by: Danilo Krummrich <dakr@kernel.org>

Acked-by: Alice Ryhl <aliceryhl@google.com>
