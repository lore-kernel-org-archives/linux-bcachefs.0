Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B42233F9
	for <linux-bcachefs@vger.kernel.org>; Sun,  6 Oct 2024 00:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728173692; cv=none; b=NiUDBdqH9txVMeP4sICFfZNYh509eVj3RtuWDzBYei0HRd3i7pW85rrH5JidcG7Lf4b+3xKMyCN6sRrU2OYw+S75t7h4C0jfQ9PGmAiiDDh4pLuJOfv3if61quoU2MsVhzWHo+jq/eIW450iWxfHm2aPMc8rrBtwReU22t53U0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728173692; c=relaxed/simple;
	bh=HgtCN7iIuMmkaNV3I4PdNrx0uSYLvra8kQ82Jy6qi+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iAfrrAmt4tOE7zURl9ir3zesQ/LZFOoSTa88I/cveSTj7bWGSpYxbVDuyKK0qUOnyLogZkgcRqX8E4SOkyKDnhFFcs5AIkNb5vMFnePDpE/+fiI/4fPG1VDOEXdUl0j8XGoKwRF0LsBQX9YVzBRiVPgRK2AHkNiLK3xio0OPoPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dC4iCoVg; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dC4iCoVg"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c88e6926e5so3628781a12.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Oct 2024 17:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728173689; x=1728778489; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nzL6PAghOW3KzpclFbijO5KDwmQqxWPsUEDBX6EEH4c=;
        b=dC4iCoVgo4hvZqT/yL64jw6Fs+Cq8iZu79PEdu1Ph8fdTB/mA6eAX5dBW8aidmdxFn
         h0LivbzR5kkgR7AEN8YZtPlxwI+kRahhTpnmJWEWYa52I0ua3OMtGfUFFpdNgQU1gDza
         ajoqgHQfLKWwKzWY0V1dsUoUWSTjbkI4UwXQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728173689; x=1728778489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nzL6PAghOW3KzpclFbijO5KDwmQqxWPsUEDBX6EEH4c=;
        b=Rmlf98/E+om1r9Jwgp955RIjBkHmvfLFxu5uw9kBC9KJNhgcaXBxBh6bfnmA/TFJMU
         Q76SS5mnGNRwxwtKNnbfVi0ly64bpzyOHGV5chwkcWlfbR27nmfY/PMqskQeQ3MgFadr
         3jxO7fshBlIuGjaVZS2uPD51nY969yfP3DiSQ1gq9KVTrd1z9ubvJiCpqM94zWjF9ccJ
         lMMVkWHLmDXUI1j+1qmnRViA36j+kW+JQmsc7hH9WsOQCau3b1BqXZVTqnVJl4mItZzO
         zxNpTWB8qcqxg99EbqaO/o/z5dLIz65cqUlwNMcPnZ/znMy7OHe2tdvdQUG8b4+ihdOG
         RrAA==
X-Gm-Message-State: AOJu0YyV3uKLw2KjVaNW306qdbyfqeNNwrgKpDTJlR1plQSKRrHJTCwr
	zTHDDyovsnlK24lvR7FaqJI6/XY/cEefE9SPIeTIA4b6M1l8aAZylLKEq9PH1WEsvxqA6Tlyrq1
	vTmMv9Q==
X-Google-Smtp-Source: AGHT+IHAt8LX9Sgsf7g7YSjU56670Vtx5uatsd5SqfjgCGu03WOi3ZWAhcPTEnebwDp85F/b/BD1lQ==
X-Received: by 2002:a17:907:7e8d:b0:a86:ac91:a571 with SMTP id a640c23a62f3a-a991c072851mr810992266b.56.1728173688670;
        Sat, 05 Oct 2024 17:14:48 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a992e5c8f02sm191198466b.33.2024.10.05.17.14.47
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Oct 2024 17:14:47 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c89bdb9019so3937196a12.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Oct 2024 17:14:47 -0700 (PDT)
X-Received: by 2002:a17:907:c7cf:b0:a8d:286f:7b5c with SMTP id
 a640c23a62f3a-a991bd71ec5mr611797066b.27.1728173687316; Sat, 05 Oct 2024
 17:14:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cphtxla2se4gavql3re5xju7mqxld4rp6q4wbqephb6by5ibfa@5myddcaxerpb>
 <CAHk-=wjit-1ETRxCBrQAw49AUcE5scEM5O++M=793bDWnQktmw@mail.gmail.com>
 <x7w7lr3yniqrgcuy7vzor5busql2cglirhput67pjk6gtxtbfc@ghb46xdnjvgw>
 <CAHk-=wi-nKcOEnvX3RX+ovpsC4GvsHz1f6iZ5ZeD-34wiWvPgA@mail.gmail.com> <e3qmolajxidrxkuizuheumydigvzi7qwplggpd2mm2cxwxxzvr@5nkt3ylphmtl>
In-Reply-To: <e3qmolajxidrxkuizuheumydigvzi7qwplggpd2mm2cxwxxzvr@5nkt3ylphmtl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Oct 2024 17:14:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjns3i5bm++338SrfJhrDUt6wyzvUPMLrEvMZan5ezmxQ@mail.gmail.com>
Message-ID: <CAHk-=wjns3i5bm++338SrfJhrDUt6wyzvUPMLrEvMZan5ezmxQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.12-rc2
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 5 Oct 2024 at 16:41, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> If what you want is patches appearing on the list, I'm not unwilling to
> make that change.

I want you to WORK WITH OTHERS. Including me - which means working
with the rules and processes we have in place.

Making the argument that we didn't have those rules twenty years ago
is just stupid.  We have them NOW, because we learnt better. You don't
get to say "look, you didn't have rules 20 years ago, so why should I
have them now?"

Patches appearing on the list is not some kind of sufficient thing.
It's the absolute minimal requirement. The fact that absolutely *NONE*
of the patches in your pull request showed up when I searched just
means that you clearly didn't even attempt to have others involved
(ok, I probably only searched for half of them and then I gave up in
disgust).

We literally had a bcachefs build failure last week. It showed up
pretty much immediately after I pulled your tree. And because you sent
in the bcachefs "fixes" with the bug the day before I cut rc1, we
ended up with a broken rc1.

And hey, mistakes happen. But when the *SAME* absolute disregard for
testing happens the very next weekend, do you really expect me to be
happy about it?

It's this complete disregard for anybody else that I find problematic.
You don't even try to get other developers involved, or follow
upstream rules.

And then you don't seem to even understand why I then complain.

In fact, you in the next email say:

> If you're so convinced you know best, I invite you to start writing your
> own filesystem. Go for it.

Not at all. I'm not interested in creating another bcachefs.

I'm contemplating just removing bcachefs entirely from the mainline
tree. Because you show again and again that you have no interest in
trying to make mainline work.

You can do it out of mainline. You did it for a decade, and that
didn't cause problems. I thought it would be better if it finally got
mainlined, but by all your actions you seem to really want to just
play in your own sandbox and not involve anybody else.

So if this is just your project and nobody else is expected to
participate, and you don't care about the fact that you break the
mainline build, why the hell did you want to be in the mainline tree
in the first place?

                   Linus
