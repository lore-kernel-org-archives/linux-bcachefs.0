Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014004F8A3
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 23:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e520My48"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d3f8af8297so24802935ad.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 15:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1704930524; x=1705535324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SwuTP7EzLEPd51rCmWc5l3FryuUpUIDaJ3oLG7EKxvs=;
        b=e520My48wrc6W1VBmjEKzXuD1l4aGEQr9pEN9UAoEUhQd/QUYuqS44jBW1Zw8B7Vwn
         rrGjOu7rPy2Wuan6f9O5ksZVKuA6URdB0/bxh/IavXl5ikWeLH0TmAyCUV9KNYOG23Tm
         fqS/uKRfi0lqWFMNaWxyrTbKEOGG3RQ9v03gU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704930524; x=1705535324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwuTP7EzLEPd51rCmWc5l3FryuUpUIDaJ3oLG7EKxvs=;
        b=mTYomBOIDqzCCQZOkMafXTn/hoSR4uM/7fznV6xNdKT6ejPKCRxkf37OUAJB4GU0tn
         Z3vwHVPYJiaS7hHAHlpcNosQnpNexrfyDYeuhpcY3x5c1yhiCyLbruzzNfi2MvS1KWc9
         K950kwko+U9XGc6Vl9OQ2LstHzxvgsSjmvYtEJjKgQ5HtCc/38HwShFkUqhtYAKRbJjs
         idpNtDMeTY+IBo6By5DPD56f0Y53h9DbLUz9if7tfHjxjd9lG1PPNRiRINnx9OeY/fKY
         nKnQjB0r66+PzmQLPUdOy//APMkxnTTK5XjvnRq+tFuvSNUdmC0RGTRM/SGjQLUUgV4s
         qhuA==
X-Gm-Message-State: AOJu0YwFAQi/lJ/HuYqe5k8cpS4BOO73ZI9WHUbRKE9sDYqsGHla/aiD
	KwnTWEfKFk37L1fJEhXkg2uU9/x755dR
X-Google-Smtp-Source: AGHT+IF8fgccVOtXqOEaJFh9qZqdhLe5dF5tch6GtJyBls2H2Ztl8x5oLrB9yayQo3OC6NpC/wcPaA==
X-Received: by 2002:a17:902:e80d:b0:1d4:f114:62c4 with SMTP id u13-20020a170902e80d00b001d4f11462c4mr399322plg.86.1704930524297;
        Wed, 10 Jan 2024 15:48:44 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ab8c00b001d3bf27000csm4210321plr.293.2024.01.10.15.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:48:43 -0800 (PST)
Date: Wed, 10 Jan 2024 15:48:43 -0800
From: Kees Cook <keescook@chromium.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs updates for 6.8
Message-ID: <202401101525.112E8234@keescook>
References: <wq27r7e3n5jz4z6pn2twwrcp2zklumcfibutcpxrw6sgaxcsl5@m5z7rwxyuh72>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wq27r7e3n5jz4z6pn2twwrcp2zklumcfibutcpxrw6sgaxcsl5@m5z7rwxyuh72>

On Wed, Jan 10, 2024 at 02:36:30PM -0500, Kent Overstreet wrote:
> [...]
>       bcachefs: %pg is banished

Hi!

Not a PR blocker, but this patch re-introduces users of strlcpy() which
has been otherwise removed this cycle. I'll send a patch to replace
these new uses, but process-wise, I'd like check on how bcachefs patches
are reviewed.

Normally I'd go find the original email that posted the patch and reply
there, but I couldn't find a development list where this patch was
posted. Where is this happening? (Being posted somewhere is supposed
to be a prerequisite for living in -next. E.g. quoting from the -next
inclusion boiler-plate: "* posted to the relevant mailing list,") It
looks like it was authored 5 days ago, which is cutting it awfully close
to the merge window opening:

	AuthorDate: Fri Jan 5 11:58:50 2024 -0500

Actually, it looks like you rebased onto v6.7-rc7? This is normally
strongly discouraged. The common merge base is -rc2.

It also seems it didn't get a run through scripts/checkpatch.pl, which
shows 4 warnings, 2 or which point out the strlcpy deprecation:

WARNING: Prefer strscpy over strlcpy - see: https://github.com/KSPP/linux/issues/89
#123: FILE: fs/bcachefs/super.c:1389:
+               strlcpy(c->name, name.buf, sizeof(c->name));

WARNING: Prefer strscpy over strlcpy - see: https://github.com/KSPP/linux/issues/89
#124: FILE: fs/bcachefs/super.c:1390:
+       strlcpy(ca->name, name.buf, sizeof(ca->name));

Please make sure you're running checkpatch.pl -- it'll make integration,
technical debt reduction, and coding style adjustments much easier. :)

Thanks!

-Kees

-- 
Kees Cook
