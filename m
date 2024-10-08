Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68B6AD2F
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 00:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347361; cv=none; b=QT79z3DKcsxhxnrxrDelRkDMCL8An1Jvob+nIVh09/MaIMtodLkshegvpFTHqo6C33SKA0IcgHKtUGHJBHUV66x7Zf+iztTP8k/JZw8UiqaHen5f3LgzcAEn5UrP/20wctim/Ext8d3uESE+c2j8Tgc96L4S5mlFbEan5fRP0uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347361; c=relaxed/simple;
	bh=Tke8szf/tF+Zw53GGM7FveqgBu9sg0bXcPAEsM0e6AA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uh90jaK2xSK3Q+H/AytvagzIvP/7WClrceUzEWsi4cJDauoFh3XpFxBxg3JmTYFYB42Esb6ZDy6F1iVsZT45kd0INZHfcLMKdhob8c89NCuNfmJDPOFZa8cpfbOpdYYqRpsWhIMvrfMNpH/vqUyOGMz44EviPu4gSX6o4vv4SGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AR2tTX9H; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AR2tTX9H"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a83562f9be9so538668166b.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Oct 2024 17:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728347357; x=1728952157; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nsQ1lX9RfNwwbE7U1ME2PBLb06zd6P+Kklt61iLJfEw=;
        b=AR2tTX9HBlL/W9yjK2piwlcap/02uEM9V0f8UNjlhxk4xePTbvIBWL3IZk1RN4my9t
         w1C/JByxdAQ3AHHZ+OjWV1PrCDadN6sKLBjqhjycwuF7B5M607bOUOAWpdpjwFnwrRrI
         uLBBkrOSfVJyGQ0K8KyvBzaZ5r3aIpTKtk6hQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728347357; x=1728952157;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nsQ1lX9RfNwwbE7U1ME2PBLb06zd6P+Kklt61iLJfEw=;
        b=VUBgPQ27Ta3+cnWTEG5X15Ela7b/RE18bNon1nJYsF8i8hAE8eu/zKCgwce+V+U3B4
         xRTuiUFF+mGsc5mQLVsm0jTk7kZg3SrlzdFnPWVk5VSf8xFaKiS6CAuxM1FnLH0ay1Pd
         m8wqodvGU6ftnw61qPv2UbUhEve4g8B2QcSOtRGGQ4Bylmb3hxldnAxV8kans2tYI/q6
         6iy0qMKFaZKrw5LJfPTXr5at0VZQ3FCghjlsHfu335HJd543JsCcj36ih8yS54NgvAts
         dfIXtm9kP44kCKVrBTlt3vwchL1Cmkk+yngE/x7q90fwqL48ZGnLz+R5RC6jRwu9Cfkt
         3zkw==
X-Forwarded-Encrypted: i=1; AJvYcCWf11tXarKUc8o7sSZXPZ2tjnv0GnI4fMdJOqiV93NNs8kgXMLgZrd6X6B7L3wYUwkLh9QSML8hwTg6g8nlxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlgwSa1+duNXl8/3+RQWALnzJJ0TUApbHxQ2+nejp3XgQh+5jx
	8p5kDbjCD7IWcx0oSifB1DObHoCck343Xa59gKhU3GiHyNLogJ0J9HbVpNVsZXfIMde/FCsLiWI
	NOVCkEQ==
X-Google-Smtp-Source: AGHT+IHmWVbqY0WApeuYhjqc+Me0DtbTU0ZDpayTad9c5kDDqdsLGAQW8jyfuIqfu7elRrepBglVMA==
X-Received: by 2002:a17:907:2687:b0:a8d:fa3:bb24 with SMTP id a640c23a62f3a-a991bd1f7damr1459370566b.23.1728347356729;
        Mon, 07 Oct 2024 17:29:16 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a992e5d0a32sm445938066b.19.2024.10.07.17.29.14
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:29:14 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c89668464cso6707347a12.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Oct 2024 17:29:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVtFJfXVw7xqriuUui2R+la4cvbBBMakEOnqu9HryrSNUcARkfyA6wg6ry9Gsdj/RLNZzDOj8k1shocRaC4sg==@vger.kernel.org
X-Received: by 2002:a17:906:6a19:b0:a99:762f:b296 with SMTP id
 a640c23a62f3a-a99762fbb7fmr20741966b.59.1728347354279; Mon, 07 Oct 2024
 17:29:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002014017.3801899-1-david@fromorbit.com> <20241002014017.3801899-5-david@fromorbit.com>
 <Zv5GfY1WS_aaczZM@infradead.org> <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3> <CAHk-=whg7HXYPV4wNO90j22VLKz4RJ2miCe=s0C8ZRc0RKv9Og@mail.gmail.com>
 <ZwRvshM65rxXTwxd@dread.disaster.area>
