Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6AC2141C6
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Oct 2024 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727898576; cv=none; b=Hd+hOjPL8WSgCcCEt0DQlwUpbptA2Q0H82KH3f0KGZBlAHFeCh0D+MhTB1tIzs9shmRLjkDFuC3QEjrkfV8FgPU/4NX7+LEviD86RIofjpAV4L3dtZV4SGKq+Jd2HWLgXRyyv8Ta6mHnfsQige2kyrRH5iGuQ1X2eM1rTHbiUSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727898576; c=relaxed/simple;
	bh=RnO6uv8HRi8ObI+RtKyEOrQ+9Cm9ALlIkZ6dw4lENc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DYHSLDA9TnP96fTC2Rue9H4snMguCutmYuUS2F3K2n5fYiWmYVWgeZSBOY4lbJIPonJLNS/Kh5ht/Xdhl1gQCSNIliz7N5KDKn774DXcZQ9Kg5fpelvP/+mhgJlKot49cmjzjbYit3NCMy59DDzUfuof2J3vA7/0MXbcn63LxVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TtB3ZKLF; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TtB3ZKLF"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-37ce8458ae3so138681f8f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 12:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727898572; x=1728503372; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dzdt4GqtyHMMk9bZurHX/Y4rm7tRkS7KSsld1cCXB3k=;
        b=TtB3ZKLFBiF+fpY9r09+zyH+7q+AMG/AsF2RW+nuPatUtcyhwj3ykSh56XFUFUUppE
         HwYnap2hpv+Vwxta+od8h2VOZ2ZNRiSwkY6BsaefG4ad9XN5VGjjp65+TVxPfo7GXQy5
         vl8Yq5NSPSdMZz3Nt3uoHfK6iqiu2AWzRi854=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727898572; x=1728503372;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dzdt4GqtyHMMk9bZurHX/Y4rm7tRkS7KSsld1cCXB3k=;
        b=fFEgHmNToRKAMYDbTDGl7k0T/K1DY+hRcgZbEOziPnX19ienIIANPo3jF3+hgqEj+t
         YFCbiTZG8+br+S/GIMXVJFJTMjIlTQyK8JWXXnXj2/5bEsXcdFaGgqC9o62GWNCkbZhx
         8s2mlr+TgoTdttQlhhkFUUefcqdJIVGwKXhhtAorYJOHjQomdPhl1oK3potuH1kMu3HI
         +1jmV2jGq9oIeqLmFV4xIAwGczUNAqq1LoxPeEdS4/2SK+xRd4gydUUqDOESd1765AOZ
         WDMuUF6+HSZEO/cAvXy9uGJs7dC8L6Dw9YTafd8RgZZDndwpirKMe+LhsZj03SjGmZcZ
         gtTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoQLMRiu5XHcrUlw/5S/ASJbtAzjzm2AQmF0S7cCvUelPdjUtEzr064nExJQLOEiY+ZA1Wg1E3tMTk8lBxcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1Ia2LzMfsN6kKZvgasqdOCqgUpgOONAX9pGE63C3Zm4k2yi8G
	Xy42R/Na9b375O4e+5zIRQyVBvyOs/lcmC+IXwYz1XJJcKdfyKlavGL3IqFBTBsaHazUyO0J8aB
	o2DqcFA==
X-Google-Smtp-Source: AGHT+IHgAWX3qRicPWA6wsysNPpmjPQlQap/DZZv89soQrKaVtKglSFf7UtSUORkHvtuKhkZhFHShg==
X-Received: by 2002:adf:e885:0:b0:37c:cc05:7a56 with SMTP id ffacd0b85a97d-37cfb8b565fmr3466218f8f.10.1727898572405;
        Wed, 02 Oct 2024 12:49:32 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c27ecfedsm911547666b.95.2024.10.02.12.49.30
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 12:49:30 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-37ce14ab7eeso155932f8f.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 12:49:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVqP5S2qHKpCDAcaBVk+Bwpse8KzFYSzlyAWcZ1Tx6Cv5HJoZtba2Xd0oUP4O2+cmM4mQewgxN4KbibUtL/8A==@vger.kernel.org
X-Received: by 2002:adf:e712:0:b0:37c:d1c6:7e45 with SMTP id
 ffacd0b85a97d-37cfba0a614mr3298213f8f.40.1727898570159; Wed, 02 Oct 2024
 12:49:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002014017.3801899-1-david@fromorbit.com> <20241002-lethargisch-hypnose-fd06ae7a0977@brauner>
 <Zv098heGHOtGfw1R@dread.disaster.area>
In-Reply-To: <Zv098heGHOtGfw1R@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Oct 2024 12:49:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgBqi+1YjH=-AiSDqx8p0uA6yGZ=HmMKtkGC3Ey=OhXhw@mail.gmail.com>
Message-ID: <CAHk-=wgBqi+1YjH=-AiSDqx8p0uA6yGZ=HmMKtkGC3Ey=OhXhw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] vfs: improving inode cache iteration scalability
To: Dave Chinner <david@fromorbit.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	kent.overstreet@linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Oct 2024 at 05:35, Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Oct 02, 2024 at 12:00:01PM +0200, Christian Brauner wrote:
>
> > I don't have big conceptual issues with the series otherwise. The only
> > thing that makes me a bit uneasy is that we are now providing an api
> > that may encourage filesystems to do their own inode caching even if
> > they don't really have a need for it just because it's there.  So really
> > a way that would've solved this issue generically would have been my
> > preference.
>
> Well, that's the problem, isn't it? :/
>
> There really isn't a good generic solution for global list access
> and management.  The dlist stuff kinda works, but it still has
> significant overhead and doesn't get rid of spinlock contention
> completely because of the lack of locality between list add and
> remove operations.

I much prefer the approach taken in your patch series, to let the
filesystem own the inode list and keeping the old model as the
"default list".

In many ways, that is how *most* of the VFS layer works - it exposes
helper functions that the filesystems can use (and most do), but
doesn't force them.

Yes, the VFS layer does force some things - you can't avoid using
dentries, for example, because that's literally how the VFS layer
deals with filenames (and things like mounting etc). And honestly, the
VFS layer does a better job of filename caching than any filesystem
really can do, and with the whole UNIX mount model, filenames
fundamentally cross filesystem boundaries anyway.

But clearly the VFS layer inode list handling isn't the best it can
be, and unless we can fix that in some fundamental way (and I don't
love the "let's use crazy lists instead of a simple one" models) I do
think that just letting filesystems do their own thing if they have
something better is a good model.

That's how we deal with all the basic IO, after all. The VFS layer has
lots of support routines, but filesystems don't *have* to use things
like generic_file_read_iter() and friends.

Yes, most filesystems do use generic_file_read_iter() in some form or
other (sometimes raw, sometimes wrapped with filesystem logic),
because it fits their model, it's convenient, and it handles all the
normal stuff well, but you don't *have* to use it if you have special
needs.

Taking that approach to the inode caching sounds sane to me, and I
generally like Dave's series. It looks like an improvement to me.

              Linus
