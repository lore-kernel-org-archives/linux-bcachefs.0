Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F258DB64A
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 19:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729451365; cv=none; b=mNxAT/RZ283ekEpJM0OfFSh3RnallnaYaSvwXlaRq5ZxaK5qkujHLk8KIOzQvRn2YJmuZ3Sb0s2VDjvlBzyu12vMT9HXyM9xrko0d5rJBCkT/pz/QtBwr1dKj31se3ZyX7zE/Us6rhezM52GaBLtoeZuoWL68Oye+JPD0PdXqhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729451365; c=relaxed/simple;
	bh=k735ZudHdMdr9GxCf+6mTKa7j5+H2mVl36fU739RVWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eaIvhDR52j8WBn7cZYGrg/KmYOmjbFPhTIrCdLT9DTCO5YM5X4K58W4VM/Ay3jXdrZTsmwErJ3y/LZzG9EkHd3687LwiX8kJPB88hgZCO2W9vDA16qqCyTq1I0GIJsAtGUPMt44lDGi5TWdhNYiHn7g8xgb2/J311uliMlcSH44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YLpP7nL6; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YLpP7nL6"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c937b5169cso5867561a12.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 12:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729451361; x=1730056161; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KYjxnWwPmqT7k2atb9WIFGvUnSRguObdAtU4k6idx+8=;
        b=YLpP7nL6yi08H+/IJqs7yQchh2iu+Kt0akFvmALUW34OSgj1BUyAE/HCWDGy2ZwbcT
         qcAL0MEJkUzqCWGRUxidhgaHvA/WodxKOEE2fWq+G+PdsCh0CXSi/Mm5OxoiPj92XSYa
         M9cmziFmKwVF1aLOdLYuRibTT7PO4FtpkRD8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729451361; x=1730056161;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KYjxnWwPmqT7k2atb9WIFGvUnSRguObdAtU4k6idx+8=;
        b=VwsqRAPapSxHZW1RC3JBcNcDFIIYl3FoWdQFmMt6EDReX9t+rm+aoGg5GjpItrcfQk
         qJav7gHWW4M0XbUG5PQ/onPR+s4EOQ1UDUO3biG9TmDIxfctzXpIJkFtcE9gbTWQ9N0t
         NQ1NiQPVf0m1Fo/5/RG6VaMSrqb52jQ46rMBY/oRZMDDbiSiYvxAbKfI0ioH6ZeaUmVq
         Ez1qibMBnQ3kLrCoDwvAQ916mHmPK5+Z0P3bFKZNrJvBJGBlUHnei+SVUFxKXicnyj2k
         GcV6iYSHjQRJn/Gn28I+Y6XvQOLHKVdrvpUsCuouADmjnwQKnZZzKqcW/s1YBNz8nut7
         x8tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW5qtnnjzRsaw9Uvj51s2Cv0F0AiydCTT9zhnqwBPkQwVysI28SVla0cKiCCi3ATYSEbcQJbyNfg1REVMpdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsGcw4Wx42q3dC3lSYxRq121bsTLA9GoQm+FMyffq7R3zxPGOK
	6p27jNoBR9RYZz27cV38ad64WHTEI+TsF75dumDXPpvbVxyce+rKwV6iTX1tU91oKjxSizXNuns
	rfa7WDg==
X-Google-Smtp-Source: AGHT+IGKO0IE4aOwDuMsKifxb48NyHtSgw3ZxacEmyh3v67RdZovz3sftGIkry90W7PYV0D+bqcU8Q==
X-Received: by 2002:a05:6402:27cc:b0:5c9:66c:660e with SMTP id 4fb4d7f45d1cf-5c9a5a3cdf5mr14505673a12.13.1729451360864;
        Sun, 20 Oct 2024 12:09:20 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a653d0sm1140719a12.24.2024.10.20.12.09.19
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 12:09:20 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a99f629a7aaso664288766b.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 12:09:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW2RBfZp3vqQKJ/Vp75OVaeAWK3E4H5IOs3uQouThxpX+DkLxSAf9oQzMh9rB0o9Sbr+vhS2HRtKSwvceNtPw==@vger.kernel.org
X-Received: by 2002:a17:907:1c24:b0:a9a:170d:67b2 with SMTP id
 a640c23a62f3a-a9a6a5af165mr1113793666b.29.1729451359367; Sun, 20 Oct 2024
 12:09:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local> <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local> <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com> <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
In-Reply-To: <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Oct 2024 12:09:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
Message-ID: <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Oct 2024 at 11:53, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> This came up on a machine with 128GB of ram.

So?

Your argument is "we're using a ton of memory, so we can use a ton more".

Not a great argument.

How about you limit the amount of memory you use in the first place instead?

                Linus
