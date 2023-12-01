Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="MzRsQKWo"
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671111715
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 18:58:55 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-a00cbb83c80so233603866b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 30 Nov 2023 18:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1701399534; x=1702004334; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GKRqMkMuSnteVCR9/jJT3xFVtsM844NAUYbg1NFX8Fg=;
        b=MzRsQKWoCrhLaIyniY0ihpSk2sYqCUOLwlOhYYAGeW2BqB6PSCBbdDwkEqO/FjiF/6
         Y6KwhSlASaEzBsXAmFCZBzqUUQoKgWxsKzc5JwjtvlNl4jM1HYR0KhDDx5qXVRhrMsPI
         FEatlklCNfRor5qkKQKexMr+0EFmvAGRlkU4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701399534; x=1702004334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GKRqMkMuSnteVCR9/jJT3xFVtsM844NAUYbg1NFX8Fg=;
        b=jKxD8lGIM6tPGocSP9b2rlQY7ia3P9HaSjHd8WwfpSh2C9e+FPUQHqOW6sdR9PqRkW
         R97ybQw7dUok43M1YxaHPvrIjrbd9ChzkXHQxqbL4ZhN+BWnaVdvNYWLkxqdX/YuWNqI
         Zy5RaUtXz8Xd5R4TxB7LxvbkdxSdRwBVjbOmW5UrH+9Dt41hLvytPQIGghvH3hki34hl
         ALB8jZnxvdYNf+A1CV0DXlP5HuDjlNBcv5QuEKKYi9zmDBxJKAQaS9c0N9g/zq0nZPbp
         02swTUrHeNCq6iV5aWv+1tjrobAsEuZCZdzyZqog3xOSj31ZIgSr4vAfDKltYfZIAZD1
         VrrA==
X-Gm-Message-State: AOJu0Yztd/0G5GrgfjhkdFoxxaTINtYH6tbVjLSXicem6Rpn6LHwJyzE
	+JfrBEIMwwbvYd0ENaAvRGCUlyhvihhkrFleGq0ONv+YZR1ZWv3aycrH4A==
X-Google-Smtp-Source: AGHT+IGltQE34zLV/o2J8TJkA+UJh6sdCF8BER8QY3BRlRgvhxsMOswMsZKUe+8tETbN94/ejBfZ0hDgH0cbuYrvUgM=
X-Received: by 2002:a17:906:21a:b0:a12:5dd2:4649 with SMTP id
 26-20020a170906021a00b00a125dd24649mr349956ejd.43.1701399533780; Thu, 30 Nov
 2023 18:58:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMVG2stxMYZbDoAHeVQjgJ7f+Td7+VJrLNRbY8au68ZVkzhb0g@mail.gmail.com>
 <20231201015055.pn5qqbsk42jlfsoc@moria.home.lan>
In-Reply-To: <20231201015055.pn5qqbsk42jlfsoc@moria.home.lan>
From: Daniel J Blueman <daniel@quora.org>
Date: Thu, 30 Nov 2023 21:58:42 -0500
Message-ID: <CAMVG2stS=W4d+XxxHzLb+31Dn7pnqjTE25pDwLSv_14rcqsc-g@mail.gmail.com>
Subject: Re: bcachefs page fault oops after device evacuate/remove and unmount
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Nov 2023 at 20:50, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Thu, Nov 30, 2023 at 08:47:33PM -0500, Daniel J Blueman wrote:
> > Hi Kent et al,
> >
> > On upstream bcachefs (master @ evilpiepirate.org/git/bcachefs.git) SHA
> > f8a1ba26, I was able to develop a minimal reproducer [1] for a page
> > not present oops I can provoke [2]. It appears we need further
> > synchronisation during unmount.
> >
> > Let me know when there is a patch I can test, or for debug.
>
> There was a device removal that was just fixed, I've already sent the
> pull request to Linus but in the meantime try this branch:
>
> https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-for-upstream
>
> If you still hit it, I'll turn your reproducer into a ktest test and
> hunt it down.

This did reproduce on the second cycle on bcachefs-for-upstream SHA
415e5107b0dc; let me know if you can't trigger it and I'll make some
adjustments.

Thanks,
  Dan
-- 
Daniel J Blueman
