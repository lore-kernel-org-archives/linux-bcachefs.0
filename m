Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LSiRXK6k"
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AA9106
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 06:06:22 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-a00cbb83c80so654426466b.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 06:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1702389980; x=1702994780; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T9PLSAQZI0NwJjMZpWWj+Z6fnoMkBkiiBjHJ6/wdc/w=;
        b=LSiRXK6kE0wff9TtR4ohY8tS0/Zy/UqXFKOfcOcx1wPn6h9v1RH/maMdnoh4avG0t5
         kng3TtyPsvggSzqerYS0RbE90eXrgK+XBXDubtQcA7Neh+GZlX/EGUUV1sxFIvvEW7uQ
         YUJNgDoE+L0XTHltv7bPzlvAAaLrHeTp5HKlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702389980; x=1702994780;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9PLSAQZI0NwJjMZpWWj+Z6fnoMkBkiiBjHJ6/wdc/w=;
        b=iQdwjchwnXqFmQLqdHtvIpTnL+qxRDKu2/QIdpk6qKwRwQwg4C9ZM72SzwNETJw3x2
         WF2cwRp7SVk8vmXwC78DtJbFvHi2EIarc6rVo00WQlyJ7dLsGUgCQvy9xh7gAudCq9Ka
         qg4yxOBdccxYaxfno8WZiQ97CNpuxqPmYpI4fZfVSelW0SrHDyzuMYx0BeuzcsbLHP3O
         +gyaTubo5lKAJWWUZT/4BK1ZvB6VAdZ64Ok4w1H8GvnBZB55meLL9+exBxgw7CjbMddY
         8O90r2UccviT35IpIqEaRVW+enRHZpUU4w3pkw9RqF3rTQLmhdIFaYu0eLv8ORu5mGBX
         DXaw==
X-Gm-Message-State: AOJu0Yy8xp0W1RPZGI5+9Y9wfU5Ik4gA4rNI214RI1yWZSwduYRfVj2H
	nHVx29BOzVWKiP/kaPts7BHrG7EotPm5dIJqs0jkkg==
X-Google-Smtp-Source: AGHT+IE8/unfFBGUsACmdLQl4gCXwGjqPvgH1AmcsYVBiGEGVrWOObehrOvHzO7IJQO6G0O0LiBXAwjjrTZXhmAQHs0=
X-Received: by 2002:a17:906:6a29:b0:a18:9ac9:27c2 with SMTP id
 qw41-20020a1709066a2900b00a189ac927c2mr3527206ejc.53.1702389980291; Tue, 12
 Dec 2023 06:06:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan> <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area> <CAOQ4uxiQcOk1Kw1JX4602vjuWNfL=b_A3uB1FJFaHQbEX6OOMA@mail.gmail.com>
 <2810685.1702372247@warthog.procyon.org.uk> <20231212-ablauf-achtbar-ae6e5b15b057@brauner>
 <CAJfpegvL9kV+06v2W+5LbUk0eZr1ydfT1v0P-Pp_KexLNz=Lfg@mail.gmail.com>
 <20231212-sechzehn-hausgemacht-6eb61150554e@brauner> <CAJfpegshsEWtm-dcdUy2w9_ic0Ag7GXpA2yRWGR+LD2T37odGQ@mail.gmail.com>
 <20231212-kahlschlag-abtropfen-51dc89b9ac11@brauner>
In-Reply-To: <20231212-kahlschlag-abtropfen-51dc89b9ac11@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 12 Dec 2023 15:06:07 +0100
Message-ID: <CAJfpegu3uwAjMQd2jrBty0Lx-oHOczF0x6xNkyqcT4MBqyJo7Q@mail.gmail.com>
Subject: Re: file handle in statx (was: Re: How to cope with subvolumes and
 snapshots on muti-user systems?)
To: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Amir Goldstein <amir73il@gmail.com>, 
	Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Donald Buczek <buczek@molgen.mpg.de>, 
	linux-bcachefs@vger.kernel.org, Stefan Krueger <stefan.krueger@aei.mpg.de>, 
	linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Dec 2023 at 14:48, Christian Brauner <brauner@kernel.org> wrote:

> Exposing the subvolume id in statx() is still fine imho. It's a concept
> shared between btrfs and bcachefs and it's pretty useful for interested
> userspace that wants to make use of these apis.

Exposing subvolume ID should be okay, as long as it's not advertised
as a way to uniquely identify an inode.   Its use should be limited to
finding subvolume boundaries.

> > It might help to have the fh in statx, since that's easier on the
> > userspace programmer than having to deal with two interfaces (i_ino
> > won't go away for some time, because of backward compatibility).
> > OTOH I also don't like the way it would need to be shoehorned into
> > statx.
>
> No, it really doesn't belong into statx().
>
> And besides, the file handle apis name_to_handle_at() are already
> in wider use than a lot of people think. Not just for the exportfs case
> but also for example, cgroupfs uses file handles to provide unique
> identifiers for cgroups that can be compared.

The issue with name_to_handle_at() is its use of the old, non-unique
mount ID.  Yes, yes, we can get away with

 fd = openat(dfd, path, O_PATH);
 name_to_handle_at(fd, "", ..., AT_EMPTY_PATH);
 statx(fd, "", AT_EMPTY_PATH, STATX_MNT_ID_UNIQUE, ...);
 close(fd);

But that's *four* syscalls instead of one...

Thanks,
Miklos
