Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB09111A8
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721242405; cv=none; b=MnYv1nVmo4ySzebViPAqfoxnT6xyu/dqYCR2AElVmPu4muzSlW+I9hdsuq/KEubOE3jSVeIZouz5XDdRA3eS6YnKvqPbE03HGQW97kXJDSbtLPzd5zxKi8WWgfGFiMp3OIoLxm9RRR8dGg5U1wLy5rgCUq1JQPFM9bBwYeIfgqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721242405; c=relaxed/simple;
	bh=Hv0Lv3vxMdF9EUCXQDjKALNMNYcXui+F13OJ3xjzVGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DCcOLHmzlvOswA7N6XpvA8q6ONfWtvGSWu00arI8FEcDaR+wOJDHZrfv6zpD8W1dBWc03j7oIrS7/pCjIevSGeM8baFRBLts5U2QsO9+FzvSCKMU5bQMr0Z1KGLYMoXg954UkLSg1m5NOEqAlEQu3CkKUu62Lz2rExpAE8mcxfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SJYfNj3b; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SJYfNj3b"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77c0b42a8fso196547966b.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 11:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721242402; x=1721847202; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tMynJxsAoEfgNtqBQWK8foysn8xndosdDwSjU5qP3r8=;
        b=SJYfNj3bK2nMbAHHicYXGHdWyXEcpc4zqzF8MyGTLwTz3diTg1b1BL/K8snXzV5SQA
         L+mi1QyfjbDxhx6/Hesf6rYoupi1zGslPGZO2XLvWsziU3jtZe0OLoZ49RtV1dpTO8uL
         Zu+1V2+DgtUbKgZzVFWTUlfvExGoRSM+MLE+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721242402; x=1721847202;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMynJxsAoEfgNtqBQWK8foysn8xndosdDwSjU5qP3r8=;
        b=Pfqb7MyZwy8DzaDJW3GKTJVM8Ae1UNENRcfU8jYEyWzKf6mwt3JrCYXVlsSKdfydfa
         aU0Q+84TlfRntJwpk9k0oiaRlH8uYOzGArkoKex4ZCVCTXG/Ve/fyLk8k8Ly+r/tLlql
         Nn/lJ4FlxCk6XOQWUrPWqx03W3aewyaTKAEN5XjyPfsDh4elWyWpmpeeM5dkQKm9lasq
         YRKouJHezMxyPjp+cVDQWAfWontpZmw7JqyN6Ddv88unWII8j/Cx81Ti0uIPHy8vZsAC
         Vm1BBGO1KG7idfrWFjB+Hp/7eq3+Mabp31blAZ6oOBQVtN3M13oIkwz8mUJrkh9VD2yb
         3zUw==
X-Gm-Message-State: AOJu0Yxxvch1gsmv+RNeVbJr8NJaYJn0EhwR4IaYz6keNfzMG5pwdll5
	QqYeo7ahsRACE8Ke8UN1p3d+vav6WOYKt/AnCgIeYuQFM8qsYLogbwJ5qVh/eYX2DG+z80mrasb
	tgrIgmA==
X-Google-Smtp-Source: AGHT+IG367o2PItBITF7rzAk8TPhwBC7Vabkq88jhpGKBZEzL52gqe5Qb60NXYJzXnYkfd4BOVSI7g==
X-Received: by 2002:a17:906:198e:b0:a6f:20e0:1d1a with SMTP id a640c23a62f3a-a7a0f7777e3mr53978866b.33.1721242401758;
        Wed, 17 Jul 2024 11:53:21 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc820d52sm472058566b.214.2024.07.17.11.53.21
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 11:53:21 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-595856e2336so2111139a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 11:53:21 -0700 (PDT)
X-Received: by 2002:a05:6402:27c7:b0:58c:36e:51bf with SMTP id
 4fb4d7f45d1cf-5a1557cd64bmr545038a12.3.1721242400692; Wed, 17 Jul 2024
 11:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <r75jqqdjp24gikil2l26wwtxdxvqxpgfaixb2rqmuyzxnbhseq@6k34emck64hv>
In-Reply-To: <r75jqqdjp24gikil2l26wwtxdxvqxpgfaixb2rqmuyzxnbhseq@6k34emck64hv>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Jul 2024 11:53:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wigjHuE2OPyuT6GK66BcQSAukSp0sm8vYvVJeB7+V+ecQ@mail.gmail.com>
Message-ID: <CAHk-=wigjHuE2OPyuT6GK66BcQSAukSp0sm8vYvVJeB7+V+ecQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.11
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 14 Jul 2024 at 18:26, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Hi Linus - another opossum for the posse:

(The kernel naming tends to be related to some random event, in this
case we had a family of opossums under our shed for a couple of
months)

> bcachefs changes for 6.11-rc1

As Stephen pointed out, all of this seems to have been rebased
basically as the merge window opened, so if it was in linux-next, I
certainly can't easily validate it without having to compare patch ids
etc. DON'T DO THIS.

Also, the changes to outside fs/bcachefs had questions that weren't answered.

So I'm just dropping this all for now.

            Linus
