Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8873A1B813
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 22:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728167718; cv=none; b=F6AS7zdRb3X8t4vK5it5GoXWwyklWB6pUyzz+Oo/v3DNwId6j7JyE3IBJQkTeJZz2iPSP/zWEzMIb373gVllXxtc7AyZPl+zk6Ifq6FWvDFZ0uXtcOPnzKknTVCiOd55Q0cC1N0j+eTNm9u73sK9qS+dvHStwze9grM8HTFtuHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728167718; c=relaxed/simple;
	bh=b+AWARzu8Thd5FUOfHILFpuGGWUetHMUNgu/HGN6+q0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LJz+vxh5iRDs90yMf1ZO4rhLbdZ3M+MWxmZ+zZ0gm5PmUuI0BRM5iYW9VSf5gnWmnKuByObV6pCfZYdpvtARhWvdS2cIPUNWVDtGnZ5K4dizBx8rGtrlqqjXgAafG+RdXLzMH3zhywYxU9rakmC0uNEChjUNJtGblshYjQrpLaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfSfr+eS; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfSfr+eS"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37ce14ab7eeso2776123f8f.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Oct 2024 15:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728167715; x=1728772515; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HQI/L/s5ZU/jfp6TpSnEQe99W437IW863hAyq7v8534=;
        b=XfSfr+eSiEQ/Qspd1oBC0qCBq8NW5phC31rDtzKlkc3DzCE+K/Ifbhv2E3iwOQtpiQ
         imsIxe2Jsh64N+3Icxy7TBghfnNo2iFsc67AMfiDhV7nbqCsAR/GxVb/2q7fio5+Uzn7
         J5rfFIj4lF5u5b5YwAWU3v7aD6RMPm4ANn0iY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728167715; x=1728772515;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQI/L/s5ZU/jfp6TpSnEQe99W437IW863hAyq7v8534=;
        b=uw+21c8jPo7UCqJ9RL/1H6x9e9E2KMwWEyqpEUE09T51pDYYxGg0NAbIgCUfD2zJx+
         UEoULdEq35T4qYDQTxlGvSv9BuXffUYGO1JApDw3oHXwI7+FBar+bcPwSFrna9JOTxff
         Nt8HGkQP5KzlmTNOhfWpszJt8paMkkB2S3qWp70IrmblyFpMHpJVOnlZ/hrDip7feZ1a
         4W8ft2TToYRAFOYhIO/muEV8YbPG5LzzaMc8cIokntw4BIEPowmOggvMbpaPdW6qPGkL
         4FVPYejR9R1CXRzYYCFz0lLEaD92K/KrRg3rMSflzpcipMe42O+PJ49rhxPYZdFu933K
         OOdw==
X-Gm-Message-State: AOJu0YyOlUbuD+/2l5138LN6avqv5y3oHs7sfd3r9rAIZxjDvlZp/P+z
	44TooZGs+eawRFrh2lWxcdvy14TH8nwtxQN1nt9W203cubX7Ow5RDC1lEiJtis1oKQPFQenetZB
	0QG3z5A==
X-Google-Smtp-Source: AGHT+IEmPq9q3dtM2lqyhpG+SaO9f28wlqnP5egKxtk+TdHxmNI84C9pfw345A6gCUdjy+daaUj7bA==
X-Received: by 2002:adf:cd06:0:b0:37c:d270:e5cf with SMTP id ffacd0b85a97d-37d0e779b4emr5978603f8f.33.1728167714524;
        Sat, 05 Oct 2024 15:35:14 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a992e5bbc51sm182990166b.40.2024.10.05.15.35.13
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Oct 2024 15:35:13 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c46c2bf490so1982731a12.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Oct 2024 15:35:13 -0700 (PDT)
X-Received: by 2002:a05:6402:27c9:b0:5c8:9529:1b59 with SMTP id
 4fb4d7f45d1cf-5c8d2e48716mr7992911a12.20.1728167713376; Sat, 05 Oct 2024
 15:35:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cphtxla2se4gavql3re5xju7mqxld4rp6q4wbqephb6by5ibfa@5myddcaxerpb>
In-Reply-To: <cphtxla2se4gavql3re5xju7mqxld4rp6q4wbqephb6by5ibfa@5myddcaxerpb>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Oct 2024 15:34:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjit-1ETRxCBrQAw49AUcE5scEM5O++M=793bDWnQktmw@mail.gmail.com>
Message-ID: <CAHk-=wjit-1ETRxCBrQAw49AUcE5scEM5O++M=793bDWnQktmw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.12-rc2
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 5 Oct 2024 at 11:35, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Several more filesystems repaired, thank you to the users who have been
> providing testing. The snapshots + unlinked fixes on top of this are
> posted here:

I'm getting really fed up here Kent.

These have commit times from last night. Which makes me wonder how
much testing they got.

And before you start whining - again - about how you are fixing bugs,
let me remind you about the build failures you had on big-endian
machines because your patches had gotten ZERO testing outside your
tree.

That was just last week, and I'm getting the strong feeling that
absolutely nothing was learnt from the experience.

I have pulled this, but I searched for a couple of the commit messages
on the lists, and found *nothing* (ok, I found your pull request,
which obviously mentioned the first line of the commit messages).

I'm seriously thinking about just stopping pulling from you, because I
simply don't see you improving on your model. If you want to have an
experimental tree, you can damn well have one outside the mainline
kernel. I've told you before, and nothing seems to really make you
understand.

I was hoping and expecting that bcachefs being mainlined would
actually help development.  It has not. You're still basically the
only developer, there's no real sign that that will change, and you
seem to feel like sending me untested stuff that nobody else has ever
seen the day before the next rc release is just fine.

You're a smart person. I feel like I've given you enough hints. Why
don't you sit back and think about it, and let's make it clear: you
have exactly two choices here:

 (a) play better with others

 (b) take your toy and go home

Those are the choices.

                Linus
