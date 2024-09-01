Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6594E1EEE3
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 03:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725160442; cv=none; b=H2pAcGI/S3Cn/GUmE6NO9MWbXpIbu9uUdh7PzzC69hKbc5NwLxcPwCrRgMrSHnoJGRteeaCgQgTvr3Din+xp4tzPZwNKbJVSMnRgnX6inpVVvzmT2qYGe7nOIIFQ01vSEtKaHuhCT2cdhm63sEhFeXkURwyBmBOPZIUdiEb5byA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725160442; c=relaxed/simple;
	bh=YWMWPcMqHWLz5765/EzioozPxEQli1yw5/WJvX7GxB8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkyheBsJQnMnKTSBVIKnJkQcTjbgs5CDvRgwA1rwzHTd4dK4Wjkj8lDUlBSK6BJ91VvoOfUPAEgvSMGQo1P/73wtCDPs/onChwSM+W9h4hRQfbIWVB5hEiPS7cLy0c07DT+bUohRiHGfedYMcK3S3e2fbnPTZ7LYUMH7XVJkmT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4tGUwiP; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4tGUwiP"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a868831216cso355205966b.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 Aug 2024 20:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1725160438; x=1725765238; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vA9fKAepAjJP0Y+uK6ZVIFt69/fpi4A0HmGXHcekQRc=;
        b=N4tGUwiPzxVfZcktEevuvyld+dpyNGEJlwDe/E4UzJ00+BC+SgZLAgn8EE1WApv0za
         gfikfWl3S6rqQlyyOYPeekFg/pbWBMsvGUaZnMjQaEESO7ojg54vuA0xPtqQsJiKJ1M6
         eN8+XrZdt6zEoPljOz8yaz+NSOSmlRpYpxap4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725160438; x=1725765238;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vA9fKAepAjJP0Y+uK6ZVIFt69/fpi4A0HmGXHcekQRc=;
        b=F+tRrSyI2hXzTBxQIgwbKvBHer8NkDryBDVBHLwytDH+Qm32dqsWuZrebW1FBO5gdV
         eG0/m0uhRUN0Uy24QOOyTw2uX1GiNyKKMLpDZrX9OObIacor04guu5aYMKmw94ebnFzm
         EqjL6H4jLHcijMl2XIyXlYmO6cFSF0R8aPFm6Eik2bbvfYUAX6dutwWgg5TnTwwq4Mp0
         qZmCxR/1vjkH/BUjSiyPVmygisTKjgyW6YmWgsbM2O1Kmy0GgLQ+gNKOt/mTynnNOILb
         xr0o5c0VrffAqm8s32o2n2QouKMRhsZEG6Ot4viwyG6WIv3KRKJaXzZEL3oK3HRFJ5RP
         ucWw==
X-Gm-Message-State: AOJu0YzQXbUiWL3rs6GQwO7bDINcOQwRe5BFJDwhR7M6l/7NtNv+hysP
	f1a2dUIYKwTya4CO7oS2RMjzT8Jmj6vRGbG6Vj6mgD1qC6Kr3ZmsO+RN+IGNJvJzXINv8xuzjPI
	RGBaU5g==
X-Google-Smtp-Source: AGHT+IERhKXOhXccI/9kYkTMHnRAl/Uak19VWo1Fv5CxN6Y34+ZIx9hXMMcvPqG0+EK3/dqpU3oJkA==
X-Received: by 2002:a17:907:72d1:b0:a86:a41c:29e with SMTP id a640c23a62f3a-a89b93db7b8mr266469666b.2.1725160437984;
        Sat, 31 Aug 2024 20:13:57 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898900f29csm387175166b.64.2024.08.31.20.13.56
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 20:13:57 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c218866849so3320022a12.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 Aug 2024 20:13:56 -0700 (PDT)
X-Received: by 2002:a05:6402:270c:b0:5c2:53a1:c209 with SMTP id
 4fb4d7f45d1cf-5c253a1c259mr266984a12.25.1725160436527; Sat, 31 Aug 2024
 20:13:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <erydumpfxcjakfllmh3y4d7wtgwz7omkg44pyvpesoisolt44v@kfa4jcpo7i73>
In-Reply-To: <erydumpfxcjakfllmh3y4d7wtgwz7omkg44pyvpesoisolt44v@kfa4jcpo7i73>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Sep 2024 15:13:39 +1200
X-Gmail-Original-Message-ID: <CAHk-=wjBNzWL5MmtF86ETJzwato38t+NDxeLQ3nYJ3o9y308gw@mail.gmail.com>
Message-ID: <CAHk-=wjBNzWL5MmtF86ETJzwato38t+NDxeLQ3nYJ3o9y308gw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc6
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Sept 2024 at 14:44, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
>   git://evilpiepirate.org/bcachefs.git tags/bcachefs-2024-08-21

Hmm. Your git host is often slow, but now it seems to be even worse than usual.

I blamed my phone hotspot at first, but everything else is fine.

evilpiepirate.org takes a few minutes, and then I get a "Connection
reset by peer" error.

Maybe kick that machine? Or even just use something like a github mirror?

               Linus
