Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="G3QoH3Nb"
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39F3E4
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 08:30:36 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-a1da1017a09so714279566b.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 08:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1702398635; x=1703003435; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=myMRBPovP/7/r8peG8VTqC6y7u4an2akYPL/sNmZaYA=;
        b=G3QoH3NbI8T+HBVFThHszhnVRfb2EdVEVFGEUkAFmY7/IGZNwZgq/yzGqa2w8dV5x5
         BO3uZHt+8DejQrny2xSMhgIXBNOiUPHsi3BDJchcV6zlPsHZ1FApNXxzHoIQH8IA6uid
         yn0jZjtiVFNe7Gn6s6IoB7/CCRSYJmIvoyXx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702398635; x=1703003435;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=myMRBPovP/7/r8peG8VTqC6y7u4an2akYPL/sNmZaYA=;
        b=VHdVITBzltziSaYpMULWmTMiwH+vesqjyOOR/3V5GsSAWzW8NUDro/dABOaPTuPK38
         v+b/zPq/pr7hRE1T8Y2zH3L8SwdAo+4vIyX//8fxiC1zkstbU1H5jX3cZo53rq/Vbqi3
         7nXTA9dA6UiY5JJSTdFR/KM5Od4CKKFBZ31b7jTID3mTXyUwrniLpMNVy1++GqkSUWHi
         leVXiHdbm5ywD5q/FaFdSLzGRwq+DhDmM2tjPn5ind+FN+3mJ7ZUVm3shsTbLT91iWfH
         cbaHK/8EjceP6vBeFe8rlcQrbtzrTE74wO1NX6BhRYO6W1XnZeFhif2MVdzjXTdcWg7i
         0w9g==
X-Gm-Message-State: AOJu0YxWZxOK1IOXB4q4UpaqWIbsFniqSbYoYM+JJzhPLibc/fJSHMUQ
	QE5dXDmNCrvgM8ucHgG8cHOs2vf7d/zc+ZDNjd45aA==
X-Google-Smtp-Source: AGHT+IHKcYuqeFb/mTcEp+89My9A5o5DC0pPHMZ/0Mo4P/b66szo7CfzlcRIbubca3sB3z+pXUMRaKo1lev9HEbsqsQ=
X-Received: by 2002:a17:906:d8b7:b0:a18:e2b8:ff1b with SMTP id
 qc23-20020a170906d8b700b00a18e2b8ff1bmr3369726ejb.1.1702398634711; Tue, 12
 Dec 2023 08:30:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area> <CAOQ4uxiQcOk1Kw1JX4602vjuWNfL=b_A3uB1FJFaHQbEX6OOMA@mail.gmail.com>
 <20231212-impfung-linden-6f973f2ade19@brauner> <20231212151631.wi7rgawmp3uig6cl@moria.home.lan>
 <20231212-neudefinition-hingucken-785061b73237@brauner> <20231212153542.kl2fbzrabhr6kai5@moria.home.lan>
 <CAJfpegsKsbdtUHUPnu3huCiPXwX46eKYSUbLXiWqH23GinXo7w@mail.gmail.com>
 <20231212154302.uudmkumgjaz5jouw@moria.home.lan> <CAJfpegvOEZwZgcbAeivDA+X0qmfGGjOxdvq-xpGQjYuzAJxzkw@mail.gmail.com>
 <20231212160829.vybfdajncvugweiy@moria.home.lan>
In-Reply-To: <20231212160829.vybfdajncvugweiy@moria.home.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 12 Dec 2023 17:30:23 +0100
Message-ID: <CAJfpegvNVXoxn3gW9-38YfY5u0FLjXTCDxcv5OtS-p0=0ocQvg@mail.gmail.com>
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

On Tue, 12 Dec 2023 at 17:08, Kent Overstreet <kent.overstreet@linux.dev> wrote:

> In short, STATX_ATTR_INUM_NOT_UNIQUE is required to tell userspace when
> they _must_ do the new thing if they care about correctness; it provides
> a way to tell userspace what guarantees we're able to provide.

That flag would not help with improving userspace software.

What would help, if said software started using a unique identifier.
We already seem to have a unique ID in the form of file handles,
though some exotic filesystems might allow more than one fh to refer
to the same inode, so this still needs some looking into.

The big problem is that we can't do a lot about existing software, and
must keep trying to keep st_ino unique for the foreseeable future.

Thanks,
Miklos
