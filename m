Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC04F57870
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 23:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DYyV9AVQ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e5f746ac4so14682255e9.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 15:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705017522; x=1705622322; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nsr6PFlZr2msZU50SITFyVGPFm+oEax+N/q9E6uP/As=;
        b=DYyV9AVQydERZeSEYr2aUBf0HOdug7/MGPUMX0nhGBEq9vWPVkwEV8BfrQpI1hoRRB
         vQA2tKUmrFEaUD06Wr8Pn/bgqRZmRQACgeClukpS7VRNpBVlMKWU4hWNT9lXGfyanV6z
         FV5N+3AfJJLXoSSKkgZmoKUX7NoQU4CfyWGQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705017522; x=1705622322;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nsr6PFlZr2msZU50SITFyVGPFm+oEax+N/q9E6uP/As=;
        b=wLJ0ZKyvxwLhCWWqk8triAqb5PkvEYjNCLRivgpqe2WQGiPb42x0X9QtYja5+oCUGZ
         rLf6IKXmf+DfUH/YnwAXqmIAztCO1F8EfmKjxZkG6NB4fqm7OY4RHxq0P5vZ+2zBWaWF
         /+lXXHGH4jbMLVZCeIFBBediTe2gBSWLYb2zd5wXJX/OS30TnsZ+A6BFHRXHFULag5p6
         Gd3ZN3TmwMhV/po9mUPyWAfAzarp/oVVsF0DGWmDEsLj1duoWNddJNdho7wrBMDMZZQJ
         wPB2js33tqqE7mqny9y9NJpE5eTAQiBrWHEEnMRxywloF4wYmyo2rmQh2MqgXLQVCxwn
         2Fog==
X-Gm-Message-State: AOJu0YyncXvxSndkcULlVMgo9x5niYgH3oxfMBhKptaJVNEadoUs0kYW
	bTKDchyGLcc609pwTn6YevuZfZ1u7cc6UJd5amn3L/h/GVFAHOTM
X-Google-Smtp-Source: AGHT+IEM4oQ+P0Kq7H8xPu95PNd+GS1CvwCuaegx371hrP+VnczYYFfmZHGZmEh7h9B5xt+cy2Df5A==
X-Received: by 2002:a05:600c:2809:b0:40e:6272:b5a2 with SMTP id m9-20020a05600c280900b0040e6272b5a2mr323193wmb.83.1705017521723;
        Thu, 11 Jan 2024 15:58:41 -0800 (PST)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id bt22-20020a170906b15600b00a2c32c5f484sm1111105ejb.209.2024.01.11.15.58.41
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 15:58:41 -0800 (PST)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a2821884a09so504322966b.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 15:58:41 -0800 (PST)
X-Received: by 2002:a17:907:a609:b0:a2b:d242:8d35 with SMTP id
 vt9-20020a170907a60900b00a2bd2428d35mr295990ejc.40.1705017520730; Thu, 11 Jan
 2024 15:58:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <wq27r7e3n5jz4z6pn2twwrcp2zklumcfibutcpxrw6sgaxcsl5@m5z7rwxyuh72>
 <202401101525.112E8234@keescook> <6pbl6vnzkwdznjqimowfssedtpawsz2j722dgiufi432aldjg4@6vn573zspwy3>
 <202401101625.3664EA5B@keescook> <xlynx7ydht5uixtbkrg6vgt7likpg5az76gsejfgluxkztukhf@eijjqp4uxnjk>
 <CAHk-=wigjbr7d0ZLo+6wbMk31bBMn8sEwHEJCYBRFuNRhzO+Kw@mail.gmail.com>
 <ZaByTq3uy0NfYuQs@casper.infradead.org> <202401111534.859084884C@keescook>
In-Reply-To: <202401111534.859084884C@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jan 2024 15:58:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiWHj83=NnpT5mo9M7r=s7GmCdNczRfmN87thLFxA+pqQ@mail.gmail.com>
Message-ID: <CAHk-=wiWHj83=NnpT5mo9M7r=s7GmCdNczRfmN87thLFxA+pqQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs updates for 6.8
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Jan 2024 at 15:42, Kees Cook <keescook@chromium.org> wrote:
>
> Another ugly idea would be to do a treewide replacement of "func" to
> "func_deprecated", and make "func" just a wrapper for it that is marked
> with __deprecated.

That's probably not a horrible idea, at least when we're talking a
reasonable number of users (ie when we're talking "tens of users" like
strlcpy is now).

We should probably generally rename functions much more aggressively
any time the "signature" changes.

We've had situations where the semantics changed but not enough to
necessarily trigger type warnings, and then renaming things is just a
good thing just to avoid mistakes. Even if it's temporary and you plan
on renaming things back.

And with a coccinelle script (that should be documented in the patch)
it's not necessarily all that painful to do.

                Linus
