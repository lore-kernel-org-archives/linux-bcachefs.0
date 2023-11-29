Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NSwW7BGM"
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAFED67
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 12:13:18 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6cdd405ca77so190241b3a.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 12:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701288797; x=1701893597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wGNO/FU6EbIMJxkiiI7PYYT8RbUNVHzpIkE2CHH5mhE=;
        b=NSwW7BGMjMuVUUuyJsckqVA2ZjLRzOGxhvTnAkQBjucTSPmzM1G4AZOeB/VxQ29MaU
         ez/ac/su8xhqonQikcx/9eBeGBhX6sCZ7y+leSFyE8aa6vzKYUdat9e7ZZZKd/bAq9sN
         Mu0G4ArZYrPsxM/EKyDhIdhWaIBtTkbJmHtBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701288797; x=1701893597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGNO/FU6EbIMJxkiiI7PYYT8RbUNVHzpIkE2CHH5mhE=;
        b=EcdTAuSi5npVumhGzEC3Kx487H+0kaYiGWG21xHWdelPeUasxjbHZP0ywklECHRDRR
         zyzhCJQPLpKtYBzEdWsIZCSLHgGTBlkliTI55TrvWcZCbLRwjXXHw8r9050p/oChdb2p
         GDHFCW89b21k6FQ8HdLhuwGNWcCcDiWT449SZgdTkXIMz5g59iFxPBWcTP3HJESw78b/
         UfD2gL/A+aHwjUXc0FMUehTnETAOvFOhe1ZzA/W1Oe9qlbytbsmIX+C1MGtb6g17XSpM
         F2Wnwi9UW6sd69FKps8PK8ejItB9/BB8b9OPV2MIDfdmntOQWnbNnJjfBfTLj4MEZMJc
         KF5Q==
X-Gm-Message-State: AOJu0Yw1ZDilN6kyhItrJI2Qrv/xYWFBEBZYlrQljhDoIA1H0sI6As/k
	pdRehoc4SUwQkVPsvU9VzOb3GQ==
X-Google-Smtp-Source: AGHT+IGLRLEmidEeUyhKevGVc4UsmZ87Z0IfhEoUik0F4rdAevbEg58uIkhKRgMt0cR609AqHC53bQ==
X-Received: by 2002:a05:6a00:15cb:b0:6cd:85a4:bbbc with SMTP id o11-20020a056a0015cb00b006cd85a4bbbcmr14837775pfu.9.1701288797589;
        Wed, 29 Nov 2023 12:13:17 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id fi35-20020a056a0039a300b006c2d53e0b5fsm11133448pfb.57.2023.11.29.12.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 12:13:17 -0800 (PST)
Date: Wed, 29 Nov 2023 12:13:16 -0800
From: Kees Cook <keescook@chromium.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: Re: [PATCH] closures: CLOSURE_CALLBACK() to fix type punning
Message-ID: <202311291212.7955AF30D1@keescook>
References: <20231120030729.3285278-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120030729.3285278-1-kent.overstreet@linux.dev>

On Sun, Nov 19, 2023 at 10:07:25PM -0500, Kent Overstreet wrote:
> Control flow integrity is now checking that type signatures match on
> indirect function calls. That breaks closures, which embed a work_struct
> in a closure in such a way that a closure_fn may also be used as a
> workqueue fn by the underlying closure code.
> 
> So we have to change closure fns to take a work_struct as their
> argument - but that results in a loss of clarity, as closure fns have
> different semantics from normal workqueue functions (they run owning a
> ref on the closure, which must be released with continue_at() or
> closure_return()).
> 
> Thus, this patc introduces CLOSURE_CALLBACK() and closure_type() macros
> as suggested by Kees, to smooth things over a bit.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Thanks for doing this! This looks reasonable to me. I look forward to
being able to do fancier CFI prototype partitioning in the future...

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
