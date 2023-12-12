Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="I3dMZkeC"
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0700AC
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 07:57:54 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-551d6c57f7dso402685a12.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 07:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1702396673; x=1703001473; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QcjfNw9LjOnl1LGPkfJnkRKHo3nwdvD6nUjnDoPrLs8=;
        b=I3dMZkeCmr0mmyClHh5SO2GbMKwrg4kGYWj/ZWZNystp3B7APsm5AyCt5ps++7s6wx
         3r/AX4O6igJfykvamzbRdfuHU6gYGq0dQffXPvBrjVz6V2fXKVcviUNcUBl5josVQ3Ht
         ZuAj51oWE04jIjh/OXM+F32atjG8DjlyPcSYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702396673; x=1703001473;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QcjfNw9LjOnl1LGPkfJnkRKHo3nwdvD6nUjnDoPrLs8=;
        b=uvAHMmUrYZJh68sFqrm62ZOtviNtd0DQCZS6dhC4lP5FywhWDHnYRrgjRGnIcU+Cpd
         eR+DtNGNHPdzS7W+L63J7vEnFwhXwJR9Euiei/kgJBbKwYJ4kWlF5Ns6yhSsOo5BNA0E
         yT+1EMAYYifeY43JkWuYEF+eDvPPa+X7LYLdAv4iW+OgeS3Y+9iaTBR5gkIVRNo7qB7r
         A0MbS9mwyf5I2b1AMwaFjTPp45uBHzl7Qhud2u6TmFIFGlMDRdLksQmVRG8Jrvv4jnjJ
         of52LFm0h5z+0A84qTZzKa5fbiG04OxzS5b6Ygf5rTQgq89gttOillxbyrXFV2V5+qQw
         bnmA==
X-Gm-Message-State: AOJu0YxdvdWs4p6ZBDqFLcQeKVTN3qkosFcaUNSiTCU6SJj6w7I+xjgQ
	KhotNfz4iI5kGpi6KofLLnZku/2PnjXEVAq1m1ttRQ==
X-Google-Smtp-Source: AGHT+IGdqEaSJdiV/ThZVe+ckGfQNhcCH4Qtp9SxidszZ93kllZx9tB5FCVPShMn8VgZKewKvDeFiXI1IrFCwo1smso=
X-Received: by 2002:a17:907:7287:b0:a19:a1ba:8ce5 with SMTP id
 dt7-20020a170907728700b00a19a1ba8ce5mr3668430ejc.131.1702396673167; Tue, 12
 Dec 2023 07:57:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan> <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area> <CAOQ4uxiQcOk1Kw1JX4602vjuWNfL=b_A3uB1FJFaHQbEX6OOMA@mail.gmail.com>
 <20231212-impfung-linden-6f973f2ade19@brauner> <20231212151631.wi7rgawmp3uig6cl@moria.home.lan>
 <20231212-neudefinition-hingucken-785061b73237@brauner> <20231212153542.kl2fbzrabhr6kai5@moria.home.lan>
 <CAJfpegsKsbdtUHUPnu3huCiPXwX46eKYSUbLXiWqH23GinXo7w@mail.gmail.com> <20231212154302.uudmkumgjaz5jouw@moria.home.lan>
In-Reply-To: <20231212154302.uudmkumgjaz5jouw@moria.home.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 12 Dec 2023 16:57:41 +0100
Message-ID: <CAJfpegvOEZwZgcbAeivDA+X0qmfGGjOxdvq-xpGQjYuzAJxzkw@mail.gmail.com>
Subject: Re: file handle in statx (was: Re: How to cope with subvolumes and
 snapshots on muti-user systems?)
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>, 
	Donald Buczek <buczek@molgen.mpg.de>, linux-bcachefs@vger.kernel.org, 
	Stefan Krueger <stefan.krueger@aei.mpg.de>, David Howells <dhowells@redhat.com>, 
	linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Dec 2023 at 16:43, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Tue, Dec 12, 2023 at 04:38:29PM +0100, Miklos Szeredi wrote:
> > On Tue, 12 Dec 2023 at 16:35, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > > Other poeple have been finding ways to contribute to the technical
> > > discussion; just calling things "ugly and broken" does not.
> >
> > Kent, calm down please.  We call things "ugly and broken" all the
> > time.  That's just an opinion, you are free to argue it, and no need
> > to take it personally.
>
> It's an entirely subjective judgement that has no place in a discussion
> where we're trying to decide things on technical merits.

Software is like architecture.  It must not collapse, but to function
well it also needs to look good.  That's especially relevant to APIs,
and yes, it's a matter of taste and can be very subjective.

On this particular point (STATX_ATTR_INUM_NOT_UNIQUE) I can completely
understand Christian's reaction.  But if you think this would be a
useful feature, please state your technical argument.

Thanks,
Miklos
