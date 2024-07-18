Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA161448EE
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 22:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721341637; cv=none; b=UjjyV9ZPlbDAThyOVeAlOwVy5DV3nmVpUThT+AfVXmajZu4MZ/4Z49uWGUWlH/Qwbd5h5jgVgRZsoMpUKa7Lpsd/z3asPLw2qvJHDfsa7v6LaAgEs7RDD+Ogh8Dl708Q5wCIbG3JsHpBOT9z/nGdy5TkrClk6LPFPsVu8C46Bc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721341637; c=relaxed/simple;
	bh=zDgU2SeIdYUFXxQD+LyyJxHubKApfobdHZJlnZImCX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GdZdZwtGXoxqc7/y0Xcuu3Z15ggD/VubcYpxV7TYBYGzdYTqhd3hHz+0Q/eAfokiDPY+CVXDk2NL3T+9ZwB+nLJuRqlQ+nDKlOeY/bmM6wD7bvgrI1Js/pcBqthY1ECbA18pqAcajvPmgsR3MIFcQZ48rVeN+n07EGf0IvGYKTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MuCIw8Z7; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MuCIw8Z7"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77d85f7fa3so218424666b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 15:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721341634; x=1721946434; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RHdzQrdk/WoOtHbpZ/K+IpYkj14320RN1AlLLGKZG80=;
        b=MuCIw8Z7fp778RoGRrlwtLWgpqoWzbjS/eOyU9B8ZLT3jM81dubuMrlJlS0yalOA58
         i4u6RnzArO9qfShEkNhoTC28jr46u45PTYQb13XBFrkbe/oIZlATS0ZkTCJn3ZUQRQm7
         V6z5zg0syG/jCgGdhh4ydAaJTtI1O/60IjBOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721341634; x=1721946434;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RHdzQrdk/WoOtHbpZ/K+IpYkj14320RN1AlLLGKZG80=;
        b=KAnKvQnuO1V5C5I6YO62BqgnqJX3mqKaayPesf/9afLskozaUu85Hd6wMLnewVPkYa
         AsIyFKouraScp+NhE0ocyNl3ZvYrl286kBWsr2UorwnHIAqpTLEhE/Ic7hrwvA+Q5k1U
         JrsqbgarlZW90LnE2kk2urO2dJfP/dW8XbOZ/cQLi1wYVA8IQgmrmYrjRwgI4JkySkRx
         SqMc51cV8q2eFXCHV7PmSiMI+0TFTr29+hfOQ7/0SALrnvCumNQFD89pX+nqTPhCHwUc
         EKED/QV26Ro5fykKcCMEpv4IMec/QWOMUdK+CrRCVWjwXjM9jmwdBQpPVU4W26kSP919
         P3jA==
X-Forwarded-Encrypted: i=1; AJvYcCWqIVktOho0skImhbVViyFea1KGyW8QDMw5OORo9n3Lgec4WYgxruCV8GuUpy9181AG4nmHyA7f+03ET/pg/g/PGrCmzFWkG2ld945hyeA=
X-Gm-Message-State: AOJu0YxDJQ9+qjX+NlykVksJ7astNQXaA8hYcVVpMAbWYxrw6l6WKadQ
	BTq3ARTDQKVluTYF9Wa1vZJKyX2PtXOdC/dQz3DTJcDAKeTBbZnSKSeDYcwX62NbnBDiJpPBnlD
	Fnz7XDQ==
X-Google-Smtp-Source: AGHT+IGZWhz17be6ABQB/ZXNRyYFbmlgisnmnY2uZiW9IAdxYcRU8TIetfV0kzcsWTMkvVGV0LLbIw==
X-Received: by 2002:a17:906:2287:b0:a72:4207:479b with SMTP id a640c23a62f3a-a7a0f0c6ca4mr386336166b.5.1721341633617;
        Thu, 18 Jul 2024 15:27:13 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a33ac786csm9552766b.54.2024.07.18.15.27.12
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 15:27:13 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5a2ffc34722so104319a12.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 15:27:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVBlICernqQ31m/X21TgHkmE6CZRgXgj3vB+2qcGDwu2k5dWdFH1IN/RLp25J7J+y0rP8Ys4l79jrGqATf4kvp0MQyDa9yt4APe4Oag1dU=
X-Received: by 2002:a05:6402:358f:b0:57d:4692:ba54 with SMTP id
 4fb4d7f45d1cf-5a2d168127emr524937a12.6.1721341632616; Thu, 18 Jul 2024
 15:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <r75jqqdjp24gikil2l26wwtxdxvqxpgfaixb2rqmuyzxnbhseq@6k34emck64hv>
 <CAHk-=wigjHuE2OPyuT6GK66BcQSAukSp0sm8vYvVJeB7+V+ecQ@mail.gmail.com>
 <5ypgzehnp2b3z2e5qfu2ezdtyk4dc4gnlvme54hm77aypl3flj@xlpjs7dbmkwu>
 <CAHk-=wgzMxdCRi9Fqhq2Si+HzyKgWEvMupq=Q-QRQ1xgD_7n=Q@mail.gmail.com> <4l32ehljkxjavy3d2lwegx3adec25apko3v355tnlnxhrs43r4@efhplbikcoqs>
In-Reply-To: <4l32ehljkxjavy3d2lwegx3adec25apko3v355tnlnxhrs43r4@efhplbikcoqs>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Jul 2024 15:26:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgmXpbFKmmk53c8Um7naf-AAwOGU-26RTHiafbGbostCA@mail.gmail.com>
Message-ID: <CAHk-=wgmXpbFKmmk53c8Um7naf-AAwOGU-26RTHiafbGbostCA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.11
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Waiman Long <longman@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jul 2024 at 15:24, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Sorry, I must not have been clear. My master branch is a) not where I do
> development, and b) not not a branch that I will be sending to you -
> that's simply the primary branch I publish for people testing the latest
> bcachefs code.
>
> So: master will now be just updated by a hook on the server whenever I
> update for-next.

Oh, ok, then that's fine.

> > Now, if you want to do _additional_ testing along the lines of "what
> > happens with my branch and Linus' latest" then that is ok - but that
> > should be something you see as completely separate from testing your
> > own work.
>
> Yes, that's exactly what I was describing.

Good, sounds like we're on the same page.

            Linus
