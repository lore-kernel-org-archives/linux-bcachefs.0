Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6111386BF
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 22:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721340388; cv=none; b=EWvW9cWPjWJsS5LI3YM9CGl3p/6cjTERfTD5eRxb29ls43JYYtIFpYQqS/tCWXNuYy2xAwxLshH0OCO4DoGmUgGMBg465JM7pkSuVg7t2LJfILrTM8k33w41UiSUY98OGceuNo2pM8P4dhhJbouK9RbyMaUzuv/PEoiISzVixBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721340388; c=relaxed/simple;
	bh=acccNmbkTNt4D6rXrxsctZAkrYQrsQo0yHnBb7YJ3+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UzWEd8iAXEFb8VVzoNNcmuXDWglgBSjdgPnAeUmN0kYNLy6Xnpy0c9N6V84y4OqAKCyE/tINedMit+dOE3rZIT9P595Q0ufKLywDTTAJ9i2YsgEgGYZpUVQ0KNBLwZuXKS7LU/3b8DrA0o+i0/qo05SKn24GMID/C49VuO8kcJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdHrzVwA; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdHrzVwA"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so559811a12.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 15:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721340385; x=1721945185; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WnQ/kRx27gXXnNgCG0Fp9DDc+PIy4XrGs0yssbc7gKs=;
        b=HdHrzVwAy17E6TwqlxmVqSsYhNZh9yw7O+lgvxFxD4E1JZ/tIU5s0eWbbJqCcB1Zln
         9kEbvUu8FnHepPNrILjqneljkEAAMq0pooT99SoQnTNebl10kfJTunbsdcg8SLVzezLC
         XLlA8KNi03qoVRif/APjW9LRmKq1X5SVkG7/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721340385; x=1721945185;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WnQ/kRx27gXXnNgCG0Fp9DDc+PIy4XrGs0yssbc7gKs=;
        b=ZG7jPqlNM8MMIWZCut+V6xHsYvJC/HBg1Ym8EE0DlI4MSQoPoKR9PVPQjS6qIRgImJ
         bInAkD7WdN537kMZGjnpdt8gctSVKeYGfkg6NGqlH0lV3JFiW2xVN/2Z5W5dk1TOmAdF
         v960NwE92VesJar/h4MwvLQYATbUU27Kb0/DrLapEEl63/ehU8lJZSIq1abQylFN2fs8
         t7RCm56u6ezGgVIFqxIq4XWgwO3t9pTVFPWZrmnNt1usN+UyG8N5yqIMVAkYWj0UTzCz
         JPpr0N2lcBl5g6AAzdSNOgGdTnUo+KP7PhIKmT+dyK7KPwOFS6D5fsTHuGiPVVAegjnu
         fzhw==
X-Forwarded-Encrypted: i=1; AJvYcCWxPr6FjAkymG3E/RsFEFu+2ZzQHlV7tayyKxAIKlCEbp2F6wKfAEzhapsx6Uyr7F5So1JdLH8k0OAFKo/pjXEmv382UBkHTTIY2WSr5lM=
X-Gm-Message-State: AOJu0YxE+auV/LsUorQxTfXE+AsE+K/s3stfxDWZEXkok2ZuccEU1+/0
	Lqjv0DEZrKqSMPzfJY9aEP0/tQM6qghmsVSZ4QPjpypK3RaCZXkJmi5QPDzkay18sXu1G7TZO+f
	x1akmUw==
X-Google-Smtp-Source: AGHT+IEnKVXCXA6KAK7wfrcmiySQfkOPO0AQkz71B9FqFax0MFPASBOcjutT79NAaURlKgBjv/NMUg==
X-Received: by 2002:a17:906:7741:b0:a77:db39:cc04 with SMTP id a640c23a62f3a-a7a0f0ffe1fmr391527866b.11.1721340385050;
        Thu, 18 Jul 2024 15:06:25 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a33a8243bsm7096066b.35.2024.07.18.15.06.24
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 15:06:24 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so559778a12.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 15:06:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUFmxoq4aVfp1FJjNQSLtHoA9SD0aunK3au4iaMrCgH3PLRnTpLi6leS7kZSy1YBwfKGtVuynFHG42ZaXJma31r9wgK1hjcG750ErW7VNM=
X-Received: by 2002:a50:d481:0:b0:594:4d7e:1b6b with SMTP id
 4fb4d7f45d1cf-5a2caf4eebamr568069a12.5.1721340384115; Thu, 18 Jul 2024
 15:06:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <r75jqqdjp24gikil2l26wwtxdxvqxpgfaixb2rqmuyzxnbhseq@6k34emck64hv>
 <CAHk-=wigjHuE2OPyuT6GK66BcQSAukSp0sm8vYvVJeB7+V+ecQ@mail.gmail.com> <5ypgzehnp2b3z2e5qfu2ezdtyk4dc4gnlvme54hm77aypl3flj@xlpjs7dbmkwu>
In-Reply-To: <5ypgzehnp2b3z2e5qfu2ezdtyk4dc4gnlvme54hm77aypl3flj@xlpjs7dbmkwu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Jul 2024 15:06:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgzMxdCRi9Fqhq2Si+HzyKgWEvMupq=Q-QRQ1xgD_7n=Q@mail.gmail.com>
Message-ID: <CAHk-=wgzMxdCRi9Fqhq2Si+HzyKgWEvMupq=Q-QRQ1xgD_7n=Q@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.11
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Waiman Long <longman@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jul 2024 at 14:21, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> But my master branch (previously the same as for-next) will now be
> for-next merged with the latest tag from your tree, and I may do
> similarly for bcachefs-for-upstream if it's needed.

No. No back-merges. We actually have documentation about this, so I
won't repeat the hundreds of emails I've sent out:

  Documentation/maintainer/rebasing-and-merging.rst

But the gist of it (well, one of them) is that you should keep your
branch *YOUR* branch, not think that you should merge in other peoples
work into it (or rebase it on top of random work by other developers).

There are valid reasons to rebase, but they are balanced against some
VERY valid reasons not to do it, so if you have to rebase, make sure
those reasons really outweigh the reasons not to.

And don't do it just before a pull request - and if there is some
catastrophic event that caused a recent rebase, let me know in the
pull request.

> As a bonus, this means the testing automation will now be automatically
> testing my branch + your latest

No. That's what linux-next is about - it does integration testing.

Your development branch IS NOT FOR TESTING OTHER RANDOM THINGS.

You are actively making things worse if you do: you should worry about
YOUR code, not about all the random other things going on.

Now, if you want to do _additional_ testing along the lines of "what
happens with my branch and Linus' latest" then that is ok - but that
should be something you see as completely separate from testing your
own work.

IOW, you can certainly wear "multiple hats" - your bcachefs developer
hat that worries about your bcachefs branch, and if you want to *also*
do some integration testing, go right ahead and have another
"integration testing branch" that you then test separately.

But I don't want your integration path. When I get a bcachefs pull, I
want the *bcachefs* side to be solid and tested. Not something else.

So by all means keep multiple branches for different reasons. If you
think you have users that need to test some integration branch (which
honestly sounds like a horrible idea, but you do you), make them a
branch too if you really want to. But again, that has NOTHING to do
with bcachefs development, and you should not mix that up with what
you send me.

                  Linus