In-Reply-To: <ZwRvshM65rxXTwxd@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Oct 2024 17:28:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
Message-ID: <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert sb->s_inodes
 iteration to super_iter_inodes()
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	kent.overstreet@linux.dev, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, 
	linux-security-module@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Oct 2024 at 16:33, Dave Chinner <david@fromorbit.com> wrote:
>
> There may be other inode references being held that make
> the inode live longer than the dentry cache. When should the
> fsnotify marks be removed from the inode in that case? Do they need
> to remain until, e.g, writeback completes?

Note that my idea is to just remove the fsnotify marks when the dentry
discards the inode.

That means that yes, the inode may still have a lifetime after the
dentry (because of other references, _or_ just because I_DONTCACHE
isn't set and we keep caching the inode).

BUT - fsnotify won't care. There won't be any fsnotify marks on that
inode any more, and without a dentry that points to it, there's no way
to add such marks.

(A new dentry may be re-attached to such an inode, and then fsnotify
could re-add new marks, but that doesn't change anything - the next
time the dentry is detached, the marks would go away again).

And yes, this changes the timing on when fsnotify events happen, but
what I'm actually hoping for is that Jan will agree that it doesn't
actually matter semantically.

> > Then at umount time, the dentry shrinking will deal with all live
> > dentries, and at most the fsnotify layer would send the FS_UNMOUNT to
> > just the root dentry inodes?
>
> I don't think even that is necessary, because
> shrink_dcache_for_umount() drops the sb->s_root dentry after
> trimming the dentry tree. Hence the dcache drop would cleanup all
> inode references, roots included.

Ahh - even better.

I didn't actually look very closely at the actual umount path, I was
looking just at the fsnotify_inoderemove() place in
dentry_unlink_inode() and went "couldn't we do _this_ instead?"

> > Wouldn't that make things much cleaner, and remove at least *one* odd
> > use of the nasty s_inodes list?
>
> Yes, it would, but someone who knows exactly when the fsnotify
> marks can be removed needs to chime in here...

Yup. Honza?

(Aside: I don't actually know if you prefer Jan or Honza, so I use
both randomly and interchangeably?)

> > I have this feeling that maybe we can just remove the other users too
> > using similar models. I think the LSM layer use (in landlock) is bogus
> > for exactly the same reason - there's really no reason to keep things
> > around for a random cached inode without a dentry.
>
> Perhaps, but I'm not sure what the landlock code is actually trying
> to do.

Yeah, I wouldn't be surprised if it's just confused - it's very odd.

But I'd be perfectly happy just removing one use at a time - even if
we keep the s_inodes list around because of other users, it would
still be "one less thing".

> Hence, to me, the lifecycle and reference counting of inode related
> objects in landlock doesn't seem quite right, and the use of the
> security_sb_delete() callout appears to be papering over an internal
> lifecycle issue.
>
> I'd love to get rid of it altogether.

Yeah, I think the inode lifetime is just so random these days that
anything that depends on it is questionable.

The quota case is probably the only thing where the inode lifetime
*really* makes sense, and that's the one where I looked at the code
and went "I *hope* this can be converted to traversing the dentry
tree", but at the same time it did look sensible to make it be about
inodes.

If we can convert the quota side to be based on dentry lifetimes, it
will almost certainly then have to react to the places that do
"d_add()" when re-connecting an inode to a dentry at lookup time.

So yeah, the quota code looks worse, but even if we could just remove
fsnotify and landlock, I'd still be much happier.

             Linus
