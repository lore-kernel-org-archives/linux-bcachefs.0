Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB9059174
	for <linux-bcachefs@vger.kernel.org>; Sat, 20 Jan 2024 00:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705708804; cv=none; b=sMQv1faID6MjO8lRzksLqUXo1nXTKL4lp1MIdGG1hvJp+M+5U2nrYJ31UCjIcaWwIz+Ny2klpfiOO5wyzaplpVLqqHhRTGvCSgiPRPM/oQH/n1bz7maLVp3zLciwVhUz5w3LTiCZtVpoKVLT95tq6xOtimrXcaSbZjdRyPfOUD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705708804; c=relaxed/simple;
	bh=2Q6PXCNZrdoKAZHFLazUfCoSdXno+GFbgX4A6oP8KSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aoGUSA5JY8LdLKfyTNDDXgSkdJkpFGYpPhStkxe4G+eSBkYpl+0ZeHlQomG41TRBoWOqYTk9YOB8BsIAZXW6XlBOxjCaC9CojBtXgnKKn+ZM4Vkmja/ChJpzc4653ipTNqaFurLwUEHnJsIetfmalkN9TMU8ErksnowIYg9jnvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZlTm3ICR; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZlTm3ICR"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a2d04888d3dso143268766b.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 16:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705708801; x=1706313601; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eOFYb/RTZy8MO7nlFfaeJozsL+6Jsio6dI6byv2M1AM=;
        b=ZlTm3ICR3ZRy0BgfySAy6axvWXSQt5OZO5B9Ol118+A9siYwKnWX9mSZBp0lJQYN1u
         gdKmE8BpVMknKVWR7HwutEGPUGCvwkrgjdO1g+XtNmV44XC6hsrWavTRRVA+wFhokcbx
         80tY0AyvD/6WbcFCLH/LhmUWjvWdo6B1bIpYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705708801; x=1706313601;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOFYb/RTZy8MO7nlFfaeJozsL+6Jsio6dI6byv2M1AM=;
        b=BAWxkiaJYIUGrllDyGtAN4+IGwxBOQ4QfIOZGD7JRTzm3tgUGsmkWKHlk+REMLPGHX
         JYckOG/3cSq3E96EBPtNoNbkPAWFaMtA+GGDAPPpo154OrRjdBkBF7E5oixrPBDiMxR/
         SXP3pNbmtN39WcFw1HjhTdTZ/om6PXenyp+BfREmJy5tbLWWQLXc8wFy9sg6yi/tij0n
         /IryFThzqS2U1hl0eXugEJC9195fVHjvP31+f+H/rva6U9dU5XI0nTbtNvvwgRBLzbGa
         5kkjkiV2WehYrYS0gQD0adg1lKZf8YwXNA3np7gYAFVVkp/A/OauKXZt6NaQHp5j8NQ8
         zTZQ==
X-Gm-Message-State: AOJu0Yw5VV72O/GnjQLjF1XyvzxWRmSh10r/l2gBqndR0q7l+awFax+M
	8M2oSkCVEeC0WQp+HR+4Z5labmMr/cvfBfqRPXaPjSFtNpv122x685KgjrOxPkfb6HAIzPxKEWh
	aeEJihg==
X-Google-Smtp-Source: AGHT+IG0lfrpN3hfSg3GRoUccxT4cMEfuuAhnImO+9sq4NVW6n4iVJe7NR+FzBsqdwmJqUz3gwyOyA==
X-Received: by 2002:a17:906:2b8a:b0:a28:921e:cc53 with SMTP id m10-20020a1709062b8a00b00a28921ecc53mr228551ejg.54.1705708801249;
        Fri, 19 Jan 2024 16:00:01 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id f4-20020a170906c08400b00a2b10e20292sm10826051ejz.215.2024.01.19.15.59.59
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jan 2024 16:00:00 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-55a035669d5so1623750a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 15:59:59 -0800 (PST)
X-Received: by 2002:a05:6402:228a:b0:559:b648:b954 with SMTP id
 cw10-20020a056402228a00b00559b648b954mr243986edb.47.1705708799556; Fri, 19
 Jan 2024 15:59:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202401191311.B6AA79D@keescook> <CAHk-=wj0j07B=n1Bt4EkDJpN5CBmxMuZhv+nnFdi0DxDVSiZAA@mail.gmail.com>
 <202401191450.CAF805687A@keescook>
In-Reply-To: <202401191450.CAF805687A@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Jan 2024 15:59:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=whu2k-PwHVZS4uKj3kksVUF_Fqzap-YXwnVKeC6S9pBNg@mail.gmail.com>
Message-ID: <CAHk-=whu2k-PwHVZS4uKj3kksVUF_Fqzap-YXwnVKeC6S9pBNg@mail.gmail.com>
Subject: Re: [GIT PULL] strlcpy removal for v6.8-rc1
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Shevchenko <andy.shevchenko@gmail.com>, Andy Whitcroft <apw@canonical.com>, 
	Azeem Shaikh <azeemshaikh38@gmail.com>, Brian Foster <bfoster@redhat.com>, 
	Dwaipayan Ray <dwaipayanray1@gmail.com>, Joe Perches <joe@perches.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jan 2024 at 14:53, Kees Cook <keescook@chromium.org> wrote:
>
> Sorry, I should have called that out in the PR, but the commit itself
> had my rationale for intentionally leaving those in:
>
>     Leave mentions in Documentation (about its deprecation), and in
>     checkpatch.pl (to help migrate host-only tools/ usage).

Hmm. Yeah, I guess the host tooling is an issue, although there
strlcpy makes a lot more sense since I think it exists in various user
space libraries (while strscpy() is kernel-only).

> If you feel like that's not right, I can either respin or send a
> follow-up patch?

Oh, I already took the pull request, I was just reacting to leftovers.
This is not a big deal.

              Linus
