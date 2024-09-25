Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231A72E83F
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 01:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727228779; cv=none; b=F81pbA4aH376zS5lfR+jsa9T4ndtvoQn1SuNUtB+l8fVvp7DqnM9DiSe6CgPEhMaXbQCk+PAskSVp9US1hRPmfF+Yv/oaTf6rX/aUfED76CKJ7RlL8x6sfPwOTpNtTgdzCT4OS53PqICHAcX/PIqzprQYhKWijqiyUE6wIsSrrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727228779; c=relaxed/simple;
	bh=xUF69c+JXEl4NVUwF1HduHLgeTxgdRww8qHXpky5/BE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DRxtTfw3/IztHh42HxH2xFNWy7d+FEgEhi83VJzEBWlACMy2Xt182GJXrEXnox1MKoyVQ+hudsR4fEhDrf2pxlSlDeSbQ6KbYCaNwci/16HSGpv/OPMkE8tmFQKUWuzbecGOqTW+a1F8zoSI/LjBXwCy8WUno2nXDoZdhQyvGeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DVfxL+tO; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DVfxL+tO"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c721803a89so66906a12.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 18:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727228775; x=1727833575; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WPyihdkphzHjYHkiFltgJ2kdLQLirrIMMdhZ8LE0uX0=;
        b=DVfxL+tOdPFWW4PVOXFe6V3R1x20HQrmE6C7eUXEpqjVGKcrWOAI9XeHVSagCbGb55
         vwF/kuYhw1WdHJZM4ov9ZLQ/RZiCnR+Oxlun3dQmXCdKkYomTB3upwLZx+iQ5UZcMp/W
         krXsje5rUn9v7tuvVYP8tPuyzfJ+ce6mlehAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727228775; x=1727833575;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPyihdkphzHjYHkiFltgJ2kdLQLirrIMMdhZ8LE0uX0=;
        b=k3NO4b67DoaPxhZmYArC5z86RYhwXDkWs9gqdCMNTbZNTSW3/RtmeCYda5G9wGuPVh
         3+x6IRMlNG95+YlsjhY6R45hfH4fIuQOyoJ9vm7BaWL+NpwImp/8jM5d+BP9Lhwln5OZ
         sYzEBFpXCkhBo3ctWP+8eJM1Yl5mjUXUyTbQts+5mOfqEOoYFYR5yI2sh7tMa298fLR/
         PA2qSQot2YOM70BoAqG7seJCqRqstu1kD2BaMRIzcU1UsUpu/T7XlkW5a0geyl92U+K+
         z+OQPSMyybSxPLF480+yrM9odEAkLpjaIzn65yuWAbVA3BSiqyo6PLbQX2T7+yGc4U+D
         qF2g==
X-Forwarded-Encrypted: i=1; AJvYcCVY9h+heoWhs+2kfKSRm1D3NI9WZ1qdrF0ZaX6mZr9c62+qXhDLG5fS1PnLclgQQE64ydo4EODlqWoMD3500A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6XG6CyCnrGtjpbunRbC8F9mtZKB/XtjJ38NDG93l1Nd/O5c2I
	6rpnt+LJ4YLxNXC0KJNcBJwXdG6rbQ+0M3OECnuxGLWLBG99tU0/fK6gOSwqa5Lmy9qhx1T5gFf
	vwuB1Mg==
X-Google-Smtp-Source: AGHT+IEvTtkjH4BBOUGWM1J2OfslrlJxoYPbB8CBOMHqBxUE9lePGbxNkXOJgnIoYU/vH+/KwHY2aA==
X-Received: by 2002:a17:907:f1c9:b0:a86:7514:e646 with SMTP id a640c23a62f3a-a93a05d63dcmr89337766b.42.1727228775104;
        Tue, 24 Sep 2024 18:46:15 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9392f4f62bsm153277366b.47.2024.09.24.18.46.12
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 18:46:13 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c4146c7d5dso7908747a12.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 18:46:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXnDamFnmvSATr+JD2ThiemfrPRmHHmsfSi80W3v3pqBKl91g9YeXWuylPIV2N2wqelkfKSkFz2rQVeglDeKA==@vger.kernel.org
X-Received: by 2002:a17:907:e6ca:b0:a8a:8915:6bf7 with SMTP id
 a640c23a62f3a-a93a05de3a2mr90554066b.51.1727228771898; Tue, 24 Sep 2024
 18:46:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
 <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>
 <ZvIHUL+3iO3ZXtw7@dread.disaster.area> <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
 <CAHk-=wh+atcBWa34mDdG1bFGRc28eJas3tP+9QrYXX6C7BX0JQ@mail.gmail.com>
 <ZvI4N55fzO7kg0W/@dread.disaster.area> <CAHk-=wjNPE4Oz2Qn-w-mo1EJSUCQ+XJfeR3oSgQtM0JJid2zzg@mail.gmail.com>
 <ZvNWqhnUgqk5BlS4@dread.disaster.area>
In-Reply-To: <ZvNWqhnUgqk5BlS4@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Sep 2024 18:45:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+zqs3CYOiua3qLeGkqfDXQ0kPiNUWTmXLr_4dWjLSDw@mail.gmail.com>
Message-ID: <CAHk-=wh+zqs3CYOiua3qLeGkqfDXQ0kPiNUWTmXLr_4dWjLSDw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Sept 2024 at 17:17, Dave Chinner <david@fromorbit.com> wrote:
>
> FWIW, I think all this "how do we cache inodes better" discussion is
> somehwat glossing over a more important question we need to think
> about first: do we even need a fully fledged inode cache anymore?

I'd be more than happy to try. I have to admit that it's largely my
mental picture (ie "inode caches don't really matter"), and why I was
surprised that the inode locks even show up on benchmarks.

If we just always drop inodes when the refcount goes to zero and never
have any cached inodes outside of other references, I think most of
the reasons for the superblock inode list just disappear. Most of the
heavy lifting has long since been moved to the dentry shrinking.

I'd worry that we have a lot of tuning that depends on the whole inode
LRU thing (that iirc takes the mapping size etc into account).

But maybe it would be worth trying to make I_DONTCACHE the default,
with the aim of removing the independent inode lifetimes entirely...

                Linus
