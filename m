Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFB2137E
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 18:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729449994; cv=none; b=aGJf79KxbFrkieu4jfviQZe/laLRwc66j6qXxzj25f7ooAk6+r7hIh060HHgt0GFRnPhucEvUa2rVM2kqFZKK7udvkvGxlj3bSalT23LSG21GFBqTF3FSfJ3IGLwwBQpJdGKmBA9tlu0EJaQfVqgLTG85FxI/tRvGQKg1UR7BjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729449994; c=relaxed/simple;
	bh=xiwYvqbiEeMl/0AlfbQ7y5WQrl00vZigFYAY8H9nbT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L6cCFbeAbPcgpyGV8lBrkFyb9CLyJWEk/NpefnTwloAGuoLVrl39LQFKtQAv/CqDuHYMptGiLMphPclQHTdDjkDlamyGKo1ZKehrKBqNpJg3vce05Vq9K3pMKprE75qwC0gDtrzBU1bGk9vai0HPvkAaYN3ms3I5XfFmd5M7g6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sg/KGm0D; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sg/KGm0D"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a0c40849cso584826866b.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 11:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729449990; x=1730054790; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0PLJqukBfD4fHf2ztQUKQIxZkUV+Rj9iZfPkEtdHboU=;
        b=Sg/KGm0DmNycBswHZ+dd9caMdMNGNMFJzBX4Yd8Yqr+RFS7dALbQ7mUt9qGB3YA3Hz
         hhTkzqLbbmB8JEBTtQyPFmwxsvEAlUYFysmguRYqTCyCxYUH7GUhSIIoHCQ35HrGHDjk
         R7QjqqdKJ8sE6lji90g9TmXbDbPn2n4AhvHfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729449990; x=1730054790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0PLJqukBfD4fHf2ztQUKQIxZkUV+Rj9iZfPkEtdHboU=;
        b=wTK2sQIUIIOGtlrfGX8c61rLcQGOalQyD33tS8O7Y15I2ldToQA7Hg4YpFZPobFudD
         n9SWHsWTJzUEr79eUg1k5mG036xMkd6UiKb/tmDK+q18ysitLG/J+GIoQNRSrRS78m9+
         8TbzJ5EI+30pH5239UbtT4CGlSfOF+rfF0KBkIsfWlFjKD22h/8JU0Vud8ZB60qwvN4/
         cTSdu0NPJ3GEJo47DE3nkB6/qUKpIUXk23BLSHymTJAoHAHGx/Gta4+tljGeXD4WsF+g
         vbGbGtVHTsGEzgbIQjq4Dw4pM4/6oxZaGS67IajT3q9voS6mMafKzM3lBCyWxDIm+Jz2
         q2mg==
X-Forwarded-Encrypted: i=1; AJvYcCU/c0bMDkW+RcweRXaOd/CRHSLKZBGAznoEraePE5+m7wYvKPkSkoEfT/d6YvfL2SUpTBaB3bSC38ibM+fMkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8B3Dd7/Pp+pOlACoAoL4fwhYWN0Q/3PH/cC7UYMJIvBKyyAjc
	9InpylR4SziaacS2red30y83lufB5TsZojA2nnE9c+oRHQydgDTm5JbDHPsNGAv11J+aPTxbLDa
	T//yfqw==
X-Google-Smtp-Source: AGHT+IFzN4n1ih9jB52akfwCNgylgdeXHCE1gmfnYcq2VZdBaDJvGB/SVeh1/FR3Kurrjm5qZeYtnQ==
X-Received: by 2002:a17:907:2cc6:b0:a9a:2a56:91e with SMTP id a640c23a62f3a-a9a6996b20dmr1051624966b.6.1729449989919;
        Sun, 20 Oct 2024 11:46:29 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912ee077sm115776066b.65.2024.10.20.11.46.28
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 11:46:28 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a1b71d7ffso597461666b.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 11:46:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXbbeC/mwW2UVaWgJrCuczoPTheK+Q5yzoCbTxXUX9neuKkKwI6Wy93oXYht4LteoivxylzqaDRv4Wqd1m5mQ==@vger.kernel.org
X-Received: by 2002:a17:907:2d86:b0:a9a:29a9:70bb with SMTP id
 a640c23a62f3a-a9a69a7866amr846780366b.14.1729449988270; Sun, 20 Oct 2024
 11:46:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local> <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local> <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
In-Reply-To: <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Oct 2024 11:46:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
Message-ID: <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Oct 2024 at 10:04, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> But given that vmalloc() already supports > INT_MAX requests, and memory
> sizes keep growing so 2GB is getting pretty small - I think it's time,
> this is going to come up in other places sooner or later.

No.

If you need 2GB+ memory for filesystem operations, you fix your code.

2GB is more than you *can* allocate on 32-bit platforms, and even on
64-bit ones it is often quite a lot.

So even aside from the *fact* of integer overflows, that check isn't going away.

             Linus
