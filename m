Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F9F54725
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Mar 2024 21:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366719; cv=none; b=M/UNNxXBDzIR4BzCCwf5iE+Gg/pcWsDdqNWzLkYz6hllJlmPkWMDdRSmwnSoKcuRmKy1NfSGiHchczBDrIhVXtpQ4JjNHn3lTjMzS0YRUBp5nEfnbUSJJVN6dW6CAVKgUpvONdmryKyNlejij83giOde75OHenyXJjOQgpD3NCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366719; c=relaxed/simple;
	bh=hBdvIs25UMavbKrjHvaxFsQ76fNHP6pFUKDpTkxaYns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DHXETIcWsQIhrILTLNn56ES4bsQ42i7l8l/FVHXjGO9HWB7AUSMfqoIPvAe02HaLguDdIAXysk8fvf3DqPK603Hfa151R4G95x7lqhpur27ly/qypQz89ouN0abFhshvbEHocGBMUnLIfP3dj6RiIZBpl+EbnKrhGyaTU6szp80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FK1pQxy1; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FK1pQxy1"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5689d96ba1cso198697a12.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Mar 2024 14:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710366716; x=1710971516; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QeGHZUugSwtILKFvBXuTtAPNxZwHhdb9r9cwhsNH7u8=;
        b=FK1pQxy1FxeNpikCxTJ6sX6jx/F3rXGBlNB5S7Dq/biBbNMb0guHxET1e6b86gXLry
         7DiukqQLtg2sMivqfNRUWt1LSMevWGCJeHAE4d+bY+1oYJwTb3bv0MDgQtpnZXNwGWnV
         sXxL/W52SfIkwvgg4FzrYwMHQH2YCa2gYbQ98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710366716; x=1710971516;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QeGHZUugSwtILKFvBXuTtAPNxZwHhdb9r9cwhsNH7u8=;
        b=mpwzE64wiILWwkWVFlx/U5s0z0x1LbsrHW9Y9FS+XtNPA9NE39cJBK7f3kqnQjBoKA
         ykWD42cLmgwSIa3DLgoJVBrMhbQ2iATPU24kY84ty/8sYtP2nJi0wT7lriOTEJ4Tw3lw
         /XXvS7KDOAqGZhYrVTvzz6/S3Ob7iHu0JsKLD60LuE21HwRsVRmv1C1v0Dwec55xjvsX
         uN5cEvV576ajU1ZtBtPJyg2GywpqOVXriAgmfZ+fOhWLWUhEzpwM31kN839jqh/tkPhX
         tVg+QWu7oLv1n8WA2RbUpe97nHFZlInaJimR1I9onqrTtFJL+0CGvYs1D28TYSJrMslS
         0oBA==
X-Forwarded-Encrypted: i=1; AJvYcCXM5sBVd3OoshjSOiIKwTa7js33zV4DWKCMYBZlqMWbJFUDpEdTMaoPmkeGpyGEovJHirTfGYJ2SQn+uZ4ePqtPEeGajBTL8ccKOP2Mcxw=
X-Gm-Message-State: AOJu0YwfuMZJqqbtTlqrYYAFXvLJKXuHHK1N+sCpRoQLNDAg56NwweOl
	SXIGWFI2wQsTXdofwpDXCK1D6e1SkarF/6UhYgNWN3ayXIE9piRFPWQrmT4Bn/LrynVBKkAX8En
	AgkCaKw==
X-Google-Smtp-Source: AGHT+IHIIQkiv3D1wLOLss1bA0RXkmdevJZFY3yZAb/IGsAdsig/Sq8ZkbzLulJM9iAWKEKTZsrdmQ==
X-Received: by 2002:a05:6402:1f14:b0:567:1263:e31f with SMTP id b20-20020a0564021f1400b005671263e31fmr85483edb.10.1710366715728;
        Wed, 13 Mar 2024 14:51:55 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id m24-20020aa7d358000000b0056729e902f7sm39953edr.56.2024.03.13.14.51.55
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 14:51:55 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a450615d1c4so62715366b.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Mar 2024 14:51:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWeGCFJ46/ob7MEkNyzr2KF7eQz7dsHDIpYQH9chOIf6QEUJy3bygl+fFIjw40MSVyDqLS8+puQznRay+K9pyprnpeabf8XY2mpEYD5HjY=
X-Received: by 2002:a17:906:c0d4:b0:a44:52ec:b9e7 with SMTP id
 bn20-20020a170906c0d400b00a4452ecb9e7mr20310ejb.16.1710366714711; Wed, 13 Mar
 2024 14:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <lfypw4vqq3rkohlh2iwhub3igjopdy26lfforfcjws2dfizk7d@32yk5dnemi4u>
 <CAHk-=wg3djFJMeN3L_zx3P-6eN978Y1JTssxy81RhAbxB==L8Q@mail.gmail.com> <bqlnihgtaxv4gq2k6nah33hq7f3vk73x2sd6mlbdvxln2nbfu6@ypoukdqdqbtb>
In-Reply-To: <bqlnihgtaxv4gq2k6nah33hq7f3vk73x2sd6mlbdvxln2nbfu6@ypoukdqdqbtb>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Mar 2024 14:51:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=whbgtooUErM9bOP2iWimndpkPLaPy1YZmbmHACU07h3Mw@mail.gmail.com>
Message-ID: <CAHk-=whbgtooUErM9bOP2iWimndpkPLaPy1YZmbmHACU07h3Mw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs updates for 6.9
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Mar 2024 at 14:34, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> I liked your MAD suggestion, but the catch was that we need an
> exponentially weighted version,

The code for the weighted version literally doesn't change.

The variance value is different, but the difference between MAD and
standard deviation is basically just a constant factor (which will be
different for different distributions, but so what? Any _particular_
case will have a particular distribution).

So why would a constant factor make _any_ difference for any
exponential weighting?

Anyway, feel free to keep your code in bcachefs.

And maybe xfs even wants to copy that code. I don't care, it seems
stupid, but that's a filesystem choice.

But if we're making it a generic kernel library, it needs to be sane.
Not making people do 64-bit square roots and 128-bit divides just for
a random statistical element.

              Linus
