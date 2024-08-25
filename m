Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659CB3839C
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 05:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724563943; cv=none; b=U+C+7ekPd6YpC1Mc9eg+pu/ye9FN2oP5qZ+IPCl/ZZzIC68lpvTBnx1ObuRV57agbtMLAy94fI2WPiizBfaPPkW/6k2LxMp09LXm6emLKCBuRIQNSYArKySQTM1SVpy7W3CbIW7fyk3dHc+fFh7sf6m6iMbTayIWTGdJDoJCeTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724563943; c=relaxed/simple;
	bh=lIR4PJJpr22txE+7KQe1ZrS/bPwv/MRC3jdthL9V4Og=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eW89F2+P8k3Gu8129UsxpWzUJGWA8P1yN2U/OZTQfyrGqe/6kTxLqQP0TtGIYS4Ca48spLT58ANShX3rNzDiN3JOGWIi7lLF8m4sN940M3offj3p2/3ma0ivOxeiym6+1SOhH8M3uvaCFzng6C18RpGhOLdmXbgflceBbbrdsO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ELI44AvM; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ELI44AvM"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a868831216cso384653066b.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 22:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1724563939; x=1725168739; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8p3CsgOEStsbClYt9Jy8K8E742+g05Oei9CruGd2jsk=;
        b=ELI44AvMs+wfX1skmKVK4frbiRPznmlOFCHpcCSospEEgUDO1rBiqn1GrRBN1KyLiI
         eLvvXH1Iu55gCyQVIeMcKjN//v/dp5r9iemn1WR5eh4MhfCpFDN3cMnaOYwHqLR8pEHq
         kPRnprRHCHcptcZC2SYlpn0M7/mpii/oXBFyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724563939; x=1725168739;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8p3CsgOEStsbClYt9Jy8K8E742+g05Oei9CruGd2jsk=;
        b=QZeEUJl+CjXe/NYDnJE4wBIhzzfAovswPOYC73++xBJ9zBKDeLQp6cGHLS0p8BS9bX
         nYZ62JwDIWovW5VzxOwSfYPWYb3Sfb5VbAbbB64vg2OBAhfHzeImdeQkxhxMZgGqdF3o
         I+XtbLiECItPPRM2HAG+uK5jXRiM83XOl1v8oQQgNPlVSDtzy63IKQq+zVm1kBHwyH3Q
         7rF6ViM1SDrVEGa+0tJPyZrqRI98b0vedJ47bAow9STM1BjjduP3M8h2qh4d4aaY0RKd
         kptV/J5OnZRMsEbHusHVXHcMp56ZL3LSJlp7zUdyOwECR9vyLs7FdaLYWvsLOXI3TCii
         JMSA==
X-Gm-Message-State: AOJu0Yz0wDTOypcbrYrCM2hTSGpr0jnelZ/g/ZHya3vpNWjx8uHK7e8L
	syKfbmslMyFYJqMBOPSzUP4ds+4tUAK+QJdyuQnYa2NWMZkCch7fNl7Y5OfBV6c1bBZ+ftC9iGB
	u8JSm2Q==
X-Google-Smtp-Source: AGHT+IEnOUT21KfPlE65EXzoshqynYb9ZYUssV+EC/DIJlTYegfunhYshtSm9OaDU+r5x6EdSrsjag==
X-Received: by 2002:a17:907:d8c:b0:a86:6807:6c34 with SMTP id a640c23a62f3a-a86a52c60fdmr457489266b.39.1724563939075;
        Sat, 24 Aug 2024 22:32:19 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f28f134sm491894966b.52.2024.08.24.22.32.18
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Aug 2024 22:32:18 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5bede548f7cso4020949a12.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 22:32:18 -0700 (PDT)
X-Received: by 2002:a05:6402:3550:b0:5c0:9fca:9352 with SMTP id
 4fb4d7f45d1cf-5c09fca944emr708670a12.36.1724563938103; Sat, 24 Aug 2024
 22:32:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
In-Reply-To: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Aug 2024 17:32:01 +1200
X-Gmail-Original-Message-ID: <CAHk-=wh3eEa-X6wAXpVLrh+i5a3dK0atBDPUf_XhFmhs7pKwZA@mail.gmail.com>
Message-ID: <CAHk-=wh3eEa-X6wAXpVLrh+i5a3dK0atBDPUf_XhFmhs7pKwZA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5 v2
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 25 Aug 2024 at 04:20, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> - rhashtable conversion for vfs inodes
> - rcu_pending, btree key cache conversion
> + nocow deadlock fix
> + fix for new rebalance_work accounting

I'd have preferred to get a proper list. I edited something together.

>       fs/super.c: improve get_tree() error message

Ugh. Please use '%d' instead of '%i'. Yes, yes, we use both, because
some people seem to think that 'i' makes more sense. but %d is
*hugely* more common by over an order of magnitude, and '%i' only
makes sense for sscanf (and then has magic properties that it does
*NOT* have on output).

I've pulled this, but reacted to it because it was to generic vfs code.

            Linus
