Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994A159B6C
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 23:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="a5qWjW9y"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28c0d8dd88bso4145876a91.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 15:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705016541; x=1705621341; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HLRr3cB956ITDOde4XWHLwfBAaAcN3eYLs/KzgE1pRQ=;
        b=a5qWjW9yo4c1/T7BMdV3f9YajqD8Ud9NEhvBr5fJYN38WQ9jnsrVgKt5JGiUSCk/1n
         WC1wQuEK0MdY82dkaMAN13BtBOBwF5wCmecSvgG7uR5UYtcpzjdUsI8K1xdoigWBziT4
         dct7uefkdXD+yVMsi5Y2CSZKSzXCvkSBR8g8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705016541; x=1705621341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLRr3cB956ITDOde4XWHLwfBAaAcN3eYLs/KzgE1pRQ=;
        b=pUMQjurVopv8qDfrH0ev2KvsaTseeCUDqE087vAqsN4iLgmimybln4nvPRGm3uezSi
         d78RH7S0Az4lv8Lp+6h7Hr3DjKDCFJOgUZEArdHDZefulfvJaig11OKc7MuJOzRfnJbj
         lJnG+Ov3Z4PIxRGpbupJINOYTCmvH789+v2P22WQ2bkTBKYNoG2wEwv5+bxn7ZPnO5z1
         R1dM3i9YhJGQbalIX2JsoEj1i7PuYcWCJs/CEoDs+mD5jKuNqgZTHzHmRyzNlbv5nuLA
         n3/QCfBBI6Lzvr2vWN1gTBeYIoNNJSoheon0kFbkyT688zxefKyze2HQzg+iT9foSLQN
         qTOA==
X-Gm-Message-State: AOJu0YyBW0roNfe691LmSi83X0+YlTIHgGwEMYXQfauBVeDTyBuPEqhc
	0ez2XCixwDt+MwhU0wdqg8ynBoficdd9
X-Google-Smtp-Source: AGHT+IFSa007JS+IUFxOECtmcf0vetaWGEBAt+YZNTxVumwI+0QQQjLM7xCpUBx/BLuHyGiobto1YQ==
X-Received: by 2002:a17:90a:458f:b0:28b:fe1b:5274 with SMTP id v15-20020a17090a458f00b0028bfe1b5274mr533729pjg.32.1705016540850;
        Thu, 11 Jan 2024 15:42:20 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id eu15-20020a17090af94f00b0028b845f2890sm4534946pjb.33.2024.01.11.15.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 15:42:20 -0800 (PST)
Date: Thu, 11 Jan 2024 15:42:19 -0800
From: Kees Cook <keescook@chromium.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs updates for 6.8
Message-ID: <202401111534.859084884C@keescook>
References: <wq27r7e3n5jz4z6pn2twwrcp2zklumcfibutcpxrw6sgaxcsl5@m5z7rwxyuh72>
 <202401101525.112E8234@keescook>
 <6pbl6vnzkwdznjqimowfssedtpawsz2j722dgiufi432aldjg4@6vn573zspwy3>
 <202401101625.3664EA5B@keescook>
 <xlynx7ydht5uixtbkrg6vgt7likpg5az76gsejfgluxkztukhf@eijjqp4uxnjk>
 <CAHk-=wigjbr7d0ZLo+6wbMk31bBMn8sEwHEJCYBRFuNRhzO+Kw@mail.gmail.com>
 <ZaByTq3uy0NfYuQs@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaByTq3uy0NfYuQs@casper.infradead.org>

On Thu, Jan 11, 2024 at 10:57:18PM +0000, Matthew Wilcox wrote:
> On Wed, Jan 10, 2024 at 05:47:20PM -0800, Linus Torvalds wrote:
> > No, because the whole idea of "let me mark something deprecated and
> > then not just remove it" is GARBAGE.
> > 
> > If somebody wants to deprecate something, it is up to *them* to finish
> > the job. Not annoy thousands of other developers with idiotic
> > warnings.
> 
> What would be nice is something that warned about _new_ uses being
> added.  ie checkpatch.  Let's at least not make the problem worse.

For now, we've just kind of "dealt with it". For things that show up
with new -W options we've enlisted sfr to do the -next builds with it
explicitly added (but not to the tree) so he could generate nag emails
when new warnings appeared. That could happen if we added it to W=1
builds, or some other flag like REPORT_DEPRECATED=1.

Another ugly idea would be to do a treewide replacement of "func" to
"func_deprecated", and make "func" just a wrapper for it that is marked
with __deprecated. Then only new instances would show up (assuming people
weren't trying to actively bypass the deprecation work by adding calls to
"func_deprecated"). :P Then the refactoring to replace "func_deprecated"
could happen a bit more easily.

Most past deprecations have pretty narrow usage. This is not true with
the string functions, which is why it's more noticeable here. :P

-Kees

-- 
Kees Cook
