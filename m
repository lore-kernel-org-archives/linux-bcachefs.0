Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ABB1946B3
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729455604; cv=none; b=N+o/ig42s0ITp8FlcV8sUW9LkLG/1p7jYzNjMvW9nj6omisEfuuPa1kkbBkDpZ7M0UsELjlFYQinejwfoFi5j9yFyUnwEVpA2h9ShR9Qi0vH9YhnlGJb5KJ9dJWPfTLMf6qCWxID/HIRN8FF5bnapSWv6ChnmLN8RstDPbzVO04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729455604; c=relaxed/simple;
	bh=e7K4Zx1n2lvhlrQUbyLCESYeoHHqf32VaBlqlMuz9yA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kKWtVdwwwLp4AUAHJXSvO03V+lBEX0Jc76PI3Zm/nHIEUd89CzkaKeEQzu05Cmi8ZhYcjyUon2zOCs+Ugh7SBPWg3KqcDd+nsFUo50XE5nZzjP7EdgkW/v6qcrYDS5ff59k4ETlKv1gZLQjXciP0TYjsyHJkBGvqp66RIp2tUMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfpX2dTs; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfpX2dTs"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9a4031f69fso546549066b.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 13:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729455601; x=1730060401; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=88onBEAjrCo9PM88ELLaTVKMgRy8BmLUIyXxY2Wo4jw=;
        b=GfpX2dTsf/ojtIzf41NQUCPtRzEgM59GBa3l2pZUjx4xJHq4FL+okBNKT2yGTxX75P
         06V3+NOFFNJu7shoWagTX6HKmXVvxCzNXRBKNMLVl8uViJ8XWCsubfclHqNySh5RuNZZ
         yE97zKJCLvaZkJDBk0Mxd9wTmA5aZnI/olKaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729455601; x=1730060401;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=88onBEAjrCo9PM88ELLaTVKMgRy8BmLUIyXxY2Wo4jw=;
        b=HkMFN757RVZV4oJQFbasCzLHLn0Wrx6zXjyseQIkCrA6x96KHbcHP/zu6fa83qKSBL
         OhGdocuG5uGKaegNE2CUc6qyw8+QPe81G72IXNVv1Bk856a0ntS4c8cIzDJLkupIqEPt
         VFvTSpbo4alunvEM4yzG4vIg+uPO1eLJ9ciWZ5e7QV4sPo3VT3cAaXV3SJJsoXSe+bOO
         Z2AUvB6iL7ZdpV8ReA/pACdAQPoQcdcidiBEmJY8qFQuzgbKHNxYWKZZlCcF0pBZMeuu
         rCrvLKQePwRU6MLkeXHHpKII5j1L+hpKiIC9Kcn8E25n2/7QKTy8wBkeVqm8VMmMbas7
         h4Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWQ8fQmuwd/BqErlOhr7KM9T7q7b3/QzY5vq2b0VdqTei9S95UPBiB+KnPpuIlVp43VLv0WclX55qMfcXajgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkG3AaJAx60H0mNKRWnnXuC7PhSXr85cDbxObvA9rKj8UWgcgW
	rsF1G7NOFFu1QmMAuNtUwKRXQXWWkMpX2gGhG7dgdiHD8GywOL3yOI3H+QQ+fWbZyW8FadgHx0j
	FDQU0Lg==
X-Google-Smtp-Source: AGHT+IEYJRCweHVqkruSEkPXpthacPnbCAjExF1sadhDm9+CeMpt4BqpYgbmUgmlaQ0zp9J73JPG9A==
X-Received: by 2002:a17:907:3ea8:b0:a9a:8a4:e079 with SMTP id a640c23a62f3a-a9a69bad3c8mr984676766b.31.1729455600666;
        Sun, 20 Oct 2024 13:20:00 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9159a1a6sm121785166b.204.2024.10.20.13.19.59
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 13:20:00 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9a68480164so309642666b.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 13:19:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXa5eJ3rT41dcWlVrpSNeAxYqOOZAIRjhvpnrB1BANv7vf+im1LMZhLmP14Iy3qFv7kHdPL3GhJUzBMs2+ltg==@vger.kernel.org
X-Received: by 2002:a17:907:7da4:b0:a99:ecaf:4543 with SMTP id
 a640c23a62f3a-a9a69b7aec7mr918802566b.25.1729455599563; Sun, 20 Oct 2024
 13:19:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local> <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local> <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com> <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
In-Reply-To: <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Oct 2024 13:19:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
Message-ID: <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Oct 2024 at 13:10, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> And the INT_MAX check wouldn't catch truncation anyways - it'd only
> catch integer _underflow_, but allocation size calculations pretty much
> as a rule never use subtractions, so I don't think this check was ever
> worth much to begin with.

It fixed a real security issue.

Enough said, and you're just making shit up to make excuses.

Also, you might want to start look at latency numbers in addition to
throughput. If your journal replay needs an *index* that is 2G in
size, you may have other issues.

Your journal size is insane, and your "artificial cap on performance"
had better come with numbers.

Why do you keep on being the person who creates all these pointless
arguments? Not just with me, btw.

                 Linus
