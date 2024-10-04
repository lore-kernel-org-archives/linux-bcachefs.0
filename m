Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7001DAC83
	for <linux-bcachefs@vger.kernel.org>; Fri,  4 Oct 2024 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728065729; cv=none; b=O9qsRYKXrKVMUD7fSvOVkAZdZ73ShZ5P37vBUX9LL4tcTmyo7N4jpV7gNTPrESu3igd5VIn5oJcqwinxZbUWIDOzJP6In+px2uzMLoGqakXYPXTL8/8Z563t75RY/azz6X6rFR7K3+40j6Lkin2lKBnegvDrO5sE8stzqbGEl0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728065729; c=relaxed/simple;
	bh=3UwQQ89w1jlQwkQNC6X6XZvFUhguEtIJjixGD+adfi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b4oHaLTf1S4Wo6EN5a8je4Lfpb22EOQDU84kDexojNCPuBcLyqD76952UctXJIwl7TK/aXq3oeYy0GIiAVZ6Fu5z1+KqG2z6kvR9tFqS7/4Yh3drJQvrkdSIlpOsJz3VShw2vh1xbxa2sFpTHjWpXAswt6Kig2P7ZpBCext0eDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=IMDRQgko; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="IMDRQgko"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6e2772f7df9so20199097b3.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 04 Oct 2024 11:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1728065727; x=1728670527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Nl/fJvLy1gro9c4j4uRqIzfbYchCvCeT1u6Esd2ozc=;
        b=IMDRQgkou2yCbc5XK5x1Q65N6uV/y7mPX4Cc2DGY6JqSAVnGdH6YvmEoABMSUCW6Zk
         d99pZExq9ISWyiB+XGS3g7rrPWltReiOGZRuS8FV5wPvT2R5x0cUsOB6QTRgNmLIcK8A
         2IZotsdX4BvuAdUyOzvwsKE4eppjwUrmgJNETcyn+wHPqplgbDybXEaohLK/AF+14v48
         jIxAQkfnMDTnrsZIiuTNL8MtN0Yf8la0+WN62UVuaTnTUgbftvy5pWx1WMmjEL6IyUhU
         34qMnKEAxaOaWSdeKU+7S2ncmyDIPqdoH+V+gSfFwiyRXWvtmBAH748bRuUZ129j/bUK
         lCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728065727; x=1728670527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Nl/fJvLy1gro9c4j4uRqIzfbYchCvCeT1u6Esd2ozc=;
        b=rLriIIUgU02l/x3mYfjqAYuGQkEZ/wx5y/MGCLGoeBlfaYvu/o6vb+muiHmUpEnc4y
         RathZnSFma/tM5oITrucFGR9Xv32rooZRw9AQEfWQFpMEKKiD00hBrAjn0kFDkA7PHH0
         pK37vl0y2slnBig65DkC2l/MxjDbME66MfdsEXJH2EYbBLpFqLPsbWac4ugYCrKlb+/e
         9H+N7zl1K/MFI/sogYhP5xn6aMq1Dfua6KHczv5yAp2S+LMOiupxSD6KV1qRisr0aQvW
         NvVW/bfL8Yrs+HrPfQKsG3C+FlI6+vs2piWsbVyVs4jRcoPOaEXTVYkUZkKQIlTMdCmB
         /xVw==
X-Forwarded-Encrypted: i=1; AJvYcCXYyHK7hXu/Fzx9ZwwFFqr8Jjwq5kww0ErmOd1KV5uUUszKwAgzXGaUQhOz/23HTE3W8o/GWyY14Zrht6rJcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxU7csGvTDpY2rJhKmr6cfnHFIiZ00lNGRNGoKmryGLQeCE1JQL
	eQlsCp6tinkgp2oe2CbrvqOn1w5Na8QBWYeefWIVopjukjZySpFVRxKqOyDeKWGVHc9gn5GT4Bi
	evh9pHaichHrUoHA5kGY6P6kGV8LstuTVLSCR
X-Google-Smtp-Source: AGHT+IFDL2U+AFA8xOQ6lEOVWIMhUrxcSrmU14/lMYge8EW53LmplCLcJ9I9tD7uE5WAzhWwU7Wbzwo1crIZnP2TEoo=
X-Received: by 2002:a05:690c:60c2:b0:6e2:313a:a024 with SMTP id
 00721157ae682-6e2c7296844mr39778377b3.33.1728065726639; Fri, 04 Oct 2024
 11:15:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241003115721.kg2caqgj2xxinnth@quack3> <Zv6J34fwj3vNOrIH@infradead.org>
 <20241003122657.mrqwyc5tzeggrzbt@quack3> <Zv6Qe-9O44g6qnSu@infradead.org>
 <20241003125650.jtkqezmtnzfoysb2@quack3> <Zv6jV40xKIJYuePA@dread.disaster.area>
 <20241003161731.kwveypqzu4bivesv@quack3> <Zv8648YMT10TMXSL@dread.disaster.area>
 <20241004-abgemacht-amortisieren-9d54cca35cab@brauner> <Zv_cLNUpBxpLUe1Q@infradead.org>
 <20241004134906.3yrg5y3hritusmel@quack3>
In-Reply-To: <20241004134906.3yrg5y3hritusmel@quack3>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 4 Oct 2024 14:15:15 -0400
Message-ID: <CAHC9VhQCQaybkmUy7u6xbAhR1HEOWWV_TA5LYPQY6WBct49umQ@mail.gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert sb->s_inodes
 iteration to super_iter_inodes()
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	kent.overstreet@linux.dev, torvalds@linux-foundation.org, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, 
	linux-security-module@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 4, 2024 at 9:49=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> On Fri 04-10-24 05:14:36, Christoph Hellwig wrote:
> > On Fri, Oct 04, 2024 at 09:21:19AM +0200, Christian Brauner wrote:
> > > > But screwing with LSM instructure looks ....  obnoxiously complex
> > > > from the outside...
> > >
> > > Imho, please just focus on the immediate feedback and ignore all the
> > > extra bells and whistles that we could or should do. I prefer all of
> > > that to be done after this series lands.
> >
> > For the LSM mess: absolutely.  For fsnotify it seems like Dave has
> > a good idea to integrate it, and it removes the somewhat awkward
> > need for the reffed flag.  So if that delayed notify idea works out
> > I'd prefer to see that in over the flag.
>
> As I wrote in one of the emails in this (now huge) thread, I'm fine with
> completely dropping that inode->i_refcount check from the
> fsnotify_unmount_inodes(). It made sense when it was called before
> evict_inodes() but after 1edc8eb2e931 ("fs: call fsnotify_sb_delete after
> evict_inodes") the usefulness of this check is rather doubtful. So we can
> drop the awkward flag regardless whether we unify evict_inodes() with
> fsnotify_unmount_inodes() or not. I have no strong preference whether the
> unification happens as part of this patch set or later on so it's up to
> Dave as far as I'm concerned.

I didn't get a chance to look at this thread until just now and I'm
noticing that the email used for Micka=C3=ABl is likely not the best, I'm
adding the email he uses in MAINTAINERS as well as that of G=C3=BCnther
Noack, a designated Landlock reviewer.

Micka=C3=ABl, G=C3=BCnther, the lore link for the full discussion is below:

https://lore.kernel.org/all/Zv5GfY1WS_aaczZM@infradead.org

--=20
paul-moore.com
